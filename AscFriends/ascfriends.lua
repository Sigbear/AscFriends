local AF = LibStub("AceAddon-3.0"):NewAddon("AscFriends", "AceEvent-3.0")

local buttonFramePool = {}

local tinsert = table.insert

local function InviteFriend(button, _)
  local name = button:GetName()

  local numFrame = string.sub(name, -1)
  -- char, lvl, Hero
  local friendsInfo = _G["FriendsFrameFriendsScrollFrameButton" .. numFrame .. "Name"]:GetText()
  -- this returns char, -- with the empty space
  local subIterator = string.gmatch(friendsInfo, "[^%s]+")
  -- return the first result of the iterator and shave away the empty space and , to get the name
  local friendsName = string.sub(subIterator(), 1, -2)
  InviteUnit(friendsName)
end

local function CreateButtonFrames()
  for i = 1, 11 do
    local uiParent = _G["FriendsFrameFriendsScrollFrameButton" .. i]
    local btn = CreateFrame("Button", "AscFriendsInvButton" .. i, uiParent, "UIPanelButtonTemplate")
    btn:SetHeight(30)
    btn:SetWidth(60)
    btn:SetText("Invite")
    btn:SetPoint("RIGHT", -15, 0)
    btn:SetScript("OnClick", InviteFriend)
    tinsert(buttonFramePool, i, btn)
  end
end

local function ShowButtons()
  -- show only if friend is online
  for i = 1, 11 do
    buttonFramePool[i]:Hide()
    local statusText = _G["FriendsFrameFriendsScrollFrameButton" .. i .. "Info"]:GetText()
    if (statusText and statusText ~= "Unknown") then
      buttonFramePool[i]:Show()
    end
  end
end

function AF:FRIENDLIST_UPDATE()
  ShowButtons()
end

function AF:OnInitialize()
  FriendsFrame:Show()
  FriendsFrame:Hide()
  self:RegisterEvent("FRIENDLIST_UPDATE")
  CreateButtonFrames()
  ShowButtons()
end
