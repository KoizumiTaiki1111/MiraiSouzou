require "AdHoc"

local this = GetThis()
local input = GetInput()
local t2={}
t2["RayFront"]=Vector3D:new()
local MaxHitObject=6
local HitObjectCnt=1
local RotationFlg=false
local Yangle=0
local FPSflg=false

local fbxname={}
fbxname[1]="bed.obj"
fbxname[2]="sofa_double.obj"
fbxname[3]="table.obj"
fbxname[4]="dai.obj"

function MoveCrossHair()
    local transform = GetComponent(this, "Transform")
    local Speed=0.01
    
    if input:GetKey(AdHoc.Key.w) then
        transform.translate.z = transform.translate.z + Speed
    elseif input:GetKey(AdHoc.Key.s) then
        transform.translate.z = transform.translate.z - Speed
    elseif input:GetKey(AdHoc.Key.a) then
        transform.translate.x = transform.translate.x - Speed
    elseif input:GetKey(AdHoc.Key.d) then
        transform.translate.x = transform.translate.x + Speed
    end

    if transform.translate.z>1 then
        transform.translate.z=1
    elseif transform.translate.z<-1 then
        transform.translate.z=-1
    end
    if transform.translate.x>1 then
        transform.translate.x=1
    elseif transform.translate.x<-1 then
        transform.translate.x=-1
    end

    local transforms = GetComponent(this, "Transform")
    transforms.translate.x = transform.translate.x
    transforms.translate.y = 1
    transforms.translate.z = transform.translate.z
    local tempRigidbody = GetComponent(this, "RigidBody")
    tempRigidbody:SetTranslation(transforms.translate.x, transforms.translate.y, transforms.translate.z )
end

function RayHit()
    local transform = GetComponent(this, "Transform")
    transform.translate.y=transform.translate.y-(transform.scale.y+0.01)
    local e = Raycast(transform.translate, t2["RayFront"], 0.3)
    transform.translate.y=transform.translate.y+(transform.scale.y+0.01)
    if e ~= 0 then
        local m = GetComponent(this, "Material")
        m.albedo.x =1
        m.albedo.y = 0
        m.albedo.z = 0
        if input:GetKeyUp(AdHoc.Key.space) then
            HitObjectCnt=HitObjectCnt+1
            material=GetComponent(e,"Material")
            material.albedo.x=0
            material.albedo.y=0
            material.albedo.z=1
            local transforms = GetComponent(e, "Transform")
            transforms.scale.x = 0.05
            transforms.scale.y = 0.05
            transforms.scale.z = 0.05
            local s = GetComponent(e, "Script")
            s:Call("Particle")
            --LogMessage(s:Get("Type"))
            local ObjectType=s:Get("Type")
            local meshes = GetComponent(e, "Mesh")
            meshes:Load(fbxname[ObjectType])

            AdHoc.Global.CameraShake=true
            local tempRigidbody = GetComponent(e, "RigidBody")
            tempRigidbody:SetVelocity(0,0,0)
            tempRigidbody:SetTranslation(transforms.translate.x, 0.1, transforms.translate.z )
            --tempRigidbody:SetScale(transforms.scale.x,transforms.scale.y,transforms.scale.z)
            tempRigidbody:UpdateGeometry()
           
       end
    else
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y =1
        m.albedo.z =1
    end
end

function RayHitRotation()
    local transform = GetComponent(this, "Transform")
    transform.translate.y=transform.translate.y-(transform.scale.y+0.01)
    local e = Raycast(transform.translate, t2["RayFront"], 0.7)
    transform.translate.y=transform.translate.y+(transform.scale.y+0.01)
    if e ~= 0 then
        local m = GetComponent(this, "Material")
        m.albedo.x =1
        m.albedo.y = 0
        m.albedo.z = 0
        -- material=GetComponent(e,"Material")
        -- material.albedo.x=1
        -- material.albedo.y=0
        -- material.albedo.z=0
        local transform3 = GetComponent(e, "Transform")
       
        Yangle= transform3.rotation.y
        if input:GetKeyUp(AdHoc.Key.j) then
            Yangle=Yangle+0.1
        elseif input:GetKeyUp(AdHoc.Key.l) then
            Yangle=Yangle-0.1
        end

        local tempRigidbody = GetComponent(e, "RigidBody")
        tempRigidbody:SetRotation(0,Yangle,0)
        tempRigidbody:UpdateGeometry()
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
    if FPSflg==false then
        MoveCrossHair()
        if HitObjectCnt>MaxHitObject then
            RotationFlg=true
         end
        if RotationFlg==false then
            RayHit()
        else
            RayHitRotation()
        end
        if input:GetKeyUp(AdHoc.Key.enter) and RotationFlg== true then
            FPSflg=true
            AdHoc.Global.FPSflg=FPSflg
        end
    else
        DestroyEntity(this)
    end
    
    
    AdHoc.Global.RotationFlg=RotationFlg
end
