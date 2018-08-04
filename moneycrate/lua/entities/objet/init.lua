AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("moneyframe")
util.AddNetworkString("TakeMoney")
util.AddNetworkString("addmoneyonbox")
util.AddNetworkString("chattext")
util.AddNetworkString("frameclose")
util.AddNetworkString("firstframeclose")


function ENT:Initialize( )

	self:SetModel( "models/props_junk/wood_crate001a.mdl" )
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(  SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

end

function ENT:OnTakeDamage()
	return false
end

function ENT:AcceptInput( Name, Activator, Caller )

	net.Start("moneyframe")
	net.Send(Caller)

 	net.Receive("TakeMoney", function(len, Activator)

		local money = self:GetMoneyAmount()

    if IsValid(Activator) and Activator:IsPlayer() then

    	if money == 0 then

    		net.Start("chattext")
    			net.WriteString("[ERREUR]")
    			net.WriteString(" Il n'y a pas d'argent dans la boite")
    		net.Send(Activator)

    		Activator:EmitSound("buttons/button11.wav")
    		return false

    	else

    		net.Start("firstframeclose")
    			net.WriteString("firstcloseframe")
    		net.Send(Activator)

				self:SetMoneyAmount(0)
				Activator:addMoney(money)

			end

		end

	end)

	net.Receive("addmoneyonbox",function (len, ply)

		local valueString = net.ReadString()
		value = tonumber(valueString)
		local maxamountonthebox = 15000


		if ply:getDarkRPVar("money") < value then

			net.Start("chattext")
				net.WriteString("[ERREUR]")
				net.WriteString(" Vous n'avez pas assez d'argent")
			net.Send(ply)

			ply:EmitSound("buttons/button11.wav")
			return false

		elseif value == 0 then

			net.Start("chattext")
				net.WriteString("[ERREUR]")
				net.WriteString(" Veuillez saisir un montant au dessus de 0 !")
			net.Send(ply)

			ply:EmitSound("buttons/button11.wav")

			return false

		elseif value > maxamountonthebox then

			net.Start("chattext")
				net.WriteString("[ERREUR]")
				net.WriteString(" La capacité maximal de la boite est de "..maxamountonthebox.."$.")
			net.Send(ply)

			ply:EmitSound("buttons/button11.wav")

		else

			net.Start("frameclose")
				net.WriteString("closeframe")
			net.Send(ply)

			self:SetMoneyAmount(self:GetMoneyAmount() + value)
			ply:addMoney(-value)

		end

	end)

end
