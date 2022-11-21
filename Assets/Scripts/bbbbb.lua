require "AdHoc"

local this = GetThis()

function Start()
    local transforms = GetComponent(this, "Transform")
    transforms.translate.y=transforms.translate.y+1
    transforms.scale.y=transforms.scale.y+1
end

function Update()
    local transforms = GetComponent(this, "Transform")
    if  transforms.translate.y>=1 then
        --DestroyEntity(this)
    end
end
