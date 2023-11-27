# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
    $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
  }
}

Add-Type -AssemblyName System.Windows.Forms

Push-Location $env:TEMP
Invoke-WebRequest "https://github.com/thebookisclosed/ViVe/releases/download/v0.3.3/ViVeTool-v0.3.3.zip" -OutFile ".\vivetool.zip"
Expand-Archive ".\vivetool.zip" -DestinationPath ".\vivetool"

Push-Location ".\vivetool"
.\ViVeTool.exe /enable /id:44774629,44776738,44850061,42105254,41655236
Pop-Location

Remove-Item -Recurse -Force ".\vivetool"
Remove-Item ".\vivetool.zip"
Pop-Location

$ConfirmBox = [System.Windows.Forms.MessageBox]::Show("Would you like to reboot your computer to enable Windows Copilot?", "Shutdown Confirmation",  [System.Windows.Forms.MessageBoxButtons]::YesNo)

If ($ConfirmBox -eq "Yes") {
  Restart-Computer
}
