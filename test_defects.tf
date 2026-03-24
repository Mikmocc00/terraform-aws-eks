# Risorsa per generare una password casualea
# Questa configurazione serve per il database
#ti dico che za
resource "random_password" "password_sicura" {
  length  = 16

  special = true
}

# Fine del file
