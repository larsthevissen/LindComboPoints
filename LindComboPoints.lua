LindComboPoints = CreateFrame("Frame", "LindComboPoints", UIParent)
LindComboPoints:SetWidth(300)
LindComboPoints:SetHeight(20)
LindComboPoints:SetPoint("RIGHT", UIParent, "CENTER", -100, -70)
LindComboPoints.MaxPoints = 0
LindComboPoints:Show()

for i = 1, 10 do
  LindComboPoints[i] = CreateFrame("Frame", "LindPoint"..i, LindComboPoints)
  LindComboPoints[i]:SetHeight(LindComboPoints:GetHeight() - 4)
  LindComboPoints[i]:SetBackdrop( {
      bgFile = "Interface\\AddOns\\LindUF\\LindBar.tga",
      edgeFile = nil,
      tile = false, tileSize = 0, edgeSize = 8,
      insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
  LindComboPoints[i]:SetBackdropColor(1, 1, 1, 1)
end

LindComboPoints:SetScript("OnUpdate", function(self, ...)
    power = UnitPower("player", 4)
    maxComboPoints = UnitPowerMax(PlayerFrame.unit, SPELL_POWER_COMBO_POINTS)
    if maxComboPoints ~= self.MaxPoints then
      for i = 1, 10 do
        local width = self:GetWidth() / maxComboPoints
        LindComboPoints[i]:SetWidth(width-2)
        LindComboPoints[i]:ClearAllPoints();
        LindComboPoints[i]:SetPoint("LEFT", self, "LEFT", ((i-1)*width+1), 0)
      end
    end
    for x = 1, 10 do
      if x <= power then
        LindComboPoints[x]:Show()
      else
        LindComboPoints[x]:Hide()
      end
    end
  end)
