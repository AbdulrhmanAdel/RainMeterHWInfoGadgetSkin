function Initialize()
end

Measures = {};
function Update()
    MeasureName = SELF:GetOption("MeasureSource");
    -- Measure = Measures[MeasureName];
    -- print(Measure)
    -- if (Measure == nil) then
    --     Measure = SKIN:GetMeasure(MeasureName);
    --     Measures[MeasureName] = Measure;
    -- end
    Measure = SKIN:GetMeasure(MeasureName);
    MeasureValue = tonumber(Measure:GetStringValue())
    DivideBy = SELF:GetOption("DivideBy")
    Decimal = SELF:GetOption("Decimal")
    return string.format("%.1f", MeasureValue / DivideBy);
end
