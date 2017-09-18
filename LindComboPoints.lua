
LindComboPoints = {}
LindComboPoints.MAX = 10

-- basic Update function
LindComboPoints.Update = function(power, maxPower)
  if(maxPower > 0) then
    for i = 1, maxPower do
      if (i <= power) then
        LindComboPoints[i]:SetValue(1)
      else
        LindComboPoints[i]:SetValue(0)
      end
    end
  else
    for i = 1, LindComboPoints.MAX do
      LindComboPoints[i]:Hide()
    end
  end
end

-- Class Configuration
LindComboPoints.PALADIN = {}
LindComboPoints.PALADIN.power = 9
LindComboPoints.PALADIN.Update = function(power, maxPower)
  local spec = GetSpecialization()
  if (spec == 3) then
    LindComboPoints.Update(power, maxPower)
  else
    for i = 1, LindComboPoints.MAX do
      LindComboPoints[i]:Hide()
    end
  end
end

LindComboPoints.ROGUE = {}
LindComboPoints.ROGUE.power = 4
LindComboPoints.ROGUE.Update = function(power, maxPower)
  LindComboPoints.Update(power, maxPower)
end

LindComboPoints.DEATHKNIGHT = {}
LindComboPoints.DEATHKNIGHT.power = 5
LindComboPoints.DEATHKNIGHT.Update = function(power, maxPower)
  for i = 1, maxPower do
    local start, duration, runeReady = GetRuneCooldown(i)
    local cooldown = GetTime() - start
    LindComboPoints[i]:SetMinMaxValues(0, duration)
    LindComboPoints[i]:SetValue(cooldown)
  end
end

LindComboPoints.DRUID = {}
LindComboPoints.DRUID.power = 4
LindComboPoints.DRUID.Update = function(power, maxPower)
  local spec = GetSpecialization()
  if (spec == 2) then
    LindComboPoints.Update(power, maxPower)
  else
    for i = 1, LindComboPoints.MAX do
      LindComboPoints[i]:Hide()
    end
  end
end

LindComboPoints.MONK = {}
LindComboPoints.MONK.power = 12
LindComboPoints.MONK.Update = function(power, maxPower)
  local spec = GetSpecialization()
  if (spec == 3) then
    LindComboPoints.Update(power, maxPower)
  else
    for i = 1, LindComboPoints.MAX do
      LindComboPoints[i]:Hide()
    end
  end
end

LindComboPoints.WARLOCK = {}
LindComboPoints.WARLOCK.power = 7
LindComboPoints.WARLOCK.Update = function(power, maxPower)
  LindComboPoints.Update(power, maxPower)
end

--setup frame
LindComboPoints.Frame = CreateFrame("Frame", "LindComboPoints", UIParent)
LindComboPoints.Frame:SetWidth(345)
LindComboPoints.Frame:SetHeight(10)
LindComboPoints.Frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
LindComboPoints.Frame.MaxPoints = 0
LindComboPoints.Frame:Show()

--setup combo points as status bars
local localizedClass, englishClass, classIndex = UnitClass("player")
if (LindComboPoints[englishClass] ~= nil) then
  for i = 1, LindComboPoints.MAX do
    if not LindComboPoints[i] then
      LindComboPoints[i] = CreateFrame("StatusBar", "LindPoint"..i, LindComboPoints.Frame)
      LindComboPoints[i]:SetHeight(LindComboPoints.Frame:GetHeight() - 4)
      LindComboPoints[i]:SetStatusBarTexture("Interface\\AddOns\\LindUF\\LindBar.tga")
      LindComboPoints[i]:SetStatusBarColor(1, 1, 1, 1)
      LindComboPoints[i]:SetBackdrop( {
        bgFile = "Interface\\AddOns\\LindUF\\LindBar.tga",
        edgeFile = nil,
        tile = false, tileSize = 0, edgeSize = 8,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
      })
      LindComboPoints[i]:SetBackdropColor(0, 0, 0, .5)
      LindComboPoints[i]:SetMinMaxValues(0, 1)
      LindComboPoints[i]:Hide()
    end
  end

-- If LindUF is loaded, attach to top of player frame
  LindComboPoints.Frame:RegisterEvent("VARIABLES_LOADED")
  LindComboPoints.Frame:SetScript("OnEvent", function(self, event, ...)
    if (event == "VARIABLES_LOADED") then
      if(LindUF ~= nil) then
        LindComboPoints.Frame:SetPoint("BOTTOMLEFT", "lind.player.HealthBar", "TOPLEFT", 0, 0)
      end
    end
  end)

  LindComboPoints.Frame:SetScript("OnUpdate", function(self, event, ...)
    local power = UnitPower("player", LindComboPoints[englishClass].power)
    local maxPower = UnitPowerMax("player", LindComboPoints[englishClass].power)
    --reset size and position when needed
    if(maxPower ~= self.MaxPoints) then
      for i = 1, LindComboPoints.MAX do
        if (i <= maxPower) then
          local width = self:GetWidth() / maxPower
          LindComboPoints[i]:SetWidth(width - 2)
          LindComboPoints[i]:ClearAllPoints();
          LindComboPoints[i]:SetPoint("LEFT", self, "LEFT", ((i - 1) * width + 1), 0)
          LindComboPoints[i]:Show()
        else
          LindComboPoints[i]:Hide()
        end
      end
      self.maxPoints = maxPower
    end
    LindComboPoints[englishClass].Update(power, maxPower)
  end)
end
