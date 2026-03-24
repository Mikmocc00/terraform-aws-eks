# Risorsa per generare una password casualea
# Questa configurazione serve per il database
resource "random_password" "password_sicura" {
  length  = 16

  special = true
}

# Fine del file
