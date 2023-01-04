-- Lua SwitchBox for Beier USM-RC-3 widget V0.1
--
-- https://www.beier-electronic.de/modellbau/produkte/usm-rc-3/usm-rc-3.php
--
--
-- A Radiomaster TX16S widget for the EdgeTX OS to simulate Light on a USM-RC 3
--
-- Original Author: Dieter Bruse http://bruse-it.com/
-- Modifications by Thomas RUDOLF
--
--
-- This file is part of a free Widgetlibrary.
--
-- Smart Switch is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY, without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <http://www.gnu.org/licenses>.
local log_filename = "/LOGS/SSwitchWidget.txt"
local name = "Sswitch"
local touchedButton = -1
local BitmapButton = Bitmap.open("/WIDGETS/SSWITCH/PNG/Btn0.png")
local BitmapWidth, BitmapHeight = Bitmap.getSize(BitmapButton)

local options = {
  { "Border", COLOR, WHITE},
  { "SelectBorder", COLOR, RED},
  { "ButtonColor", COLOR, DARKGREEN},
  { "PressedColor", COLOR, GREEN},
  { "TwinChannel", BOOL, 0}
}
local ActiveChannel = 1
local ActiveButtonPage = 1
local LastActiveButton = 0

--[	####################################################################
--[	Value der Globalen Variable zur Übertragung der Tasten
--[	####################################################################
local KeyValues = {
Neutral = 0,
Wert01 = 750,
Wert02 = 665,
Wert03 = 580,
Wert04 = 495,
Wert05 = 410,
Wert06 = 325,
Wert07 = 240,
Wert08 = 155,
Wert09 = 70,
Wert10 = -70,
Wert11 = -155,
Wert12 = -240,
Wert13 = -325,
Wert14 = -410,
Wert15 = -495,
Wert16 = -580,
Wert17 = -665,
Wert18 = -750,
Wert19 = 750,
Wert20 = 665,
Wert21 = 580,
Wert22 = 495,
Wert23 = 410,
Wert24 = 325,
Wert25 = 240,
Wert27 = 155,
Wert28 = 70,
Wert29 = -70,
Wert29 = -155,
Wert30 = -240,
Wert31 = -325,
Wert32 = -410,
Wert33 = -495,
Wert34 = -580,
Wert35 = -665,
Wert36 = -750,
Umschaltung = 1020
}

--[	####################################################################
--[	Zuordnung der Globalen Variable für aktive Control im Widget
--[	####################################################################
local GlobalVarialble = {
  {GVarName="GV1",
  Index=0,
  Phase=0},
  {GVarName="GV2",
  Index=1,
  Phase=0}
}

local buttonType = {
  pushbutton = "pushbutton",
  togglebutton = "togglebutton",
  switch = "switch"
}


local configTable = {
  {
    -- Seite 1 Ebne 1
    {
{ Name="Licht +", FileName="001.png", Mode=buttonType.pushbutton,ROW=1,COL=1,Value=KeyValues.Wert01 },
{ Name="Licht -", FileName="002.png", Mode=buttonType.pushbutton,ROW=1,COL=2,Value=KeyValues.Wert02 },
{ Name="Blinker Links", FileName="003.png", Mode=buttonType.pushbutton,ROW=1,COL=3,Value=KeyValues.Wert03 },
{ Name="Warnblinker", FileName="004.png", Mode=buttonType.pushbutton,ROW=1,COL=4,Value=KeyValues.Wert04 },
{ Name="Blinker Rechts", FileName="005.png", Mode=buttonType.pushbutton,ROW=1,COL=5,Value=KeyValues.Wert05 },
{ Name="Rundumlicht", FileName="006.png", Mode=buttonType.pushbutton,ROW=1,COL=6,Value=KeyValues.Wert06 },
{ Name="Lichthupe", FileName="007.png", Mode=buttonType.pushbutton,ROW=2,COL=1,Value=KeyValues.Wert07 },
{ Name="Nebelschlusslicht", FileName="008.png", Mode=buttonType.pushbutton,ROW=2,COL=2,Value=KeyValues.Wert08 },
{ Name="Nebelscheinwerfer", FileName="009.png", Mode=buttonType.pushbutton,ROW=2,COL=3,Value=KeyValues.Wert09 },
{ Name="Arbeitsscheinwerfer Hinten", FileName="010.png", Mode=buttonType.pushbutton,ROW=2,COL=4,Value=KeyValues.Wert10 },
{ Name="Arbeitsscheinwerfer Vorne", FileName="011.png", Mode=buttonType.pushbutton,ROW=2,COL=5,Value=KeyValues.Wert11 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=2,COL=6,Value=KeyValues.Wert12 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=1,Value=KeyValues.Wert13 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=2,Value=KeyValues.Wert14 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=3,Value=KeyValues.Wert15 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=4,Value=KeyValues.Wert16 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=5,Value=KeyValues.Wert17 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=6,Value=KeyValues.Wert18 }
    },
    -- Seite 1 Ebene 2

  },
  {
    -- Seite 2 Ebene 1
    {
{ Name="Hupe", FileName="019.png", Mode=buttonType.pushbutton,ROW=1,COL=1,Value=KeyValues.Wert19 },
{ Name="Rückfahrwarner ausschalten", FileName="020.png", Mode=buttonType.pushbutton,ROW=1,COL=2,Value=KeyValues.Wert20 },
{ Name="Fahrsound ein/aus", FileName="021.png", Mode=buttonType.pushbutton,ROW=1,COL=3,Value=KeyValues.Wert21 },
{ Name="Lautstärke +", FileName="022.png", Mode=buttonType.pushbutton,ROW=1,COL=4,Value=KeyValues.Wert22 },
{ Name="Lautstärke -", FileName="023.png", Mode=buttonType.pushbutton,ROW=1,COL=5,Value=KeyValues.Wert23 },
{ Name="Ton aus", FileName="024.png", Mode=buttonType.pushbutton,ROW=1,COL=6,Value=KeyValues.Wert24 },
{ Name="WAV-Player: Play/Stop", FileName="025.png", Mode=buttonType.pushbutton,ROW=2,COL=1,Value=KeyValues.Wert25 },
{ Name="WAV-Player: Pause", FileName="026.png", Mode=buttonType.pushbutton,ROW=2,COL=2,Value=KeyValues.Wert26 },
{ Name="WAV-Player: Titel vor", FileName="027.png", Mode=buttonType.pushbutton,ROW=2,COL=3,Value=KeyValues.Wert27 },
{ Name="WAV-Player: Titel zurück", FileName="028.png", Mode=buttonType.pushbutton,ROW=2,COL=4,Value=KeyValues.Wert28 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=2,COL=5,Value=KeyValues.Wert29 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=2,COL=6,Value=KeyValues.Wert30 },
{ Name="Spiel mit Gaspedal", FileName="031.png", Mode=buttonType.pushbutton,ROW=3,COL=1,Value=KeyValues.Wert31 },
{ Name="Fahrsound Drehzahländerung", FileName="032.png", Mode=buttonType.pushbutton,ROW=3,COL=2,Value=KeyValues.Wert32 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=3,Value=KeyValues.Wert33 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=4,Value=KeyValues.Wert34 },
{ Name="RESERVE", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=5,Value=KeyValues.Wert35 },
{ Name="Kein Button auf der Fernsteuerung", FileName="000.png", Mode=buttonType.pushbutton,ROW=3,COL=6,Value=KeyValues.Wert36 }
    },
    -- Seite 2 Ebene 2
  }
}

local buttons = {}

--[	####################################################################
--[	Button Zustand. Gedrückt oder nicht.
--[	####################################################################
local buttonState = {
  active = "active",
  inactive = "inactive"
}


--[	####################################################################
--[	write logfile
--[	####################################################################
local function write_log(message, create)
--    local write_mode = "a"
--      if create ~= true then
--        write_mode = "a"
--      else
--        write_mode = "w"
--      end
--			local file = io.open(log_filename, write_mode)
--			io.write(file, message, "\r\n")
--			io.close(file)
end

--[#####################################################################################################
--[ CallBackFunktion wird aufgerufen wenn ein Button gedrückt wurde
--[#####################################################################################################
local function CallBackFunktion(ImageButton, widget)
  local Value = ImageButton.globalVarValue
--  lcd.drawText(0,180,"Button Pressed")
  if ImageButton.buttonState == buttonState.inactive then
    Value = KeyValues.Neutral
    if ActiveButtonPage == 2 and ImageButton.buttonType ~= buttonType.switch then
      ActiveButtonPage = 1
      LastActiveButton = 0
    end
  end
  write_log("Callback " .. ImageButton.ButtonName .. " State:" .. ImageButton.buttonState .. " Value:" .. Value .. " AktivBtnPg:" .. ActiveButtonPage, false)

  -- Zeilenumschaltung und Timer Handling
  if ImageButton.buttonType == buttonType.switch and Value ~= KeyValues.Neutral then
    if ActiveButtonPage == 2 then
      ActiveButtonPage = 1
      LastActiveButton = 0
    else
      ActiveButtonPage = 2
      LastActiveButton = getGlobalTimer()["session"]
    end
    ImageButton.buttonState = buttonState.inactive
  end

  model.setGlobalVariable(GlobalVarialble[ActiveChannel].Index, GlobalVarialble[ActiveChannel].Phase, Value)
  if Value ~= KeyValues.Neutral then
    if ImageButton.buttonType == buttonType.switch then
      playHaptic(20, 10 )
      playHaptic(20, 0 )
    else
      playHaptic(15, 0 )
    end
  end
end

local function doNothing()
end
--[#####################################################################################################
--[ CreateButton erzeugt einen Pushbutton oder ToggleButton
--[#####################################################################################################
local function CreateButton(Position, WidgetPosition, W, H, ButtonName, Image, ButtonType, globalVarValue, CallBack, flags)
  local self = {
    ButtonName = ButtonName,
    Image = Image,
    position = Position or { x = 0, y = 0, center = {}, bitmapScale = 100, radius = 0 },
    widgetposition = WidgetPosition or { x = 0, y = 0, center = {}, bitmapScale = 100, radius = 0 },
    xmax = Position.x + W,
    ymax = Position.y + H,
    w = W,
    h = H,
    callBack = CallBack or doNothing,
    buttonState = buttonState.inactive,
    buttonType = ButtonType or buttonType.pushbutton,
    buttonSelected = false,
    globalVarValue = globalVarValue or KeyValues.Neutral
  }

  function self.draw( event, widget)
    local pos = self.position
    if event == nil then
      pos = self.widgetposition
      if widget.zone.h < 84 then
        lcd.drawText(0,0,"Das Wideget benötigt min. 50% Ansicht in der Hoehe")
        lcd.drawText(0,15,"the widget need min. 50% view in hight")
        -- lcd.drawText(0,30,"Size " .. widget.zone.w .. "/" .. widget.zone.h)
        return
      end
    end

    if self.buttonSelected then
      lcd.drawFilledCircle(pos.center.x, pos.center.y, pos.radius, widget.options.SelectBorder)
    else
      lcd.drawFilledCircle(pos.center.x, pos.center.y, pos.radius, widget.options.Border)
    end

    if self.buttonState == buttonState.inactive then
      lcd.drawFilledCircle(pos.center.x, pos.center.y, pos.radius - 2, widget.options.ButtonColor)
    else
      lcd.drawFilledCircle(pos.center.x, pos.center.y, pos.radius - 2, widget.options.PressedColor)
    end
    lcd.drawBitmap(self.Image, pos.x, pos.y, pos.bitmapScale)
  end

  --[#####################################################################################################
  --[ Eventhandler für einen Button
  --[#####################################################################################################
  function self.onEvent(event, touchState, widget)
    write_log("self.OnEvent is entered at " .. self.ButtonName ,false)
    if event == nil then -- Widget mode
      -- Draw in widget mode. The size equals zone.w by zone.h
    else -- Full screen mode
      -- Draw in full screen mode. The size equals LCD_W by 
      if event ~= 0 then -- Do we have an event?
        write_log("self.OnEvent in event id:" .. event,false)
        if touchState then -- Only touch events come with a touchState
          write_log("self.OnEvent in touchState.",false)
          if event == EVT_TOUCH_FIRST then
            if self.buttonType == buttonType.pushbutton or self.buttonType == buttonType.switch then
              self.buttonState = buttonState.active
            elseif self.buttonType == buttonType.togglebutton then
              if self.buttonState == buttonState.active then
                self.buttonState = buttonState.inactive
              else
                self.buttonState = buttonState.active
              end
            end
            self.buttonSelected = true
            return self.callBack(self, widget)
            -- When the finger first hits the screen
          elseif event == EVT_TOUCH_BREAK then
            if self.buttonType == buttonType.pushbutton or self.buttonType == buttonType.switch then
              self.buttonState = buttonState.inactive
            end
            self.buttonSelected = false
            return self.callBack(self, widget)
            -- When the finger leaves the screen and did not slide on it
          elseif event == EVT_TOUCH_TAP then
            if self.buttonType == buttonType.pushbutton or self.buttonType == buttonType.switch then
              self.buttonState = buttonState.inactive
            end
            self.buttonSelected = false
            return self.callBack(self, widget)

            -- A short tap gives TAP instead of BREAK
            -- touchState.tapCount shows number of taps
          end
        else -- event ~= 0 and touchState == nil: key event
          write_log("self.OnEvent in KeyEvents.",false)
          if event == EVT_ENTER_FIRST then
            write_log("self.OnEvent EVT_ENTER_FIRST.",false)
            if self.buttonType == buttonType.pushbutton or self.buttonType == buttonType.switch then
              self.buttonState = buttonState.active
            elseif self.buttonType == buttonType.togglebutton then
              if self.buttonState == buttonState.active then
                self.buttonState = buttonState.inactive
              else
                self.buttonState = buttonState.active
              end
            end
            return self.callBack(self, widget)
          elseif event == EVT_VIRTUAL_ENTER then
            write_log("self.OnEvent EVT_VIRTUAL_ENTER.",false)
            if self.buttonType == buttonType.pushbutton or self.buttonType == buttonType.switch then
              self.buttonState = buttonState.inactive
            end
            return self.callBack(self, widget)
          end
        end
        write_log("End of Eventcheck at self.OnEnvent", false)
      end
      write_log("End of self.OnEvent.", false)
    end
  end

  return self
end -- CreateButton(...)

local function CalculateFullscreen(row, col, widget)
  local Position = { x = 0, y = 0, center = {}, bitmapScale = 100, radius = 0 }
  local WidgetPosition = { x = 0, y = 0, center = {}, bitmapScale = 100, radius = 0 }

  local Seitenrand = 4
  local WidgetSeitenrandX = 6
  local WidgetSeitenrandY = 1

  Position.x = ((Seitenrand + BitmapWidth) * col) - BitmapWidth
  Position.y = ((Seitenrand + BitmapHeight) * row) - BitmapHeight
  Position.center = {x = (Position.x + BitmapWidth) - (BitmapWidth / 2), y = (Position.y + BitmapHeight) - (BitmapHeight / 2)}
  Position.radius = BitmapWidth / 2

  WidgetPosition.bitmapScale = math.abs(((widget.zone.h / 2) / BitmapWidth ) * 100)
  local ScaledBitmapHight = BitmapWidth / 100 * WidgetPosition.bitmapScale
  local ScaledBitmapWidht = BitmapHeight / 100 *  WidgetPosition.bitmapScale
  WidgetPosition.x = (WidgetSeitenrandX + ScaledBitmapHight) * col - ScaledBitmapHight +4
  WidgetPosition.y = (WidgetSeitenrandY + ScaledBitmapWidht) * row - ScaledBitmapWidht -2
  WidgetPosition.center = {x = WidgetPosition.x + ScaledBitmapHight - (ScaledBitmapHight / 2)
                         , y = WidgetPosition.y + ScaledBitmapWidht - (ScaledBitmapWidht / 2)}
  WidgetPosition.radius = (BitmapWidth / 100 * WidgetPosition.bitmapScale) / 2

  return Position, WidgetPosition
end

--[#####################################################################################################
--[ LoadConfig erzeugt Button aus einer Datenstruktur
--[ Die Radiomaster TX16s hat eine Auflösung von 480px * 272px,
--[ die Summer der Bilder wird nicht geprüft ob sie auch auf den Bildschirm passen. Also bitte vorher rechnen :)
--[ Ändert sich die Bildhöhe muss zwingend die Variable ImageHight oben eingestellt werden.
--[ ====================================================================================================
local function LoadConfig(widget)
  write_log("LoadConfig: Bitmap Width:" .. BitmapWidth .. " BitmapHeight:" .. BitmapHeight,true)

  -- Inititalisieren der Globalenn Variable
  model.setGlobalVariable(GlobalVarialble[ActiveChannel].Index, GlobalVarialble[ActiveChannel].Phase, KeyValues.Neutral)

  buttons = {}
  for channel=1, #configTable do
    buttons[channel] = {}
    write_log("LoadConfig: Channel:" .. channel,false)
    for page=1, #configTable[channel] do
      write_log("LoadConfig: Page:" .. page,false)
      buttons[channel][page] = {}
      for idx=1, #configTable[channel][page] do
        local Position,WidgetPosition = CalculateFullscreen(configTable[channel][page][idx].ROW, configTable[channel][page][idx].COL, widget)
        write_log("LoadConfig: Row:" .. configTable[channel][page][idx].ROW .. "Col:" .. configTable[channel][page][idx].COL .. " x:" .. Position.x .. " y:" .. Position.y, false)
        buttons[channel][page][idx] = CreateButton(Position
                                ,WidgetPosition
                                ,BitmapWidth
                                ,BitmapHeight
                                ,configTable[channel][page][idx].Name
                                ,Bitmap.open("/WIDGETS/Sswitch/PNG/" .. configTable[channel][page][idx].FileName)
                                ,configTable[channel][page][idx].Mode
                                ,configTable[channel][page][idx].Value
                                , CallBackFunktion)
      end
    end
  end
end

--[#####################################################################################################
--[ findTouch Prüft ob ein Button via Touch oder Enter Button gedrückt wurde
--[#####################################################################################################
local function findTouched(event, touchState, widget)
  local result = false

  if event == nil then -- Widget mode
    -- Draw in widget mode. The size equals zone.w by zone.h
  else -- Full screen mode
    if event ~= 0 then
      if touchState then
        for i=1, #buttons[ActiveChannel][ActiveButtonPage] do
          if touchState.x >= buttons[ActiveChannel][ActiveButtonPage][i].position.x
            and touchState.x <= buttons[ActiveChannel][ActiveButtonPage][i].xmax
            and touchState.y >= buttons[ActiveChannel][ActiveButtonPage][i].position.y
            and touchState.y <= buttons[ActiveChannel][ActiveButtonPage][i].ymax then
            result = true
            write_log("findTouched found at [" .. buttons[ActiveChannel][ActiveButtonPage][i].ButtonName .. " Type:" ..buttons[ActiveChannel][ActiveButtonPage][i].buttonType, false)
            buttons[ActiveChannel][ActiveButtonPage][i].onEvent(event, touchState, widget);
          end
        end
      else
        if event == EVT_VIRTUAL_NEXT_PAGE or event == EVT_VIRTUAL_PREV_PAGE then
          if widget.options.TwinChannel == 1 then
            if ActiveChannel == 1 then
              ActiveChannel = 2
            else
              ActiveChannel = 1
            end
            playHaptic(10, 5 )
            playHaptic(10, 0 )
          end
        elseif event == EVT_VIRTUAL_NEXT then
          -- Als erstes den TouchState aufheben
          if touchedButton ~= -1 then
            buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonSelected = false
          end

          if touchedButton == -1 or touchedButton == #buttons[ActiveChannel][ActiveButtonPage] then
            touchedButton = 1
          else
            touchedButton = touchedButton + 1
          end
          buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonSelected = true
        elseif event == EVT_VIRTUAL_PREV then
          if touchedButton ~= -1 then
            buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonSelected = false
          end

          if touchedButton == -1 or touchedButton == 1 then
            touchedButton = #buttons[ActiveChannel][ActiveButtonPage]
          else
            touchedButton = touchedButton - 1
          end
          buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonSelected = true
        elseif event == EVT_VIRTUAL_ENTER or event == EVT_ENTER_FIRST then
          result = true
          if buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonType == buttonType.switch then
            ActiveButtonPage = 2
            LastActiveButton = getGlobalTimer()["session"]
            write_log("Umschaltung erkannt um:" .. LastActiveButton)
          end
          buttons[ActiveChannel][ActiveButtonPage][touchedButton].onEvent(event, touchState, widget)
        elseif event == EVT_EXIT_FIRST or event == 1540 then
          if touchedButton ~= -1 then
            buttons[ActiveChannel][ActiveButtonPage][touchedButton].buttonSelected = false
          end
        end
      end
    end
    return result
  end
end

local function create(zone, options)
  -- Runs one time when the widget instance is registered
  -- Store zone and options in the widget table for later use
  local widget = {
    zone = zone,
    options = options
  }
  -- Add local variables to the widget table,
  -- unless you want to share with other instances!
  widget.someVariable = 3
  -- Return widget table to EdgeTX
  LoadConfig(widget)
  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
    widget.options = options

end

local function background(widget)
  -- Runs periodically only when widget instance is not visible
end

local function refresh(widget, event, touchState)
  -- Runs periodically only when widget instance is visible
  -- If full screen, then event is 0 or event value, otherwise nil
  findTouched(event, touchState, widget)

  if ActiveButtonPage == 2 and LastActiveButton > 0 then
    if getGlobalTimer()["session"] - LastActiveButton > 10 then
      -- Reset ausführen
      write_log("Automatic Switch-Reset! Inactive Time:" ..  getGlobalTimer()["session"] - LastActiveButton .. "s",false)
      LastActiveButton = 0
      ActiveButtonPage = 1
      playHaptic(20, 10 )
      playHaptic(20, 0 )
    end

  end
  if #buttons > 0 and  #buttons[ActiveChannel] > 0 then
    for i=1, #buttons[ActiveChannel][ActiveButtonPage] do
      buttons[ActiveChannel][ActiveButtonPage][i].draw(event, widget);
    end
  end
end


return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}