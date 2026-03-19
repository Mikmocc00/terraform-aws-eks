#!/bin/python3

import json
import os
import requests
import sys
from github import Github
from repominer.metrics.terraform import TerraformMetricsExtractor

# --- FIX PER L'ERRORE GIT IN GITHUB ACTIONS ---
# Eseguiamo questo comando a runtime prima di tutto, 
# così GitHub non può cancellare il permesso!
os.system("git config --global --add safe.directory '*'")

# 1. Sicurezza: questa action ora è dedicata solo a Terraform
language = os.getenv('INPUT_LANGUAGE')
if language != 'terraform':
    print('Questa Action locale supporta solo Terraform. Esecuzione interrotta.')
    sys.exit(0)

g = Github(os.getenv('GITHUB_TOKEN'))
repo = g.get_repo(os.getenv('GITHUB_REPOSITORY'))
files = repo.get_commit(sha=os.getenv('GITHUB_SHA')).files

# 2. Inizializza l'estrattore Terraform
tf_extractor = TerraformMetricsExtractor(path_to_repo='/github/workspace', clone_repo_to='/github/workspace', at='release')

for file in files:
    # 3. Ignora automaticamente i file che non sono .tf
    if not file.filename.endswith('.tf'):
        continue

    content = repo.get_contents(file.filename, ref=os.getenv('GITHUB_SHA')).decoded_content.decode()
    metrics = {}

    try:
        # Estrae le metriche usando repominer
        metrics = tf_extractor.get_product_metrics(content)
    except Exception as e:
        print(f"⚠️ Errore di parsing in {file.filename}: {e}")
        sys.stdout.flush()
        metrics = {"syntax_error": 1}

    # 4. Prepara la chiamata al tuo backend Defuse su Ngrok
    url = f'{os.getenv("INPUT_URL")}/predict?model_id={os.getenv("INPUT_MODEL")}'
    for name, value in metrics.items():
        url += f'&{name}={value}'

    headers = {"ngrok-skip-browser-warning": "true"}
    
    # 5. Invia i dati e stampa il risultato
    try:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            response_content = json.loads(response.content.decode())
            print(f"✅ RISULTATO PREDIZIONE per {file.filename}:")
            print(json.dumps(response_content, indent=2))
        else:
            print(f"❌ Errore dal backend. Status: {response.status_code}")
            print(f"Dettaglio: {response.text}")
    except Exception as e:
        print(f"⚠️ Impossibile contattare il modello su Ngrok: {e}")

    sys.stdout.flush()
