#
# Author: Yi ( https://fengyi.tel )
#
# From: Yi Solution Suite For MSWin Bundled Kit
# buildstring: 2.0.0.2.bk_release.201025-1208
#
# Description:
#
# Uninstall the latest version of EDGE browser based on CHROME kernel
#

Import-Module -DisableNameChecking $PSScriptRoot\..\lib\force-mkdir.psm1
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\take-own.psm1

Write-Output "Elevating privileges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

Write-Output "Uninstalling Edge apps"
$apps = @(
    "*edge*"
    "Microsoft.MicrosoftEdgeDevToolsClient"
    "Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"
)

foreach ($app in $apps) {
    Write-Output "Trying to remove $app"

    Get-AppxPackage -Name $app | Remove-AppxPackage
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers

    Get-AppXProvisionedPackage -Online |
        Where-Object DisplayName -EQ $app |
        Remove-AppxProvisionedPackage -Online
}

foreach ($item in (Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft\Edge\Application" -directory -ErrorAction SilentlyContinue )) {
    $filename = $item.FullName+"\Installer\setup.exe"
    $param = "--uninstall --force-uninstall --system-level"

    if ((Test-Path $filename -PathType Leaf)) {
        echo "`n   EDGE has been installed, execute the delete command:"
        Start-Process -FilePath $filename -ArgumentList $param -Wait
        echo "`   Finish deleting..."
    } else {
        Write-Host "   Not found: $filename"
    }
}

Write-Output "Removing additional Edge leftovers"
#foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*ie-htmlrendering*")) {
#    Takeown-Folder $item.FullName
#    Remove-Item -Recurse -Force $item.FullName
#}
#foreach ($item in (Get-ChildItem "$env:WinDir\SystemApps\*edge*")) {
#    Takeown-Folder $item.FullName
#    Remove-Item -Recurse -Force $item.FullName
#}
#foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*edge*")) {
#    Takeown-Folder $item.FullName
#    Remove-Item -Recurse -Force $item.FullName
#}
#foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\Manifests\*edge*")) {
#    Takeown-Folder $item.FullName
#    Remove-Item -Recurse -Force $item.FullName
#}
#foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\*e..-firsttimeinstaller*")) {
#    Takeown-Folder $item.FullName
#    Remove-Item -Recurse -Force $item.FullName
#}
foreach ($item in (Get-ChildItem "$env:WinDir\WinSxS\FileMaps\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}
foreach ($item in (Get-ChildItem "$env:WinDir\System32\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}
foreach ($item in (Get-ChildItem "$env:WinDir\temp\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}
foreach ($item in (Get-ChildItem "$env:localappdata\temp\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}
foreach ($item in (Get-ChildItem "$env:programdata\Microsoft\Windows\AppRepository\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}
foreach ($item in (Get-ChildItem "$env:WinDir\Prefetch\*edge*")) {
    Takeown-Folder $item.FullName
    Remove-Item -Recurse -Force $item.FullName
}

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\Edge" | Out-Null
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:localappdata\Microsoft\Windows\Safety" | Out-Null
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "$env:programdata\Microsoft\EdgeUpdate" | Out-Null

exit