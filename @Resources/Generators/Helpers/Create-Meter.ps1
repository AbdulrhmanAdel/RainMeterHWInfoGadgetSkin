[CmdletBinding()]
param (
    [Parameter(Mandatory = 1)]
    $Properties,
    [Parameter]
    $MeasureName
)

$local:Meter = @();
$local:Meter += @(
    "[$MeterName]"
    "Meter=String"
    "MeasureName=$MeasureName"
);

$local:Meter += @(
    "[$($MeterName)Bar]"
    "Meter=Shape"
    "MeterStyle=sBar"
    "Shape=Line 1,0,1,([$($MeterName):H]) | StrokeWidth #barW# | StrokeColor $(Properties.BarColor)"
    ""
);

return $local:Meter
