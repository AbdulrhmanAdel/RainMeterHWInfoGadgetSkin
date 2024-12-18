function Initialize()
  measures = {
    CPUT = SKIN:GetMeasure('mCPUT'),
    GPUT = SKIN:GetMeasure('mGPUT'),
    Batt = SKIN:GetMeasure('mBatt'),
    BattStatus = SKIN:GetMeasure('mBattStatus')
  }
  data = { CPUT = {}, GPUT = {} }
  bars = { CPUT = {}, GPUT = {} }
  head = 1
  minValues = {
    CPUT = tonumber(SKIN:GetVariable('MinValueCPUT')),
    GPUT = tonumber(SKIN:GetVariable('MinValueGPUT'))
  }
  ranges = {
    CPUT = SKIN:GetVariable('MaxValueCPUT') - minValues.CPUT,
    GPUT = SKIN:GetVariable('MaxValueGPUT') - minValues.GPUT
  }
  graphW = tonumber(SKIN:GetVariable('GraphW'))
  graphH = tonumber(SKIN:GetVariable('GraphH'))
  colors = {
    low = GetColorComponents(SKIN:GetVariable('GraphTempLowColor')),
    high = GetColorComponents(SKIN:GetVariable('GraphTempHighColor'))
  }
  showBars = false
  opens = { CPUT = false, GPUT = false }
  isSet = false
  isInput = false
  setName = ''
  local varName = {'Time','RAM','CPU','CPUT','GPU','GPUT','NetUp','NetDn'}
  local varLabel = {'time','RAM %','CPU %','CPU \176C','GPU %','GPU \176C','network up','network down'}
  if not SKIN:GetMeter('CPUT1') then
    GenMeters()
    SKIN:Bang('!Refresh')
    return
  end
  os.remove(SKIN:GetVariable('@')..'Meters.inc')
  for i = 1, graphW do
    data.CPUT[i], data.GPUT[i] = 0, 0
    SKIN:Bang('[!SetOption CPUT'..i..' W 1][!SetOption CPUT'..i..' Container GraphCPUTCont][!SetOption GPUT'..i..' W 1][!SetOption GPUT'..i..' Container GraphGPUTCont]')
    bars.CPUT[i] = SKIN:GetMeter('CPUT'..i)
    bars.GPUT[i] = SKIN:GetMeter('GPUT'..i)
  end
  for i = 1, 8 do
    ToggleMeter(varName[i], varLabel[i], (i + 2), true)
  end
  if SKIN:GetVariable('ShowBars') == '1' then
    ToggleBars()
  end
end

function Update()
  head = head % graphW + 1
  for name, isOpen in pairs(opens) do
    data[name][head] = math.max(measures[name]:GetValue() - minValues[name], 0) / ranges[name]
    if isOpen then
      local h = math.floor(data[name][head] * graphH)
      bars[name][head]:SetY(graphH - h)
      bars[name][head]:SetH(h)
      for i = 1, graphW do
        bars[name][i]:SetX((i - head - 1) % graphW)
      end
      SKIN:Bang('!SetOption', name..head, 'SolidColor', BlendColors(colors.low, colors.high, data[name][head]))
    end
  end
end

function GenMeters()
  local file = io.open(SKIN:GetVariable('@')..'Meters.inc', 'w')
  for i = 1, graphW do
    file:write('[CPUT'..i..']\nMeter=Image\n[GPUT'..i..']\nMeter=Image\n')
  end
  file:close()
end

function GetColorComponents(color)
  -- Convert color to RGBA
  if not color:find(',') then
    color = color:gsub('%x%x', function(s) return tonumber(s, 16)..',' end)
  end
  local R, G, B, A = color:match('(%d+)[,%s]+(%d+)[,%s]+(%d+)[,%s]*(%d*)')
  return { tonumber(R), tonumber(G), tonumber(B), tonumber(A) or 255 }
end

function BlendColors(colorLow, colorHigh, pct)
  local cLR, cLG, cLB, cLA = unpack(colorLow)
  local cHR, cHG, cHB, cHA = unpack(colorHigh)
  local R = math.floor((cHR - cLR) * pct + 0.5) + cLR
  local G = math.floor((cHG - cLG) * pct + 0.5) + cLG
  local B = math.floor((cHB - cLB) * pct + 0.5) + cLB
  local A = math.floor((cHA - cLA) * pct + 0.5) + cLA
  return R..','..G..','..B..','..A
end

function ToggleGraph(name, hide)
  if isSet then return end
  if name:sub(4, 4) == 'T' then
    opens[name] = not hide and not opens[name]
    if opens[name] then
      for i = 1, graphW do
        local h = math.floor(data[name][i] * graphH)
        bars[name][i]:SetX((i - head - 1) % graphW)
        bars[name][i]:SetY(graphH - h)
        bars[name][i]:SetH(h)
        SKIN:Bang('!SetOption', name..i, 'SolidColor', BlendColors(colors.low, colors.high, data[name][i]))
      end
    end
  end
  SKIN:Bang('[!'..(hide and 'Hide' or 'Show')..'MeterGroup Graph'..name..'][!UpdateMeterGroup Graph'..name..'][!'..(hide and 'Enable' or 'Clear')..'MouseAction Num'..name..' LeftMouseUpAction][!SetOption Num'..name..' H '..(hide and '""' or '#GraphH#')..'][!UpdateMeter Num'..name..'][!HideMeter Cog][!Redraw][!SetVariable Open'..name..' '..(hide and 0 or 1)..'][!WriteKeyValue Variables Open'..name..' '..(hide and 0 or 1)..' "#@#Settings.inc"]')
end

function ShowCog(name)
  if isSet then return end
  SKIN:Bang('[!MoveMeter 0 '..(SKIN:GetMeter('Graph'..name):GetY())..' Cog][!ShowMeter Cog][!Redraw]')
  setName = name
end

function ShowSet()
  isSet = true
  SKIN:Bang('[!MoveMeter (#GraphW#/2) '..(SKIN:GetMeter('Graph'..setName):GetY())..' SpeedFanNumberLabel][!SetOption SpeedFanNumberSet Text #*SpeedFanNumber'..setName..'*#][!SetOption MinValueSet Text "#*MinValue'..setName..'*# [\\xB0]C"][!SetOption MaxValueSet Text "#*MaxValue'..setName..'*# [\\xB0]C"][!UpdateMeterGroup Set][!ShowMeterGroup Set][!Redraw]')
end

function HideSet()
  if not isSet or isInput then return end
  isSet = false
  SKIN:Bang('[!HideMeterGroup Set][!Redraw]')
end

function Set1(var)
  setVar, isInput = var, true
  SKIN:Bang('[!SetVariable Var '..var..setName..'][!SetVariable VarValue """#'..var..setName..'#"""][!SetVariable Y '..SKIN:GetMeter(var..'Set'):GetY()..'][!Update][!CommandMeasure mInput "ExecuteBatch 1"]')
end

function Set2()
  isInput = false
  local val = tonumber(SKIN:GetVariable(SKIN:GetVariable('Var')))
  SKIN:Bang('[!SetOption m'..setName..' '..setVar..' "'..val..'"][!UpdateMeasure m'..setName..'][!SetOption '..setVar..'Set Text "'..val..(setVar == 'SpeedFanNumber' and '' or ' [\\xB0]C')..'"][!UpdateMeter '..setVar..'Set][!Redraw][!SetVariable '..setVar..setName..' "'..val..'"][!WriteKeyValue Variables '..setVar..setName..' "'..val..'" "#@#Settings.inc"]')
  if setVar == 'MinValue' then
    minValues[setName] = val
    ranges[setName] = SKIN:GetVariable('MaxValue'..setName) - val
  elseif setVar == 'MaxValue' then
    ranges[setName] = val - minValues[setName]
  end
end

function ToggleBars()
  showBars = not showBars
  SKIN:Bang('[!ToggleMeterGroup Bar][!UpdateMeterGroup Bar][!SetOptionGroup Num Padding 0,0,'..(showBars and '(#BarW#+2)' or 2)..',0][!UpdateMeterGroup Num][!Redraw][!SetOption Rainmeter ContextTitle "'..(showBars and 'Hide' or 'Show')..' bars"][!WriteKeyValue Variables ShowBars '..(showBars and 1 or 0)..' "#@#Settings.inc"]')
end

function ToggleMeter(name, label, n, init)
  local isShown = SKIN:GetVariable('Show'..name) == (init and '1' or '0')
  SKIN:Bang('[!'..(isShown and 'Show' or 'Hide')..'Meter Num'..name..'][!SetOption Rainmeter ContextTitle'..n..' "'..(isShown and 'Hide' or 'Show')..' '..label..'"][!SetVariable Show'..name..' '..(isShown and 1 or 0)..'][!WriteKeyValue Variables Show'..name..' '..(isShown and 1 or 0)..' "#@#Settings.inc"]')
  if name == 'Time' then
    SKIN:Bang('[!SetOption NumTime Y '..(isShown and 6 or 0)..'][!UpdateMeter NumTime]')
    return
  end
  SKIN:Bang((showBars and '[!ToggleMeter Bar'..name..']' or '')..'[!SetOption Bar'..name..' Group '..(isShown and 'Bar' or '""')..'][!UpdateMeter Bar'..name..']')
  ToggleGraph(name, SKIN:GetVariable('Open'..name) == '0')
  if name:sub(2, 3) == 'PU' then
    local proc = name:sub(1, 1)
    SKIN:Bang('[!SetOption Graph'..proc..'PU Y '..(SKIN:GetVariable('Show'..proc..'PU') == '0' and SKIN:GetVariable('Show'..proc..'PUT') == '0' and '-8R' or '""')..'][!UpdateMeter Graph'..proc..'PU]')
  elseif name ~= 'NetDn' then
    SKIN:Bang('[!SetOption Graph'..name..' Y '..(isShown and '""' or '-8R')..'][!UpdateMeter Graph'..name..']')
  end
end

function SetBatt()
  local batt, status, state = measures.Batt:GetValue(), measures.BattStatus:GetValue(), {'Charging','Critical','Low','High'}
  SKIN:Bang('[!'..(batt < 100 and showBars and 'Show' or 'Hide')..'Meter BarBatt][!SetOption BarBatt Group '..(batt < 100 and 'Bar' or '""')..'][!'..(batt < 100 and 'Show' or 'Hide')..'Meter NumBatt]')
  if status == 0 then return end
  SKIN:Bang('[!SetOption BarBatt Stroke "Stroke Color #*Batt'..state[status]..'Color*#"][!UpdateMeter BarBatt][!SetOption NumBatt FontColor #*Batt'..state[status]..'Color*#][!UpdateMeter NumBatt]')
end
