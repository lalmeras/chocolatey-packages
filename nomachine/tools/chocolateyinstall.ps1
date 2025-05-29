$ErrorActionPreference = 'Stop';

$packageName= 'nomachine'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Make sure Print Spooler service is up and running
# stolen from hp-universal-print-driver-pcl/cutepdf package.
try {
  $serviceName = 'Spooler'
  $spoolerService = Get-WmiObject -Class Win32_Service -Property StartMode,State -Filter "Name='$serviceName'"
  if ($spoolerService -eq $null) { throw "Service $serviceName was not found" }
  Write-Host "Print Spooler service state: $($spoolerService.StartMode) / $($spoolerService.State)"
  if ($spoolerService.StartMode -ne 'Auto' -or $spoolerService.State -ne 'Running') {
    Set-Service $serviceName -StartupType Automatic -Status Running
    Write-Warning 'Print Spooler service new state: Auto / Running'
    Write-Warning 'NoMachine install is broken if Print Spooler is disabled'
    Write-Warning 'see https://twitter.com/LaurentAlmeras/status/1126175028993769482'
  }
} catch {
  throw "Unexpected error while checking Print Spooler service: $($_.Exception.Message)"
}

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'

  softwareName   = 'NoMachine*'
  
  url            = 'https://download.nomachine.com/download/9.0/Windows/nomachine_9.0.188_11_x86.exe'
  checksum       = '5e182aa07d0d0a1d5d185df55c579f02'
  checksumType   = 'md5'
  
  url64          = 'https://download.nomachine.com/download/9.0/Windows/nomachine_9.0.188_11_x64.exe'
  checksum64     = 'd40060c36be083fd65823be238b8ca57'
  checksumType64 = 'md5'

  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

try {
	# installer does not manage read-only files in silent mode
	if (Test-Path -Path "C:\Program Files\NoMachine\lib\perl") {
		Get-ChildItem 'C:\Program Files\NoMachine\lib\perl' -ReadOnly -Recurse | ForEach-Object { $_.IsReadOnly = $false }
	}
	if (Test-Path -Path "C:\Program Files (x86)\NoMachine\lib\perl") {
		Get-ChildItem 'C:\Program Files (x86)\NoMachine\lib\perl' -ReadOnly -Recurse | ForEach-Object { $_.IsReadOnly = $false }
	}
	Install-ChocolateyPackage @packageArgs
} catch {
	Write-Warning 'Error installing package. If you update from 8.2.4.9 on a 64bit environment'
	Write-Warning 'you need to uninstall nomachine and reinstall it.'
	Exit 1
}
