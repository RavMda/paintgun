include('shared.lua')

AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

util.AddNetworkString('pgun')

SWEP.paint_balls = 5
SWEP.max_paint_balls = 5
SWEP.reload_time = 10 -- seconds
SWEP.next_reload = 0 -- for player notify

local paintgun_limited = CreateConVar('paintgun_limited', 1)
local paintgun_cooldown = CreateConVar('paintgun_cooldown', SWEP.reload_time)

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()

	if self.paint_balls > 0 or owner:IsSuperAdmin() or paintgun_limited:GetBool() == false then
		owner:EmitSound('physics/flesh/flesh_squishy_impact_hard4.wav', 30, nil, nil, CHAN_WEAPON)

		local pgun = ents.Create('paintgun_ball')
		pgun:SetPos(owner:EyePos() + owner:GetAimVector() * 20)
		pgun:Spawn()
		pgun:Activate()
		pgun:GetPhysicsObject():AddVelocity(owner:GetAimVector() * 800)
		pgun.owner = owner

		if not owner:IsSuperAdmin() then
			self.paint_balls = self.paint_balls - 1
			self.next_reload = paintgun_cooldown:GetInt() + CurTime()

			timer.Create('pgun_ball_reload' .. self:GetCreationID(), paintgun_cooldown:GetInt(), 1, function()
				if IsValid(self) then
					self.paint_balls = self.paint_balls + (self.max_paint_balls - self.paint_balls)
				end
			end)
		end
	else
		owner:EmitSound('buttons/weapon_cant_buy.wav', 30, nil, nil, CHAN_WEAPON)
	end
end