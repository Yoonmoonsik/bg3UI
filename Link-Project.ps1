# Links the WhiskeyUI project in this repo into the game's Data folder.
# Uses a symbolic link when allowed, otherwise a directory junction.
# If only Data holds the project (new toolkit project), it is moved into the repo first.
param(
    [string]$DataPath = 'D:\SteamLibrary\steamapps\common\Baldurs Gate 3\Data',
    [string]$ProjectName = 'WhiskeyUI_28a5d33e-9375-a260-8ff0-a3258d6e5120'
)
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot
$folders = 'Mods', 'Projects', 'Public', 'Editor\Mods'

function Test-IsLink([string]$Path) {
    $item = Get-Item -LiteralPath $Path -Force
    return [bool]($item.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

if (-not (Test-Path -LiteralPath $DataPath)) { throw "Data folder not found: $DataPath" }

# Check everything first so a conflict changes nothing.
foreach ($folder in $folders) {
    $link = Join-Path (Join-Path $DataPath $folder) $ProjectName
    $target = Join-Path (Join-Path $repo $folder) $ProjectName
    if ((Test-Path -LiteralPath $link) -and -not (Test-IsLink $link) -and (Test-Path -LiteralPath $target)) {
        throw "Both a real folder and a repo folder exist. Resolve this first:`n  $link`n  $target"
    }
}

foreach ($folder in $folders) {
    $link = Join-Path (Join-Path $DataPath $folder) $ProjectName
    $targetParent = Join-Path $repo $folder
    $target = Join-Path $targetParent $ProjectName

    if ((Test-Path -LiteralPath $link) -and (Test-IsLink $link)) {
        "already linked: $folder"
        continue
    }
    if (Test-Path -LiteralPath $link) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
        Move-Item -LiteralPath $link -Destination $target
        "moved into repo: $folder"
    }
    elseif (-not (Test-Path -LiteralPath $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    }

    New-Item -ItemType Directory -Path (Split-Path $link) -Force | Out-Null
    try {
        New-Item -ItemType SymbolicLink -Path $link -Target $target -ErrorAction Stop | Out-Null
        "symbolic link: $folder"
    }
    catch {
        New-Item -ItemType Junction -Path $link -Target $target | Out-Null
        "junction: $folder"
    }
}
