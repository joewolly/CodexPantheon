[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LASTEXITCODE = 0
& (Join-Path $scriptDir 'pantheon.ps1') install
if (-not $?) { exit 1 }
exit $LASTEXITCODE
