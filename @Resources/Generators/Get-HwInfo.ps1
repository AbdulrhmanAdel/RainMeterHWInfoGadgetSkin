$Options = [Ordered]@{
    "CPU Package"       = @{
        Name        = "CpuTemp"
        Label       = "Temp"
        Unit        = "[\xB0]C"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FF0000"
        Group       = "CPU"
    }
    "Total CPU Usage"   = @{
        Name        = "TotalCpuUsage"
        Label       = "Usage"
        Unit        = "%"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "CPU"
    }
    "CPU Package Power" = @{
        Name        = "TotalCpuPower"
        Label       = "Power"
        Unit        = "W"
        ValueLength = 7
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "CPU"
    }
    "Core VIDs"         = @{
        Name        = "CoreVIDs"
        Label       = "VIDs"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "CPU"
    }
    "Vcore"             = @{
        Name        = "VCore"
        Label       = "VCore"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "CPU"
    }
    
    "Core Clocks"       = @{
        Name        = "CoreClocks"
        Label       = "Clock"
        Unit        = "MHz"
        ValueLength = 9
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "CPU"
    }
    "Total Errors"      = @{
        Name        = "WHEATotalErrors"
        Label       = "WHEA"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "FFFFFF"
        Group       = "WHEA"
    }
};


$Info = Get-ItemProperty -Path HKCU:\Software\HWiNFO64\VSB
$SensorIndex = 0;
while ($SensorIndex -ne -1) {
    $LabelKey = "Label$SensorIndex";
    $Label = $Info."$LabelKey";
    if (!$Label) {
        $SensorIndex = -1;
    }
    else {
        $Options[$Label].Index = $SensorIndex;
        $SensorIndex++;
    }
}


return $Options;