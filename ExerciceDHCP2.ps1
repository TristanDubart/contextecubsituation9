#NAME : ExerciceDHCP2.ps1
#AUTHOR : Dubart Tristan, CUB
#DATE : 27/03/2024
#
#VERSION : 1.1
#COMMENTS : Demande à l'utilisateur les informations pour la création d'une étendu DHCP, mais cette fois avec le nom de domaine en plus et l'adresse IP du serveur de domaine.

# Demander à l'utilisateur les informations pour créer l'étendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'étendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse réseau de l'étendue DHCP (format CIDR, ex: 192.168.1.0/24)"
$masqueSousReseau = Read-Host "Entrez le masque de sous-réseau de l'étendue"
$premiereAdresse = Read-Host "Entrez la première adresse à attribuer"
$derniereAdresse = Read-Host "Entrez la dernière adresse à attribuer"
$passerelle = Read-Host "Entrez l'adresse de passerelle à diffuser"
$nomDomaine = Read-Host "Entrez le nom de domaine"
$adresseServeurDomaine = Read-Host "Entrez l'adresse IP du serveur de domaine"

# Afficher les informations saisies par l'utilisateur pour vérification
Write-Host "Nom de l'étendue DHCP : $nomEtendue"
Write-Host "Adresse réseau : $adresseReseau"
Write-Host "Masque de sous-réseau : $masqueSousReseau"
Write-Host "Première adresse à attribuer : $premiereAdresse"
Write-Host "Dernière adresse à attribuer : $derniereAdresse"
Write-Host "Adresse de passerelle à diffuser : $passerelle"
Write-Host "Nom de domaine : $nomDomaine"
Write-Host "Adresse IP du serveur de domaine : $adresseServeurDomaine"

# Demander à l'utilisateur de valider les informations
$confirmation = Read-Host "Voulez-vous créer cette étendue DHCP ? (Oui/Non)"

if ($confirmation -eq "Oui") {
    # Créer l'étendue DHCP en utilisant les informations saisies
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau
    Set-DhcpServerv4OptionValue -OptionId 6 -Value "$nomDomaine" -ScopeId $adresseReseau
    Set-DhcpServerv4OptionValue -OptionId 15 -Value "$nomDomaine" -ScopeId $adresseReseau
    Set-DhcpServerv4OptionValue -OptionId 44 -Value "$adresseServeurDomaine" -ScopeId $adresseReseau
    Write-Host "L'étendue DHCP a été créée avec succès."
} else {
    Write-Host "Opération annulée. L'étendue DHCP n'a pas été créée."
}
