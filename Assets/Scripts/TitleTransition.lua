require "AdHoc"

local this = GetThis()
local input = GetInput()

function Start()

end

function Update()
    if input:GetKeyUp(AdHoc.Key.enter) then
        LoadScene( "S_MainGame.scene" )
    end
end
