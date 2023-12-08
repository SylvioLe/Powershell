Add-Type -Name Window -Namespace Console -MemberDefinition @'
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@
Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@
function Hide-Console {
$consolePtr = [Console.Window]::GetConsoleWindow()
	#0 hide
	#1 show
[Console.Window]::ShowWindow($consolePtr, 0)
}
function check-idle{
$meldungszeit= 5 #Angabe in Minuten
$Meldungszeit = New-TimeSpan -Minutes $meldungszeit
$timetoshutdown = 10 #Angabe in Minuten
$Timetoshutdown = New-TimeSpan -Minutes $timetoshutdown
$meldung = 0

while($true){
for ( $i = 1; $i -gt 0 ) {
	$lastinput = [PInvoke.Win32.UserInput]::LastInput
	$idletime = [PInvoke.Win32.UserInput]::IdleTime
    Write-Host ("Last input " + $lastinput)
    Write-Host ("Idle for " + $idletime)
    Start-Sleep -Seconds 5
	if(($idletime -gt $Meldungszeit)){msg.exe $env:USERNAME /time 5 "Der Rechner wird gleich herunterfahren wenn weiterhin keine Eingaben erfolgen"}
	if ($idletime -gt ($Meldungszeit + $Timetoshutdown)){shutdown /L ; shutdown /P /F }	
}
}
}
hide-console
check-idle
