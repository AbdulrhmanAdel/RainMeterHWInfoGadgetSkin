function RandomColor {
    return ($(for ($i = 0; $i -lt 6; $i++) { Get-Random -InputObject ([char[]]"0123456789ABCDEF") }) -join '')
}

$HardwareGroup = @{
    CPU  = 'CPU'
    RAM  = 'RAM'
    WHEA = 'WHEA'
}

$Colors = @{
    $HardwareGroup.CPU  = RandomColor;
    $HardwareGroup.RAM  = RandomColor;
    $HardwareGroup.WHEA = RandomColor;
}

# "34EBCC", 
$Options = [Ordered]@{
    "CPU Package"          = @{
        Name        = "CpuTemp"
        Label       = "Temp"
        Unit        = "[\xB0]C"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "Total CPU Usage"      = @{
        Name        = "TotalCpuUsage"
        Label       = "Usage"
        Unit        = "%"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "CPU Package Power"    = @{
        Name        = "TotalCpuPower"
        Label       = "Power"
        Unit        = "W"
        ValueLength = 7
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
        Format      = @{
            Decimal = 2
        }
    }    
    "Core Clocks"          = @{
        Name        = "CoreClocks"
        Label       = "Clock"
        Unit        = "GHz"
        ValueLength = 9
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
        Format      = @{
            DivideBy = 1000
            Decimal  = 2
        }
    }

    "Core VIDs"            = @{
        Name        = "CoreVIDs"
        Label       = "VIDs"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "Vcore"                = @{
        Name        = "VCore"
        Label       = "VCore"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }

    "DIFF"                 = @{
        Type       = "Script"
        Script     = "Scripts\VIDsVCoreDiff"
        Name       = "VIDsVCoreDiff"
        Label      = "VIDsVCoreDiff"
        Unit       = "V"
        LabelColor = "FFFFFF"
        ValueColor = "FF8000"
        BarColor   = $Colors[$HardwareGroup.CPU]
        Group      = $HardwareGroup.CPU
    }

    
    "Physical Memory Used" = @{
        Name        = "TotalRAMUsage"
        Label       = "Usage"
        Unit        = "GB"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.RAM]
        Group       = $HardwareGroup.RAM
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
        BarColor    = $Colors[$HardwareGroup.WHEA]
        Group       = $HardwareGroup.WHEA
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