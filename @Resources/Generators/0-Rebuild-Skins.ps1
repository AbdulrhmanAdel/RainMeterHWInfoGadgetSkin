Get-ChildItem -LiteralPath $PSScriptRoot -File | Where-Object {
    $_.Name -ne "0-Rebuild-Skins.ps1"
} | ForEach-Object {
    & $_.FullName;
};
