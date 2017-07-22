$ErrorActionPreference = 'Stop';

$packageName= 'nomachine'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'http://download.nomachine.com/download/5.3/Windows/nomachine_5.3.9_4.exe'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url           = $url

  softwareName  = 'NoMachine*'
  checksum      = 'cbaa47e6f692e99ad706cb67715e3c367bee1bee5c1a574282dc6253fd2ebc7d'
  checksumType  = 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
