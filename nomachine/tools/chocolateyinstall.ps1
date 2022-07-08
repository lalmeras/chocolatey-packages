$ErrorActionPreference = 'Stop';

$packageName= 'nomachine'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.nomachine.com/download/7.10/Windows/nomachine_7.10.2_8.exe'

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
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url

  softwareName  = 'NoMachine*'
  checksum      = '36d999ad3af019343a384b2cee8b762f'
  checksumType  = 'md5'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
