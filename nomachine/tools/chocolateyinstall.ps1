$ErrorActionPreference = 'Stop';

$packageName= 'nomachine'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://download.nomachine.com/download/5.3/Windows/nomachine_5.3.12_5.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url

  softwareName  = 'NoMachine*'
  checksum      = '882e7ef87ddf333e4de5b03a6f9880a38292d2797eacb1c79f85dba1cdce1521'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
