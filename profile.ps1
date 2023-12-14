# this profile script is hardening the acces to the powershell without using application controll


# this file needs to be created at C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1
# define shell granted users at the $admins array
$admins = @("sylvio","koenig","traeger","NT\Authority","System")

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Hide-Console {
$consolePtr = [Console.Window]::GetConsoleWindow()
#0 hide
#1 show
[Console.Window]::ShowWindow($consolePtr, 0)
}

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$Form = New-Object System.Windows.Forms.Form

if (!($admins -contains $env:username))
{
hide-console
Get-Process -Name powershell* | Stop-Process
}
