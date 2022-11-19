require "AdHoc"

local this = GetThis()
local input = GetInput()
local t2={}
t2["RayFront"]=Vector3D:new()

local fbxname={}
fbxname[1]="bed.obj"
fbxname[2]="dai.obj"
fbxname[3]="sofa_double.obj"
fbxname[4]="table.obj"

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
    local transforms = GetComponent(this, "Transform")
    transforms.translate.x = transform.translate.x
    transforms.translate.y = 1
    transforms.translate.z = transform.translate.z
end

function RayHit()
    local transform = GetComponent(this, "Transform")
    local e = Raycast(transform.translate, t2["RayFront"], 0.5)
    if e ~= 0 then
        local m = GetComponent(this, "Material")
        m.albedo.x =1
        m.albedo.y = 0
        m.albedo.z = 0
        if input:GetKey(AdHoc.Key.space) then
            material=GetComponent(e,"Material")
            material.albedo.x=0
            material.albedo.y=0
            material.albedo.z=1
            local transforms = GetComponent(e, "Transform")
            transforms.scale.x = 0.05
            transforms.scale.y = 0.05
            transforms.scale.z = 0.05
            local s = GetComponent(e, "Script")
            --LogMessage(s:Get("Type"))
            local ObjectType=s:Get("Type")
            local meshes = GetComponent(e, "Mesh")
            meshes:Load(fbxname[ObjectType])

            
            local tempRigidbody = GetComponent(e, "RigidBody")
            tempRigidbody:SetVelocity(0,0,0)
            tempRigidbody:SetTranslation(transforms.translate.x, 0.1, transforms.translate.z )
            tempRigidbody:UpdateGeometry()
       end
    else
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y =1
        m.albedo.z =1
    end
end

function Start()
    t2["RayFront"].x=0
    t2["RayFront"].y=-1
    t2["RayFront"].z=0
end

function Update()
    MoveCrossHair()
    RayHit()
end
