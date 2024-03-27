#NAME : ExerciceDHCP1.ps1
#AUTHOR : Dubart Tristan, CUB
#DATE : 27/03/2024
#
#VERSION : 1.1
#COMMENTS : Demande à l'utilisateur les informations pour la création d'une étendu DHCP

# Demander à l'utilisateur les informations pour créer l'étendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'étendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse réseau de l'étendue DHCP (ex: 192.168.1.0)"
$masqueSousReseau = Read-Host "Entrez le masque de sous-réseau de l'étendue (ex: 255.255.255.0)"
$premiereAdresse = Read-Host "Entrez la première adresse à attribuer"
$derniereAdresse = Read-Host "Entrez la dernière adresse à attribuer"
$passerelle = Read-Host "Entrez l'adresse de passerelle à diffuser"

# Afficher les informations saisies par l'utilisateur pour vérification
Write-Host "Nom de l'étendue DHCP : $nomEtendue"
Write-Host "Adresse réseau : $adresseReseau"
Write-Host "Masque de sous-réseau : $masqueSousReseau"
Write-Host "Première adresse à attribuer : $premiereAdresse"
Write-Host "Dernière adresse à attribuer : $derniereAdresse"
Write-Host "Adresse de passerelle à diffuser : $passerelle"

# Demander à l'utilisateur de valider les informations
$confirmation = Read-Host "Voulez-vous créer cette étendue DHCP ? (Oui/Non)"

if ($confirmation -eq "Oui") {
    # Créer l'étendue DHCP en utilisant les informations saisies
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -State Active
    Set-DhcpServerv4OptionValue -Router $passerelle -OptionId 3 -Value $passerelle
    Write-Host "L'étendue DHCP a été créée avec succès."
} else {
    Write-Host "Opération annulée. L'étendue DHCP n'a pas été créée."
}
