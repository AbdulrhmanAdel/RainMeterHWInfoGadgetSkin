function RandomColor {
    return ($(for ($i = 0; $i -lt 6; $i++) { Get-Random -InputObject ([char[]]"0123456789ABCDEF") }) -join '')
}

$HardwareGroup = @{
    CPU  = 'CPU'
    GPU  = 'GPU'
    RAM  = 'RAM'
    WHEA = 'WHEA'
    FANS = 'FANS'
}

$Colors = @{
    $HardwareGroup.CPU  = RandomColor;
    $HardwareGroup.RAM  = RandomColor;
    $HardwareGroup.WHEA = RandomColor;
}

$Options = [Ordered]@{
    "CPU Package"                = @{
        Name        = "CpuTemp"
        MeasureName = "mCpuTemp"
        Label       = "Temp"
        Unit        = "[\xB0]C"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "Total CPU Usage"            = @{
        Name        = "TotalCpuUsage"
        MeasureName = "mTotalCpuUsage"
        Label       = "Usage"
        Unit        = "%"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "CPU Package Power"          = @{
        Name        = "TotalCpuPower"
        MeasureName = "mTotalCpuPower"
        Label       = "Power"
        Unit        = "W"
        ValueLength = 7
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
        Format      = @{
            Decimal = 1
        }
    }    
    "Core Clocks"                = @{
        Name        = "CoreClocks"
        MeasureName = "mCoreClocks"
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

    "Core VIDs"                  = @{
        Name        = "CoreVIDs"
        MeasureName = "mCoreVIDs"
        Label       = "VIDs"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "Vcore"                      = @{
        Name        = "VCore"
        MeasureName = "mVCore"
        Label       = "VCore"
        Unit        = "V"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
    }
    "VIDsVCoreDiff"              = @{
        Name         = "VIDsVCoreDiff"
        MeasureName  = "mVIDsVCoreDiff"
        Label        = "VIDsVCoreDiff"
        Type         = "Script"
        Script       = "Scripts\VIDsVCoreDiff"
        ScriptParams = @{
            "VIDsMeasure"  = "mCoreVIDs"
            "VCoreMeasure" = "mVCore"
        }
        Unit         = "V"
        LabelColor   = "FFFFFF"
        ValueColor   = "FF8000"
        BarColor     = $Colors[$HardwareGroup.CPU]
        Group        = $HardwareGroup.CPU
    }

    "VR VCC Current (SVID IOUT)" = @{
        Name        = "CpuCurrent"
        MeasureName = "mCpuCurrent"
        Label       = "Current"
        Unit        = "A"
        ValueLength = 6
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.CPU]
        Group       = $HardwareGroup.CPU
        Format      = @{
            Decimal = 2
        }
    }
    
    "Physical Memory Used"       = @{
        Name        = "TotalRAMUsage"
        MeasureName = "mTotalRAMUsage"
        Label       = "Usage"
        Unit        = "GB"
        ValueLength = 3
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.RAM]
        Group       = $HardwareGroup.RAM
        Format      = @{
            DivideBy = 1000
            Decimal  = 1
        }
    }
    "Total Errors"               = @{
        Name        = "WHEATotalErrors"
        MeasureName = "mWHEATotalErrors"
        Label       = "WHEA"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.WHEA]
        Group       = $HardwareGroup.WHEA
    }

    #region Fans
    
    "CPU"                        = @{
        Name        = "CPUFanSpeed"
        MeasureName = "mCPUFanSpeed"
        Label       = "CPU Fan Speed"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.FANS]
        Group       = $HardwareGroup.FANS
    }
    "PUMP1"                      = @{
        Name        = "PumpSpeed"
        MeasureName = "mPumpSpeed"
        Label       = "Pump Speed"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.FANS]
        Group       = $HardwareGroup.FANS
    }
    "System 1"                      = @{
        Name        = "Back Fan Speed"
        MeasureName = "mBackFanSpeed"
        Label       = "Back Fan Speed"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.FANS]
        Group       = $HardwareGroup.FANS
    }
    "System 2"                      = @{
        Name        = "Front Fan Speed"
        MeasureName = "mFrontFanSpeed"
        Label       = "Front Fan Speed"
        Unit        = ""
        ValueLength = 2
        LabelColor  = "FFFFFF"
        ValueColor  = "FF8000"
        BarColor    = $Colors[$HardwareGroup.FANS]
        Group       = $HardwareGroup.FANS
    }
    #endregion
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