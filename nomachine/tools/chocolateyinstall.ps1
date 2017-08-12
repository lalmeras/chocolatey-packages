$ErrorActionPreference = 'Stop';

$packageName= 'nomachine'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://download.nomachine.com/download/5.3/Windows/nomachine_5.3.10_3.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url

  softwareName  = 'NoMachine*'
  checksum      = 'ba445a8b7a29fb66f4fdde992bf5642fc1fb77173f4c3fa6b1dce6e943eb48c7'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
