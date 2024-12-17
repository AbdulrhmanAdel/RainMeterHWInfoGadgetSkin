$Options = [Ordered]@{
    "CPU Package"          = @{
        Name        = "CpuTemp"
        Label       = "Temp"
        Unit        = "[\xB0]C"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
    }
    "Total CPU Usage"      = @{
        Name        = "TotalCpuUsage"
        Label       = "Usage"
        Unit        = "%"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
    }
    "CPU Package Power"    = @{
        Name        = "TotalCpuPower"
        Label       = "Power"
        Unit        = "W"
        ValueLength = 7
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
        Format      = @{
            Decimal = 2
        }
    }
    "Core VIDs"            = @{
        Name        = "CoreVIDs"
        Label       = "VIDs"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
    }
    "Vcore"                = @{
        Name        = "VCore"
        Label       = "VCore"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
    }
    
    "Core Clocks"          = @{
        Name        = "CoreClocks"
        Label       = "Clock"
        Unit        = "MHz"
        ValueLength = 9
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "34EBCC"
        Group       = "CPU"
    }
    
    "Physical Memory Used" = @{
        Name        = "TotalRAMUsage"
        Label       = "Usage"
        Unit        = "GB"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "B514AA"
        Group       = "RAM"
        Format      = @{
            DivideBy = 1000
            Decimal  = 2
        }
    }
    "Total Errors"         = @{
        Name        = "WHEATotalErrors"
        Label       = "WHEA"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = "DB0909"
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


return $Options.Values;