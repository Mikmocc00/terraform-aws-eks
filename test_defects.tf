# ==========================================================
# FILE DI TEST: POSSIBILI DIFETTI CONFIG E DOCUMENTAZIONE
# ==========================================================

# 1. DIFETTO DOCUMENTATION: 
# Variabile senza 'type' e senza 'description'. 
# Questo è un segnale forte per il miner di mancanza di documentazione.
variable "api_key" {
  default = "AKIA-SECRET-12345" 
}

# 2. DIFETTO CONFIGURATION DATA:
# Hardcoding di dati sensibili e configurazioni di rete.
resource "aws_db_instance" "database_test" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  
  # ERRORE: Credenziali in chiaro (Config Data Defect)
  name                 = "mydb"
  username             = "admin"
  password             = "PasswordMoltoInsicura123!" 
  
  # ERRORE: Parametro critico hardcoded invece di usare una variabile
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  skip_final_snapshot  = true
}

# 3. DIFETTO DOCUMENTATION & CONFIG:
# Una risorsa complessa (Security Group) con regole "wide open" 
# e totale assenza di commenti (#) o descrizioni.
resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  # Manca la description qui

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # ERRORE: CIDR wide open hardcoded (Config Data)
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Nessun tag 'Name' o commento esplicativo
}

# 4. ALTRO DIFETTO DOCUMENTATION:
# Output senza descrizione dello scopo.
output "db_endpoint" {
  value = aws_db_instance.database_test.endpoint
  # ERRORE: Manca la description dell'outputsssslamk
}
