ENT.PrintName = "Crate"
ENT.Author = "EGLY."
ENT.Category    = "Money Crate"
ENT.Spawnable        = true
ENT.AdminSpawnable    = true
ENT.AutomaticFrameAdvance = true
ENT.Type = "ai"
ENT.Base = "base_ai"

function ENT:SetAutomaticFrameAdvance( bUsingAnim )

    self.AutomaticFrameAdvance = bUsingAnim

end


function ENT:SetupDataTables()

	self:NetworkVar("Int" , 1 , "MoneyAmount")

end

