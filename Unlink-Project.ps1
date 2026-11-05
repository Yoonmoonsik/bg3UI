# Removes the WhiskeyUI links from the game's Data folder.
# Only the links are removed: repo files stay, and real folders are left alone.
param(
    [string]$DataPath = 'D:\SteamLibrary\steamapps\common\Baldurs Gate 3\Data',
    [string]$ProjectName = 'WhiskeyUI_28a5d33e-9375-a260-8ff0-a3258d6e5120'
)
$ErrorActionPreference = 'Stop'
$folders = 'Mods', 'Projects', 'Public', 'Editor\Mods'

foreach ($folder in $folders) {
    $link = Join-Path (Join-Path $DataPath $folder) $ProjectName
    if (-not (Test-Path -LiteralPath $link)) {
        "not linked: $folder"
        continue
    }
    $item = Get-Item -LiteralPath $link -Force
    if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        Write-Warning "real folder, not removed: $link"
        continue
    }
    # Non-recursive delete removes the link itself, never the files behind it.
    [IO.Directory]::Delete($link)
    "unlinked: $folder"
}
