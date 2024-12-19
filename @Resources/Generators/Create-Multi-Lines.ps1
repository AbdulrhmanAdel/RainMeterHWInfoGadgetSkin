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
$Options = & "$PSScriptRoot/Get-HwInfo.ps1";
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
    "NumH=8"
    "BarW=5"
    "BarH=16"
    "NFontSize=10"
    "NFontWeight=800"
    ""
    "; ----------------STYLES----------------"
    "@Include=#@#Styles.inc"
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
    "DynamicVariables=1"
    # "StringAlign=Right"
    ""
    "[sLabel]"
    # "StringAlign=Right"
    "FontFace=Arial"
    "FontSize=#NFontSize#"
    "FontWeight=#NFontWeight#"
    ""
);

$Row = 0;
$RowMeter = $null;
$VerticalGap = 8;
$RowHeight = 10;
$Grouped = $Options | Group-Object -Property Group;
$Grouped | ForEach-Object {
    $Key = $_.Name;
    $Values = $_.Group;
    $GroupInfo = $Values[0];
    $Y = $Row -gt 0 ? $Y + $RowHeight + $VerticalGap : 0;
    $Skin += "; region ----------------$Key----------------"
    $Skin += @(
        "[$($Key)Bar]"
        "Meter=Shape"
        "X=0"
        "Y=$($Y)"
        "Shape=Line 0,0,0,#BarH# | StrokeWidth #BarW# | StrokeColor $($GroupInfo.BarColor)"
        ""
        "[$($Key)Label]"
        "Meter=String"
        "Text=$Key"
        "X=([$($Key)Bar:W] + 5)"
        "Y=$($Y)"
        "DynamicVariables=1"
        "FontColor=$($GroupInfo.BarColor)"
        "MeterStyle=sLabel"
    );

    
    $Skin += "; endregion ----------------$Key----------------"
    $Skin += ""
    $Row++;
}


# Measures
# $Skin += "; Measures"
# $Options | ForEach-Object {
#     $Value = $_;
#     $Skin += "[m$($Value.Name)]";
#     switch ($Value.Type) {
#         "Script" { 
#             $Skin += @(
#                 "Measure=Script"
#                 "ScriptFile=#@#$($Value.Script).lua"
#             )
#         }
#         Default {
#             $Skin += @(
#                 "Measure=Registry"
#                 "RegHKey=HKEY_CURRENT_USER"
#                 "RegKey=SOFTWARE\HWiNFO64\VSB"
#                 "RegValue=ValueRaw$($Value.Index)"
#             );
#         }
#     }
#     $Skin += "";  
# }

# $Skin += "; Meters"
# $Options | ForEach-Object {
#     $Value = $_;
#     $MeterName = $Value.Name;
#     $MeasureName = "m$MeterName";
#     $Format = $Value.Format;
#     if ($Format) {
#         $DivideBy = $Format.DivideBy ?? 1;
#         $Decimal = $Format.Decimal ?? 0;
#         $NewMeasureName = "$($MeasureName)Calc"
#         $Skin += @(
#             "[$NewMeasureName]"
#             "Measure=Script"
#             "ScriptFile=#@#Scripts\Format.lua"
#             "DivideBy=$DivideBy"
#             "Decimal=$Decimal"
#             "MeasureSource=""$MeasureName"""
#         );
#         $MeasureName = $NewMeasureName;
#     }

#     $Skin += @(
#         "[$MeterName]"
#         "Meter=String"
#         "MeasureName=$MeasureName"
#         "MeterStyle=sNumber"
#         "Text=%1$($Value.Unit)"
#         "FontColor=$($Value.ValueColor)"
#         "MouseOverAction=[!SetOption #CURRENTSECTION# Text ""$($Value.Label)""][!SetOption #CURRENTSECTION# FontColor $($Value.BarColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
#         "MouseLeaveAction=[!SetOption #CURRENTSECTION# Text ""%1$($Value.Unit)""][!SetOption #CURRENTSECTION# FontColor $($Value.ValueColor)][!UpdateMeter #CURRENTSECTION#][!Redraw]"
#     );

#     $Skin += @(
#         "[$($MeterName)Bar]"
#         "Meter=Shape"
#         "MeterStyle=sBar"
#         "Shape=Line 1,0,1,([$($MeterName):H]) | StrokeWidth #barW# | StrokeColor $($Value.BarColor)"
#         ""
#     );
# }

$SaveLocation = Resolve-Path -Path "$PSScriptRoot\..\..\"
Set-Content -LiteralPath "$SaveLocation\GameOverlay.ini" $Skin;



