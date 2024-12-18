function Initialize()
end

function Update()
	CoreVIDs = tonumber((SKIN:GetMeasure('mCoreVIDs')):GetStringValue())
	VCore = tonumber((SKIN:GetMeasure('mVCore')):GetStringValue())
	Diff = string.format("%.3f", CoreVIDs - VCore)
    return Diff;
end

