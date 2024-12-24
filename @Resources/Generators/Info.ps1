#region Functions
function ApplyFormatOptions {
    param (
        $FormatOptions
    )

    $Value = "%1";
    if ($FormatOptions.DivideBy) {
        $Value = "(%1 / $($FormatOptions.DivideBy))"
    }
    return $Value;
}

#endregion
$Options = & "$PSScriptRoot/Helpers/Get-HwInfo.ps1";
$Skin = @(
    "[Rainmeter]"
    "Update=1000"
    ""
    "[Metadata]"
    "Name=HardwareInfo"
    "Author=Abdulrahman Adel"
    ""
    "[Variables]"
    "Width=120"
    "NumH=4"
    "BarW=1"
    "NFontSize=10"
    "NFontWeight=600"
    ""
    "; ----------------STYLES----------------"
    "@IncludeStyles=#@#Styles.inc"
    ""
    "[sNumber]"
    "X=#Width#"
    "Y=#NumH#R"
    "Padding=0, 0, 2, 0"
    "FontFace=Arial"
    "FontSize=#NFontSize#"
    "FontWeight=#NFontWeight#"
    "StringEffect=Border"
    "AntiAlias=1"
    "StringAlign=Right"
    "FontEffectColor=000000C0"
    ""
    "[sBar]"
    "X=#Width#"
    "Y=r"
    "DynamicVariables=1"
    "StringAlign=Right"
    ""
);

# Measures
$Skin += "; Measures"
$Options | ForEach-Object {
    $Measure = & "$PSScriptRoot/Helpers/Create-Measure.ps1" -Properties $_;
    $Skin += "";
    $Skin += $Measure.Skin;
    $Skin += "";
}

$Skin += "; Meters"
$Options | ForEach-Object {
    $Value = $_;
    $MeterName = $Value.Name;
    $MeasureName = $_.MeasureName;
    $Skin += @(
        "[$MeterName]"
        "Meter=String"
        "MeasureName=$MeasureName"
        "MeterStyle=sNumber"
        "Text=%1$($Value.Unit)"
        "FontColor=$($Value.ValueColor)"
        "MouseOverAction=[!SetOption #CURRENTSECTION# Text ""$($Value.Label)""][!SetOption #CURRENTSECTION# FontColor $($Value.BarColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
        "MouseLeaveAction=[!SetOption #CURRENTSECTION# Text ""%1$($Value.Unit)""][!SetOption #CURRENTSECTION# FontColor $($Value.ValueColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
    );

    $Skin += @(
        "[$($MeterName)Bar]"
        "Meter=Shape"
        "MeterStyle=sBar"
        "Shape=Line 1,0,1,([$($MeterName):H]) | StrokeWidth #barW# | StrokeColor $($Value.BarColor)"
        ""
    );
}

$SaveLocation = Resolve-Path -Path "$PSScriptRoot\..\..\Info"
Set-Content -LiteralPath "$SaveLocation\Info.ini" $Skin;




