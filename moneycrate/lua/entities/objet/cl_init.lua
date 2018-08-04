include("shared.lua")

surface.CreateFont( "CaviarDreamsMoneyAmount", { font = "Caviar Dreams", size = 45, weight = 500, antialias = true } )  surface.CreateFont( "CaviarDreams22", { font = "Caviar Dreams" , size = 22, weight = 500, antialias = true } )  surface.CreateFont( "CaviarDreams20", { font = "Caviar Dreams" , size = 20, weight = 500, antialias = true } )

local surface = surface;
local Color = Color;
local LocalPlayer = LocalPlayer
local draw = draw;
local vgui = vgui;
local gui = gui;
local white = Color(255, 255, 255)
local smoothbox = 300
local smoothadd = 290
local smoothtake = 290
local smoothcb2 = 30
local smoothbackbutton = 30


function ENT:Draw()

	self:DrawModel()

	local pos = self:GetPos()

	local ang = self:GetAngles()

	local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)

	alpha = math.Clamp(1.25 - alpha, 0 ,1)

	ang:RotateAroundAxis( ang:Up(), 90 )

	ang:RotateAroundAxis( ang:Forward(), 90 )

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 550 then

		cam.Start3D2D(pos + ang:Right()* - 15 + ang:Up() * 20.5 + ang:Forward()* -10, ang, 0.1)

			draw.RoundedBox(0,-50,20,300,175, Color( 25, 25, 25, 255 * alpha ) )

			draw.SimpleText("$"..self.Entity:GetMoneyAmount(),"CaviarDreamsMoneyAmount",100,120, Color( 255, 255, 255, 255 * alpha ) , 1 , 1)

			draw.SimpleText("Argent totale :","CaviarDreamsMoneyAmount",100,50, Color(255,255,255,255 * alpha ) , 1 , 1 )

		cam.End3D2D()

	end

end

net.Receive("moneyframe",function (len)

	local frame = vgui.Create("DFrame")
	frame:SetSize(300,150)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")
	frame:ShowCloseButton(false)
	frame:SetVisible(true)
	frame.Paint = function (self , w , h)
		draw.RoundedBox(0,0,0, w , h , Color( 25, 25, 25 ) )
	end

	local cb = vgui.Create("DButton" , frame)
	cb:SetSize(300,45)
	cb:SetPos(0,0)
	cb:SetText("Fermer")
	cb:SetFont("CaviarDreams22")
	cb:SetTextColor( Color( 255, 255, 255 ) )
  cb.OnCursorEntered = function( self ) surface.PlaySound("UI/buttonrollover.wav") self.smoothbox = true end
  cb.OnCursorExited = function( self ) self.smoothbox = false end
  cb.Paint = function ( self , w , h )

    if self:IsHovered() then
      draw.RoundedBox(0,0,0, w, h , Color( 25, 25, 25 ) )
      smoothbox = Lerp( 0.05, smoothbox ,w )
      draw.RoundedBox(0,0,0, smoothbox, h , Color( 5, 5, 5 ) )
    else
      draw.RoundedBox(0,0,0, w, h , Color( 25, 25, 25 ) )
      smoothbox = Lerp( 0.05, smoothbox , 0 )
      draw.RoundedBox(0,0,0, smoothbox , h , Color( 5, 5, 5 ) )
    end

  end

	cb.DoClick = function ()
    surface.PlaySound("UI/buttonclick.wav")
		frame:Close()
	end


	local add = vgui.Create("DButton" , frame)
	add:SetSize(290,30)
	add:SetPos(5,100)
	add:SetText("Ajouter de l'argent")
	add:SetFont("CaviarDreams20")
	add:SetTextColor( Color( 25, 25, 25 ) )
  add.OnCursorEntered = function( self ) self.smoothadd = true surface.PlaySound("UI/buttonrollover.wav") end
  add.OnCursorExited = function( self ) self.smoothadd = false end
  add.Paint = function ( self , w , h )

    if self:IsHovered() then
      draw.RoundedBox(0,0,0, w, h , Color( 255, 255, 255 ) )
      smoothadd = Lerp( 0.05, smoothadd ,w )
      draw.RoundedBox(0,0,0, smoothadd, h , Color( 235, 235, 235 ) )
    else
      draw.RoundedBox(0,0,0, w, h , Color( 255, 255, 255 ) )
      smoothadd = Lerp( 0.05, smoothadd , 0 )
      draw.RoundedBox(0,0,0, smoothadd , h , Color( 235, 235, 235 ) )
    end

  end

	add.DoClick = function ()

    surface.PlaySound("UI/buttonclick.wav")
		frame:SetVisible(false)

		local textframe = vgui.Create("DFrame")
		textframe:SetSize(300,100)
		textframe:Center()
		textframe:MakePopup()
		textframe:SetTitle("")
    textframe:ShowCloseButton(false)
		textframe.Paint = function (self , w , h)

			draw.RoundedBox(0,0,0, w , h , Color( 33, 47, 61 ) )
      draw.SimpleText("Montant à déposer", "CaviarDreams20", w / 4  , h / 4  , Color( 255, 255, 255 ) )

		end


    local backbutton = vgui.Create( "DButton", textframe )
    backbutton:SetPos(0,0)
    backbutton:SetSize(30,50)
    backbutton:SetText("←")
    backbutton:SetTextColor( Color( 250, 250, 250 ) )
    backbutton:SetFont("CaviarDreams20")
    backbutton.OnCursorEntered = function( self ) self.smoothbackbutton = true surface.PlaySound( "UI/buttonrollover.wav" )  end
    backbutton.OnCursorExited = function( self ) self.smoothbackbutton = false end
    backbutton.Paint = function ( self , w , h )

      if self:IsHovered() then
        draw.RoundedBox(0,0,0, w, h , Color( 33, 47, 61 ) )
        smoothbackbutton = Lerp( 0.05, smoothbackbutton ,w )
        draw.RoundedBox(0,0,0, smoothbackbutton, h , Color( 30, 44, 58 ) )
      else
        draw.RoundedBox(0,0,0, w, h , Color( 33, 47, 61 ) )
        smoothbackbutton = Lerp( 0.05, smoothbackbutton , 0 )
        draw.RoundedBox(0,0,0, smoothbackbutton , h , Color( 30, 44, 58 ) )
      end

    end

    backbutton.DoClick = function ()
      surface.PlaySound( "UI/buttonclick.wav" )
      textframe:Close()
      frame:SetVisible(true)
    end

    local cb2 = vgui.Create("DButton" , textframe)
    cb2:SetPos(270,0)
    cb2:SetSize(30,50)
    cb2:SetText("X")
    cb2:SetTextColor( Color( 250, 250, 250 ) )
    cb2:SetFont("CaviarDreams20")
    cb2.OnCursorEntered = function( self ) self.smoothcb2 = true surface.PlaySound( "UI/buttonrollover.wav" ) end
    cb2.OnCursorExited = function( self ) self.smoothcb2 = false end
    cb2.Paint = function ( self , w , h )

      if self:IsHovered() then
        draw.RoundedBox(0,0,0, w, h , Color( 30, 44, 58 ) )
        smoothcb2 = Lerp( 0.05, smoothcb2 , 0 )
        draw.RoundedBox(0,0,0, smoothcb2 , h , Color( 33, 47, 61 ) )
      else
        draw.RoundedBox(0,0,0, w, h , Color( 30, 44, 58 ) )
        smoothcb2 = Lerp( 0.05, smoothcb2 ,w )
        draw.RoundedBox(0,0,0, smoothcb2, h , Color( 33, 47, 61 ) )
      end

    end

    cb2.DoClick = function ()
      surface.PlaySound( "UI/buttonclick.wav" )
      textframe:Close()
    end

		local textentry = vgui.Create("DTextEntry" , textframe)
		textentry:SetSize(290,25)
		textentry:SetPos(5,65)
		textentry:SetNumeric( true )
    textentry:SetText("Saisir un montant")
    textentry.OnGetFocus = function ()

      if textentry:GetText() == "Saisir un montant" then
        textentry:SetText("")
      end

    end

		textentry.OnEnter = function (self)

      if self:GetValue() ==  "" then
          surface.PlaySound("buttons/button11.wav")
          chat.AddText(Color(33, 150, 243), "[ERREUR]", Color(255, 255, 255), " Veuillez saisir un montant" )
          return false
      end

			net.Start("addmoneyonbox")
				net.WriteString(self:GetValue())
			net.SendToServer()

      net.Receive("frameclose", function (len)

        if net.ReadString() == "closeframe" then
          surface.PlaySound("UI/buttonclickrelease.wav")
          textframe:Close()
        end

      end)

		end

	end


	local take = vgui.Create("DButton" , frame)
	take:SetSize(290,30)
	take:SetPos(5,65)
	take:SetText("Prendre l'argent")
	take:SetFont("CaviarDreams20")
	take:SetTextColor( Color( 25, 25, 25 ) )
  take.OnCursorEntered = function( self ) self.smoothtake = true end
  take.OnCursorExited = function( self ) self.smoothtake = false end
  take.Paint = function ( self , w , h )

    if self:IsHovered() then
      draw.RoundedBox(0,0,0, w, h , Color( 255, 255, 255 ) )
      smoothtake = Lerp( 0.05, smoothtake ,w )
      draw.RoundedBox(0,0,0, smoothtake, h , Color( 235, 235, 235 ) )
    else
      draw.RoundedBox(0,0,0, w, h , Color( 255, 255, 255 ) )
      smoothtake = Lerp( 0.05, smoothtake , 0 )
      draw.RoundedBox(0,0,0, smoothtake , h , Color( 235, 235, 235 ) )
    end

  end

	take.DoClick = function ()

    surface.PlaySound("UI/buttonclickrelease.wav")
		net.Start("TakeMoney")
		net.SendToServer()

    net.Receive("firstframeclose", function (len)

      if net.ReadString() == "firstcloseframe" then
        frame:Close()
      end

    end)

	end

  take.OnCursorEntered = function ()
    surface.PlaySound("UI/buttonrollover.wav")
  end

end)

net.Receive("chattext", function (len, ply)

  chat.AddText(Color(33, 150, 243), net.ReadString(), Color(255, 255, 255), net.ReadString() )

end)

