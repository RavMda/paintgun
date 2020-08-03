include('shared.lua')

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.Category = 'Other'

SWEP.Purpose = 'Paint everything around you!'
SWEP.Author = 'Rav'

CreateMaterial('pgun_mat', 'UnlitGeneric', {
	['$basetexture'] = 'metal6',
	['$alpha'] = '0.7',
	['$color'] = '6 6 6'
})

local pgun_mat = Material('!pgun_mat')

net.Receive('pgun', function()
	local w, h = ScrW(), ScrH()

	hook.Add('HUDPaint', 'pgun', function()
		surface.SetMaterial(pgun_mat)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, w, h)
	end)

	timer.Create('pgun_timer', 30, 1, function()
		hook.Remove('HUDPaint', 'pgun')
	end)
end)