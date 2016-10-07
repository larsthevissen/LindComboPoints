assert(LoadAddOn("LindUF"))

LindComboPointsFrame = CreateFrame("Frame", "LindComboPoints", UIParent)
LindComboPointsFrame:SetWidth(300)
LindComboPointsFrame:SetHeight(10)
LindComboPointsFrame:SetPoint("BOTTOMLEFT", "lind_player_life", "TOPLEFT", -0, -0)
LindComboPointsFrame.MaxPoints = 0
LindComboPointsFrame:Show()

LindComboPoints = {}


LindComboPointsFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
LindComboPointsFrame:SetScript("OnEvent", function(self, event, ...)
    for i = 1, #LindComboPoints do
      LindComboPoints[i]:Hide()
    end
    local _, _, class = UnitClass("player")
    local spec = GetSpecialization()
    if (class == 4) or (class == 11 and spec == 2) then
      for i = 1, 8 do
        if not LindComboPoints[i] then
          LindComboPoints[i] = CreateFrame("StatusBar", "LindPoint"..i, LindComboPointsFrame)
          LindComboPoints[i]:SetHeight(LindComboPointsFrame:GetHeight() - 4)
          LindComboPoints[i]:SetStatusBarTexture("Interface\\AddOns\\LindUF\\LindBar.tga")
          LindComboPoints[i]:SetStatusBarColor(1,1,0,1)
          LindComboPoints[i]:SetBackdrop( {
              bgFile = "Interface\\AddOns\\LindUF\\LindBar.tga",
              edgeFile = nil,
              tile = false, tileSize = 0, edgeSize = 8,
              insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
          LindComboPoints[i]:SetBackdropColor(.5, .5, .5, .5)
          LindComboPoints[i]:SetMinMaxValues(0, 1)
        end
      end
      LindComboPointsFrame:SetScript("OnUpdate", function(self, ...)
          power = UnitPower("player", 4)
          maxComboPoints = UnitPowerMax("player", 4)
          if maxComboPoints ~= self.MaxPoints then
            for i = 1, maxComboPoints do
              local width = self:GetWidth() / maxComboPoints
              LindComboPoints[i]:SetWidth(width-2)
              LindComboPoints[i]:ClearAllPoints();
              LindComboPoints[i]:SetPoint("LEFT", self, "LEFT", ((i-1)*width+1), 0)
            end
          end
          for x = 1, #LindComboPoints do
            if x <= maxComboPoints then
              if x <= power then
                LindComboPoints[x]:SetValue(1)
              else
                LindComboPoints[x]:SetValue(0)
              end
              LindComboPoints[x]:Show()
            else
              LindComboPoints[x]:Hide()
            end
          end
        end)

    elseif class == 6 then
      maxComboPoints = UnitPowerMax(PlayerFrame.unit, SPELL_POWER_RUNES)
      for i = 1, maxComboPoints do
        if not LindComboPoints[i] then
          LindComboPoints[i] = CreateFrame("StatusBar", "LindPoint"..i, LindComboPointsFrame)
          LindComboPoints[i]:SetHeight(LindComboPointsFrame:GetHeight() - 4)
          LindComboPoints[i]:SetStatusBarTexture("Interface\\AddOns\\LindUF\\LindBar.tga")
          LindComboPoints[i]:SetStatusBarColor(1,0,0,1)
          LindComboPoints[i]:SetBackdrop( {
              bgFile = "Interface\\AddOns\\LindUF\\LindBar.tga",
              edgeFile = nil,
              tile = false, tileSize = 0, edgeSize = 8,
              insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
          LindComboPoints[i]:SetBackdropColor(.5, .5, .5, .5)
        end
        LindComboPoints[i]:Show()
      end
      LindComboPointsFrame:SetScript("OnUpdate", function(self, ...)
          maxComboPoints = UnitPowerMax(PlayerFrame.unit, SPELL_POWER_RUNES)
          if maxComboPoints ~= self.MaxPoints then
            for i = 1, maxComboPoints do
              local width = self:GetWidth() / maxComboPoints
              LindComboPoints[i]:SetWidth(width-2)
              LindComboPoints[i]:ClearAllPoints();
              LindComboPoints[i]:SetPoint("LEFT", self, "LEFT", ((i-1)*width+1), 0)
            end
          end
          for x = 1, maxComboPoints do
            local start, duration, runeReady = GetRuneCooldown(x)
            local cooldown = GetTime()-start
            LindComboPoints[x]:SetMinMaxValues(0, duration)
            LindComboPoints[x]:SetValue(cooldown)
          end
        end)

    elseif class == 2 and spec == 3 then
      maxComboPoints = UnitPowerMax("player", 9)
      for i = 1, maxComboPoints do
        if not LindComboPoints[i] then
          LindComboPoints[i] = CreateFrame("StatusBar", "LindPoint"..i, LindComboPointsFrame)
          LindComboPoints[i]:SetHeight(LindComboPointsFrame:GetHeight() - 4)
          LindComboPoints[i]:SetStatusBarTexture("Interface\\AddOns\\LindUF\\LindBar.tga")
          LindComboPoints[i]:SetStatusBarColor(1,1,0,1)
          LindComboPoints[i]:SetBackdrop( {
              bgFile = "Interface\\AddOns\\LindUF\\LindBar.tga",
              edgeFile = nil,
              tile = false, tileSize = 0, edgeSize = 8,
              insets = { left = 0, right = 0, top = 0, bottom = 0 }
            })
          LindComboPoints[i]:SetBackdropColor(.5, .5, .5, .5)
        end
        LindComboPoints[i]:Show()
        LindComboPoints[i]:SetMinMaxValues(0, 1)
      end
      LindComboPointsFrame:SetScript("OnUpdate", function(self, ...)
          power = UnitPower("player", 9)
          maxComboPoints = UnitPowerMax("player", 9)

          if maxComboPoints ~= self.MaxPoints then
            for i = 1, maxComboPoints do
              local width = self:GetWidth() / maxComboPoints
              LindComboPoints[i]:SetWidth(width-2)
              LindComboPoints[i]:ClearAllPoints();
              LindComboPoints[i]:SetPoint("LEFT", self, "LEFT", ((i-1)*width+1), 0)
            end
          end
          for x = 1, #LindComboPoints do
            if x <= maxComboPoints then
              if x <= power then
                LindComboPoints[x]:SetValue(1)
              else
                LindComboPoints[x]:SetValue(0)
              end
              LindComboPoints[x]:Show()
            else
              LindComboPoints[x]:Hide()
            end
          end
        end)
    else
      LindComboPointsFrame:SetScript("OnUpdate", function(self, ...)
        end)
    end
  end)
