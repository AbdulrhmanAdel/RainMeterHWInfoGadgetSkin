$Options = $Options = & "$PSScriptRoot/Get-HwInfo.ps1";

$global:BaseStuff = @"
[Rainmeter]
Update=1000
AccurateText=1

[Metadata]
Name=Hardware_Info
Author=Abdulrahman Adel
Information=
Version=
License=Creative Commons Attribution - Non - Commercial - Share Alike 3.0

[Variables]
fontName=Arial
textSize=10
colorPrimary=30,144,255,255 ; Primary color for accents and highlights
colorSecondary=0,0,0,125 ; Background color for sections
colorText=255,255,255,255 ; Text color
;colorHighlight=255,69,0,255 ; Highlight color for important info: Red
colorHighlight=255,128,0,255 ; Highlight color for important info: Yellow
padding=10
borderRadius=8
barHeight=5

;; Styles
[CenterText]
StringAlign=Center

[LeftText]
StringAlign=Left

[RightText]
StringAlign=Right

[TextStyles]
StringCase=None
StringStyle=Bold
StringEffect=Shadow
FontEffectColor=0,0,0,20
FontColor=#colorText#
FontFace=#fontName#
FontSize=#textSize#
AntiAlias=1
ClipString=1
"@

$global:Y = 10;
$global:MarginY = 20;
$global:ElementHeight = 14;
$global:Padding = 10;
$global:Gap = 15;
$global:TotalHeight = $global:Y * 2 + ($Options.Keys.Count) * $MarginY + $ElementHeight;
$global:BaseStuff += @"
[MeterShape]
Meter=Shape
Shape=Rectangle 0,0,180,$global:TotalHeight,#borderRadius# | Fill Color #colorSecondary# | StrokeWidth 0

"@


function AddMeter {
    param (
        $Options
    )

    $global:BaseStuff += @"
[Meter$($Options.MeasureName)Text]
Meter=String
Text=$($Options.Label)
MeterStyle=TextStyles
X=$($global:Padding)
Y=$global:Y
Text=%1

[Meter$($Options.MeasureName)]
Meter=String
MeasureName=$($Options.MeasureName)
MeterStyle=TextStyles
X=100
Y=0r
H=$global:ElementHeight
Text=%1$($Options.Unit)
FontColor=#colorHighlight#

[$($Options.MeasureName)]
Measure=Registry
RegHKey=HKEY_CURRENT_USER
RegKey=SOFTWARE\HWiNFO64\VSB
RegValue=ValueRaw$($Options.Index)

"@

    $global:Y += $global:MarginY;
}


$Options.Keys | ForEach-Object {
    AddMeter -Options $Options[$_];
}

$global:BaseStuff += @"
[MeterDiffVidsWithVCoreText]
Meter=String
Text=Diff
MeterStyle=TextStyles
X=$($global:Padding)
Y=$global:Y
Text=%1

[MeterDiffVidsWithVCore]
Meter=String
MeasureName=MeasureDiffVidsWithVCore
MeterStyle=TextStyles
X=100
Y=0r
H=$global:ElementHeight
Text=%1V
FontColor=#colorHighlight#

[MeasureDiffVidsWithVCore]
Measure=Script
ScriptFile=#@#Diff.lua
"@
$SaveLocation = Resolve-Path -Path "$PSScriptRoot\..\..\Info"
Set-Content -LiteralPath "$SaveLocation\Info.ini" -Value $global:BaseStuff -Encoding utf8;
timeout.exe 5;