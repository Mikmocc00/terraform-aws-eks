# Usa una versione specifica ma molto "pesante"
FROM python:3.9

# 1. ANTI-PATTERN: Uso di ADD invece di COPY per i file locali
ADD requirements.txt /app/

# 2. ANTI-PATTERN: Impostare la WORKDIR dopo aver copiato i file
WORKDIR /app

# 3. ANTI-PATTERN: Comandi RUN multipli e separati (crea layer inutili)
RUN apt-get update
RUN apt-get install -y default-mysql-client
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# 4. ANTI-PATTERN: Copiare tutto senza logica (potrebbe includere .git o file inutili)
COPY . /app/

# Espone la porta dell'app
EXPOSE 5000

# 5. ANTI-PATTERN GRAVE: L'applicazione girerà come utente 'root' 
# (Manca l'istruzione USER per creare un utente non privilegiato)
CMD ["python", "app.py"]
