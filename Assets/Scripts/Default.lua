require "AdHoc"

local this = GetThis()

local audio = Audio:new()

function Start()
    audio:Create("attack.wav")
   
end

function Update()

end

function OnCollisionEnter()
     audio:Play()
end
