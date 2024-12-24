function Initialize()
    CoreVIDsMeasureName = SELF:GetOption('VIDsMeasure')
    VCoreMeasureName = SELF:GetOption('VCoreMeasure')
end

function Update()
    CoreVIDs = tonumber((SKIN:GetMeasure(CoreVIDsMeasureName)):GetStringValue())
    VCore = tonumber((SKIN:GetMeasure(VCoreMeasureName)):GetStringValue())
    Diff = string.format("%.3f", CoreVIDs - VCore)
    return Diff;
end

