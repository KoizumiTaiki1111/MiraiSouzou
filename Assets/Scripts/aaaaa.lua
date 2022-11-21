require "AdHoc"

local this = GetThis()

function Start()
    local transforms = GetComponent(this, "Transform")
    transforms.translate.y=transforms.translate.y+1
    transforms.scale.y=transforms.scale.y+1
    local tempRigidbody = GetComponent(this, "RigidBody")
    tempRigidbody:SetTranslation(transforms.translate.x, 0.2, transforms.translate.z )
    tempRigidbody.scale.y=5
    tempRigidbody:SetHasGravity(false)
    tempRigidbody:UpdateGeometry()
  
end

function Update()
    local transforms = GetComponent(this, "Transform")
    if  transforms.translate.y>=1 then
        --DestroyEntity(this)
    end
end
