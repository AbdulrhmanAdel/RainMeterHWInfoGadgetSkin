[CmdletBinding()]
param (
    [Parameter(Mandatory = 1)]
    $Properties
)

$Format = $Properties.Format;
$local:MeasureName = !$Format ?  $Properties.MeasureName : "Measure$($Properties.Name)Source"; 
$local:Measure = @("[$local:MeasureName]");
switch ($Properties.Type) {
    "Script" {
        $local:Measure += @(
            "Measure=Script"
            "ScriptFile=#@#$($Properties.Script).lua"
        )

        if ($Properties.ScriptParams) {
            $Properties.ScriptParams.Keys | ForEach-Object {
                $Key = $_;
                $Value = $Properties.ScriptParams[$Key];
                $local:Measure += "$Key=$Value";
            }
        }
    }
    Default {
        $local:Measure += @(
            "Measure=Registry"
            "RegHKey=HKEY_CURRENT_USER"
            "RegKey=SOFTWARE\HWiNFO64\VSB"
            "RegValue=ValueRaw$($Properties.Index)"
        );
    }
}

if ($Format) {
    $DivideBy = $Format.DivideBy ?? 1;
    $Decimal = $Format.Decimal ?? 0;
    $NewMeasureName = $Properties.MeasureName;
    $local:Measure += @(
        "[$NewMeasureName]"
        "Measure=Script"
        "ScriptFile=#@#Scripts\Format.lua"
        "DivideBy=$DivideBy"
        "Decimal=$Decimal"
        "MeasureSource=""$local:MeasureName"""
    );
    $local:MeasureName = $NewMeasureName;
}

$local:Measure += "";
return @{
    Key         = $Properties.Name
    Skin        = $local:Measure
    MeasureName = $Properties.MeasureName
    Properties  = $Properties
};