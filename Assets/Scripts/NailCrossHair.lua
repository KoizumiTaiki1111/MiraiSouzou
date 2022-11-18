require "AdHoc"

local this = GetThis()
local input = GetInput()
local entities = {}
local Hit=false
local Shoot=false
local hitobject=0

function OnTriggerEnter(rhs)
    LogMessage("111")
    hitobject=rhs
    material=GetComponent(entities[0],"Material")
    material.albedo.x=0
    material.albedo.y=1
    material.albedo.z=0
    Hit=true
end


function OnTriggerExit(rhs)
    material=GetComponent(entities[0],"Material")
    material.albedo.x=1
    material.albedo.y=1
    material.albedo.z=1
    Hit=false
 end

function HitAction()
    if input:GetKey(AdHoc.Key.space) and Hit==true then
        material=GetComponent(hitobject,"Material")
        material.albedo.x=1
        material.albedo.y=0
        material.albedo.z=0
        local transforms = GetComponent(hitobject, "Transform")
        local tempRigidbody = GetComponent(hitobject, "RigidBody")
        tempRigidbody:SetVelocity(0,0,0)
        tempRigidbody:SetTranslation(transforms.translate.x, 0.1, transforms.translate.z )
        tempRigidbody:UpdateGeometry()
   end
end


function MoveCrossHair()
    local transform = GetComponent(this, "Transform")
    local Speed=0.02
    
    if input:GetKey(AdHoc.Key.w) then
        transform.translate.z = transform.translate.z + Speed
       
    elseif input:GetKey(AdHoc.Key.s) then
        transform.translate.z = transform.translate.z - Speed
      
    elseif input:GetKey(AdHoc.Key.a) then
        transform.translate.x = transform.translate.x - Speed
       
    elseif input:GetKey(AdHoc.Key.d) then
        transform.translate.x = transform.translate.x + Speed
       
    end
    local tempRigidbody = GetComponent(this, "RigidBody")
    tempRigidbody:SetTranslation(transform.translate.x ,1, transform.translate.z )
    tempRigidbody:UpdateGeometry()
    local transforms = GetComponent(entities[0], "Transform")
    transforms.translate.x = transform.translate.x
    transforms.translate.y = 1
    transforms.translate.z = transform.translate.z
end

function Start()
    entities[0] = CreateEntity()
    local transforms = GetComponent(entities[0], "Transform")
    transforms.scale.x = 0.05
    transforms.scale.y = 0.2
    transforms.scale.z = 0.05
   
    --local meshes = GetComponent(entities[nextId], "Mesh")
    --meshes:Load("cube.obj")
    -- AddComponent(entities[0], "RigidBody", "Box", "Dynamic")
    -- local tempRigidbody = GetComponent(entities[0], "RigidBody")
    -- tempRigidbody:SetTranslation(0.0 , , 0.0 )
    -- tempRigidbody:SetHasGravity(false)
    -- tempRigidbody:SetTrigger(false)
    -- tempRigidbody:UpdateGeometry()
end

function Update()
MoveCrossHair()
HitAction()
end

