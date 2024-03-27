#NAME : ExerciceDHCP3.ps1
#AUTHOR : Dubart Tristan, CUB
#DATE : 27/03/2024
#
#VERSION : 1.1
#COMMENTS : Demande à l'utilisateur les informations pour la création d'une étendue DHCP.

# Charger l'assembly System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

# Fonction pour afficher une boîte de dialogue d'entrée
function Show-InputBoxDialog {
    param (
        [string]$message,
        [string]$title
    )

    $inputBox = New-Object System.Windows.Forms.TextBox
    $inputBox.Width = 300
    $inputBox.Location = New-Object System.Drawing.Point(10,30)

    $form = New-Object Windows.Forms.Form
    $form.Text = $title
    $form.Size = New-Object System.Drawing.Size(350,150)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.Controls.Add($inputBox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(200,70)
    $okButton.Size = New-Object System.Drawing.Size(100,30)
    $okButton.Text = "OK"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(100,70)
    $cancelButton.Size = New-Object System.Drawing.Size(100,30)
    $cancelButton.Text = "Cancel"
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,10)
    $label.Size = New-Object System.Drawing.Size(300,20)
    $label.Text = $message
    $form.Controls.Add($label)

    $form.Topmost = $true
    $form.Add_Shown({$form.Activate()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $inputBox.Text
    } else {
        return $null
    }
}

# Demander à l'utilisateur les informations pour créer l'étendue DHCP
$nomEtendue = Show-InputBoxDialog -message "Entrez le nom de l'étendue DHCP :" -title "Nom de l'étendue"
$adresseReseau = Show-InputBoxDialog -message "Entrez l'adresse réseau de l'étendue DHCP (format CIDR, ex: 192.168.1.0/24) :" -title "Adresse réseau"
$masqueSousReseau = Show-InputBoxDialog -message "Entrez le masque de sous-réseau de l'étendue :" -title "Masque de sous-réseau"
$premiereAdresse = Show-InputBoxDialog -message "Entrez la première adresse à attribuer :" -title "Première adresse"
$derniereAdresse = Show-InputBoxDialog -message "Entrez la dernière adresse à attribuer :" -title "Dernière adresse"
$passerelle = Show-InputBoxDialog -message "Entrez l'adresse de passerelle à diffuser :" -title "Adresse de passerelle"
$nomDomaine = Show-InputBoxDialog -message "Entrez le nom de domaine :" -title "Nom de domaine"
$adresseServeurDomaine = Show-InputBoxDialog -message "Entrez l'adresse IP du serveur de domaine :" -title "Adresse IP du serveur de domaine"

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
$confirmation = [System.Windows.Forms.MessageBox]::Show("Voulez-vous créer cette étendue DHCP ?", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::YesNo)

if ($confirmation -eq "Yes") {
    # Créer l'étendue DHCP en utilisant les informations saisies
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau
    Set-DhcpServerv4OptionValue -OptionId 6 -Value "$nomDomaine" -ScopeId $adresseReseau
    Set-DhcpServerv4OptionValue -OptionId 15 -Value "$nomDomaine" -ScopeId $adresseReseau
    Set-DhcpServerv4OptionValue -OptionId 44 -Value "$adresseServeurDomaine" -ScopeId $adresseReseau
    Write-Host "L'étendue DHCP a été créée avec succès."
} else {
    Write-Host "Opération annulée. L'étendue DHCP n'a pas été créée."
}
