SWEP.ViewModel = Model('models/weapons/c_rpg.mdl')
SWEP.WorldModel = Model('models/weapons/w_rocket_launcher.mdl')
SWEP.PrintName = 'Paintgun'

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self:SetHoldType('rpg')
end