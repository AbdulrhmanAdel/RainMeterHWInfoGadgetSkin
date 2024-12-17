function Initialize()
end

function Update()
	CoreVIDs = tonumber((SKIN:GetMeasure('MeasureCoreVIDs')):GetStringValue())
	VCore = tonumber((SKIN:GetMeasure('MeasureVCore')):GetStringValue())
    return string.format("%.3f", CoreVIDs - VCore)
end

function HideLabels()
	local allMeters = SKIN:GetMeter("MeterDiffVidsWithVCoreText");
    allMeters:Hide();
end

