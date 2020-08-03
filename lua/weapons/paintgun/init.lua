include('shared.lua')

AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

util.AddNetworkString('pgun')

SWEP.PaintBalls = 5
SWEP.MaxPaintBalls = 5
SWEP.ReloadTime = 1 -- minutes
SWEP.NextReload = 0 -- for player notify

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	if self.PaintBalls > 0 or owner:IsSuperAdmin() then
		owner:EmitSound('zwf/zwf_watering.wav') -- change it later

		timer.Simple(0.5, function()
			owner:StopSound('zwf/zwf_watering.wav')
		end)

		local pgun = ents.Create('pgun_ball')
		pgun:SetPos(owner:EyePos() + owner:GetAimVector() * 20)
		pgun:Spawn()
		pgun:Activate()
		pgun:GetPhysicsObject():AddVelocity(owner:GetAimVector() * 800)
		pgun.owner = owner

		if not owner:IsSuperAdmin() then
			self.PaintBalls = self.PaintBalls - 1
			self.NextReload = self.ReloadTime * 60 + CurTime()

			timer.Create('pgun_ball_reload' .. self:GetCreationID(), self.ReloadTime * 60, 1, function()
				if IsValid(self) then
					self.PaintBalls = self.PaintBalls + (self.MaxPaintBalls - self.PaintBalls)
				end
			end)
		end
	else
		GAMEMODE:Error(owner, 'Please wait ' ..  math.Round(self.NextReload - CurTime()) .. ' s. ')
	end
end