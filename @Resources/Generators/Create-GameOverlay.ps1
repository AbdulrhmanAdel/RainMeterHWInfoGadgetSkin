#region Functions


#endregion
$Options = & "$PSScriptRoot/Get-HwInfo.ps1";
$Text = @(
    "[Rainmeter]"
    "Update=500"
    ""
    "[Metadata]"
    "Name=HardwareInfo"
    "Author=Abdulrahman Adel"
    ""
    "[Variables]"
    "Width=120"
    "NumH=8"
    "BarW=3"
    ""
    "; ----------------STYLES----------------"
    "@Include=#@#Styles.inc"
    ""
    "[sNumber]"
    "X=#Width#"
    "Y=#NumH#R"
    "Padding=0,0,2,0"
    "FontFace=Arial"
    "FontSize=8"
    "StringEffect=Border"
    "AntiAlias=1"
    "FontColor=#NumStatColor#"
    "StringAlign=Right"
    "FontEffectColor=000000C0"
    "SolidColor=00000001"
    ""
    "[sBar]"
    "X=#Width#"
    "Y=r"
    "DynamicVariables=1"
    "StringAlign=Right"
    ""
);


# Measures
$Text += "; Measures"
$Options.Keys | ForEach-Object {
    $Value = $Options[$_];
    $Text += @(
        "[m$($Value.Name)]"
        "Measure=Registry"
        "RegHKey=HKEY_CURRENT_USER"
        "RegKey=SOFTWARE\HWiNFO64\VSB"
        "RegValue=ValueRaw$($Value.Index)"
        ""
    );
}

$Text += "; Meters"
$Options.Keys | ForEach-Object {
    $Value = $Options[$_];
    $MeterName = $Value.Name;
    $Text += @(
        "[$MeterName]"
        "Meter=String"
        "MeasureName=m$MeterName"
        "MeterStyle=sNumber"
        "Text=%1$($Value.Unit)"
        "FontColor=$($Value.ValueColor)"
        "MouseOverAction=[!SetOption #CURRENTSECTION# Text ""$($_)""][!SetOption #CURRENTSECTION# FontColor $($Value.LabelColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
        "MouseLeaveAction=[!SetOption #CURRENTSECTION# Text ""%1$($Value.Unit)""][!SetOption #CURRENTSECTION# FontColor $($Value.ValueColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
        ""
        "[$($MeterName)Bar]"
        "Meter=Shape"
        "MeterStyle=sBar"
        "Shape=Line 1,0,1,([$($MeterName):H]) | StrokeWidth #barW# | StrokeColor $($Value.BarColor)"
        ""
    );
}

$SaveLocation = Resolve-Path -Path "$PSScriptRoot\..\..\GameOverlay"
Set-Content -LiteralPath "$SaveLocation\GameOverlay.ini" $Text;




