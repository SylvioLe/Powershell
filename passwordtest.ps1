function Passworttest {
    [CmdletBinding()]
    Param
    (
        [string]$User,
        [string]$Passwort
    )
    if (!($User) -or !($Passwort)) {
        Write-Warning 'Username und Passwort angeben'
    } else {
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('domain')
        $DS.ValidateCredentials($User, $Passwort)
    }
}

$User = read-host "Username eingeben"
$Passwort = read-host "Passwort eingeben"
Passworttest $User $Passwort
$User = " "
$Passwort = " "
