require "AdHoc"

local this = GetThis()
local entities = {}
local nextId = 0

function Start()
    entities[nextId] = CreateEntity()
    local transforms = GetComponent(entities[nextId], "Transform")
    transforms.scale.x = 0.1
    transforms.scale.y = 0.1
    transforms.scale.z = 0.1
    --local meshes = GetComponent(entities[nextId], "Mesh")
    --meshes:Load("cube.obj")
    AddComponent(entities[nextId], "RigidBody", "Box", "Dynamic")
    local tempRigidbody = GetComponent(entities[nextId], "RigidBody")
    tempRigidbody:SetTranslation(0.0 , 0.5, -1.0 )
    
    tempRigidbody:SetVelocity(0,0,0.2)
    tempRigidbody:SetHasGravity(false)
    tempRigidbody:SetTrigger(true)
    --tempRigidbody:SetRotation(math.rad(-90),0,0)
    tempRigidbody:UpdateGeometry()
    nextId=nextId+1
end

function Update()
    --位置のループ処理
    local transforms = GetComponent(entities[0], "Transform")
    local tempRigidbody = GetComponent(entities[0], "RigidBody")
    if transforms.translate.z>1.0 then 
        tempRigidbody:SetTranslation(0.0 , 0.5, -1.0 )
        tempRigidbody:UpdateGeometry()
    end

    --範囲ないなら緑に光る
    if transforms.translate.z>-0.1 and transforms.translate.z<0.1 then 
        material=GetComponent(entities[0],"Material")
        material.albedo.x=0
        material.albedo.y=1
        material.albedo.z=0
    else
        material=GetComponent(entities[0],"Material")
        material.albedo.x=1
        material.albedo.y=1
        material.albedo.z=1
    end
end
