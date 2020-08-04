include('shared.lua')

AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

function ENT:Initialize()
	self:SetColor(Color(0, 0, 0, 0))
	self:SetModel('models/Gibs/HGIBS.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)

	local len = 1
	local start = 25
	local end_n = 0

	util.SpriteTrail(self, 0, Color(255, 255, 255), true, start, end_n, len, 1 / (start + end_n) * 0.5, 'trails/smoke')

	SafeRemoveEntityDelayed(self, 5)
end

local paintgun_screen_effect = CreateConVar('paintgun_screen_effect', 1)

function ENT:StartTouch(ent)
	if ent and IsValid(ent) and ent ~= self.owner then
		if not ent.painted then
			local old_color = ent:GetColor()
			local old_material = ent:GetMaterial()

			ent:SetMaterial('models/shiny')
			ent:SetColor(Color(255, 255, 255))
			ent.painted = true

			if ent:IsPlayer() and paintgun_screen_effect:GetBool() == true then
				net.Start('pgun')
				net.Send(ent)
			end

			timer.Create('pgun_paint' .. ent:GetCreationID(), 30, 1, function()
				if ent and IsValid(ent) then
					ent:SetMaterial(old_material == '' and '' or old_material)
					ent:SetColor(old_color)
					ent.painted = nil
				end
			end)

			self:Remove()
		elseif ent:IsPlayer() then
			self:Remove()
		end
	end
end

function ENT:PhysicsCollide(col)
	util.Decal('PaintSplatBlue', col.HitPos, col.HitPos + col.OurOldVelocity)
end