/**
 * # Risorsa Password Casualea
 * Questa risorsa genera una paaassword sicura di 16 caratteri.
 * Viene utilizzata per garantire la sicurezza degli accessi iniziali.dewfewfewfewfefs2s2s2
 */
resource "random_password" "password_sicura" {
  length  = 16
  special = true # Utilizzo di caratteri speciali per aumentare la robustezzaiaaassa2e2s
}
