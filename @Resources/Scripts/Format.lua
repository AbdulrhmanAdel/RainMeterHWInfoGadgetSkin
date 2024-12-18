function Initialize()
    MeasureName = SELF:GetOption("MeasureSource");
    Measure = SKIN:GetMeasure(MeasureName);
    DivideBy = SELF:GetOption("DivideBy");
    Decimal = SELF:GetOption("Decimal");
    Format = "%." .. (tostring(Decimal)) .. "f";
end

function Update()
    MeasureValue = tonumber(Measure:GetStringValue())
    Value = MeasureValue / DivideBy;
    return string.format(Format, Value);
end
