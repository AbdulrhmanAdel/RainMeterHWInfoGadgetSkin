$Options = & "$PSScriptRoot/Helpers/Get-HwInfo.ps1";
$Skin = @(
    "[Rainmeter]"
    "Update=1000"
    ""
    "[Metadata]"
    "Name=HardwareInfo"
    "Author=Abdulrahman Adel"
    ""
)


$Measures = @(
    "CpuTemp"
    "CoreVIDs"
    "VCore"
    "VIDsVCoreDiff"
) | ForEach-Object {
    $MeasureName = $_;
    $Props = $Options | Where-Object {
        $_.Name -eq $MeasureName
    } | Select-Object -First 1;
    return & "$PSScriptRoot/Helpers/Create-Measure.ps1" -Properties $Props;
}

$Index = 0;
$Measures | ForEach-Object {
    $Y = $Index -eq 0 ? 0 : 20;
    $Skin += "";
    $Skin += $_.Skin;
    $Skin += "";
    $Skin += @(
        "[Meter$($_.Properties.Name)]"
        "Meter=String"
        "MeasureName=$($_.MeasureName)"
        "Text=%1$($_.Properties.Unit)"
        "FontColor=$($_.Properties.ValueColor)"
        "solidColor = 0,0,0,150"
        "Padding=2,2,2,2"
        "X=120"
        "Y=$($Y)r"
        "StringAlign=Right"
    );
    $Index++;
}

$SaveLocation = Resolve-Path -Path "$PSScriptRoot\..\..\VCore"
Set-Content -LiteralPath "$SaveLocation\VCore.ini" $Skin;



