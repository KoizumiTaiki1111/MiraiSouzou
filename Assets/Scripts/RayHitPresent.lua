require "AdHoc"

local this         = GetThis()
local input        = GetInput()
local maxHitObject = 6
local hitObjectCnt = 1
local angleY       = 0

-- Global flags
rotationFlg  = false
FPSflg       = false

AdHoc.Global.g_NailId = this

local meshName = {}
meshName[1]    = "bed.obj"
meshName[2]    = "dai.obj"
meshName[3]    = "sofa_double.obj"
meshName[4]    = "table.obj"

local downVector = Vector3D:new()
downVector.x = 0
downVector.y = -1
downVector.z = 0

function MoveCrossHair()
    local transform = GetComponent(this, "Transform")
    local speed     = 1

    -- Move
    if input:GetKey(AdHoc.Key.w) then
        transform.translate.z = transform.translate.z + speed * DeltaTime()
    elseif input:GetKey(AdHoc.Key.s) then
        transform.translate.z = transform.translate.z - speed * DeltaTime()
    elseif input:GetKey(AdHoc.Key.a) then
        transform.translate.x = transform.translate.x - speed * DeltaTime()
    elseif input:GetKey(AdHoc.Key.d) then
        transform.translate.x = transform.translate.x + speed * DeltaTime()
    end

    -- Movement limit
    if transform.translate.z > 1 then
        transform.translate.z = 1
    elseif transform.translate.z < -1 then
        transform.translate.z = -1
    end
    if transform.translate.x > 1 then
        transform.translate.x = 1
    elseif transform.translate.x < -1 then
        transform.translate.x = -1
    end

    -- Update rigidbody location
    local r = GetComponent(this, "RigidBody")
    r:SetTranslation(transform.translate.x, transform.translate.y, transform.translate.z )
end

function RayHit()
    local transform = GetComponent(this, "Transform")
    local rayOrigin = transform
    rayOrigin.translate.y = rayOrigin.translate.y - (rayOrigin.scale.y + 0.01)

    local e = Raycast(rayOrigin.translate, downVector, 0.3)

    if e ~= 0 then
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y = 0
        m.albedo.z = 0
        if input:GetKeyDown(AdHoc.Key.space) then
            hitObjectCnt = hitObjectCnt + 1

            local transforms = GetComponent(e, "Transform")
            transforms.scale.x = 0.05
            transforms.scale.y = 0.05
            transforms.scale.z = 0.05

            local s      = GetComponent(e, "Script")
            local meshes = GetComponent(e, "Mesh")
            meshes:Load(meshName[s:Get("type")])
            s:Call("IsSet", true)
            s:Call("Hit")
            s:Call("Particle")

            AdHoc.Global.CameraShake = true

            material = GetComponent(e, "Material")
            material.albedo.x = math.random(0, 1)
            material.albedo.y = math.random(0, 1)
            material.albedo.z = math.random(0, 1)

            -- TODO: change to mesh collider?
            local r = GetComponent(e, "RigidBody")
            r:SetVelocity(0, 0, 0)
            r:SetTranslation(transforms.translate.x, 0.1, transforms.translate.z)
            r:UpdateGeometry()
       end
    else
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y = 1
        m.albedo.z = 1
    end
end

function RayHitRotation()
    local transform = GetComponent(this, "Transform")
    local rayOrigin = transform
    rayOrigin.translate.y = rayOrigin.translate.y - (rayOrigin.scale.y + 0.01)
    local e = Raycast(rayOrigin.translate, downVector, 0.7)

    if e ~= 0 then
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y = 0
        m.albedo.z = 0
        local transform3 = GetComponent(e, "Transform")
       
        angleY = transform3.rotation.y
        if input:GetKeyUp(AdHoc.Key.j) then
            angleY = angleY + 0.1
        elseif input:GetKeyUp(AdHoc.Key.l) then
            angleY = angleY - 0.1
        end

        local tempRigidbody = GetComponent(e, "RigidBody")
        tempRigidbody:SetRotation(0, angleY, 0)
        tempRigidbody:UpdateGeometry()
    else
        local m = GetComponent(this, "Material")
        m.albedo.x = 1
        m.albedo.y = 1
        m.albedo.z = 1
    end
end

function Start()
    local t = GetComponent(this, "Transform")
    t.translate.y = 1
end

function Update()
    if FPSflg == false then
        MoveCrossHair()
        if hitObjectCnt > maxHitObject then
            rotationFlg = true
         end
        if rotationFlg == false then
            RayHit()
        else
            RayHitRotation()
        end
        if input:GetKeyUp(AdHoc.Key.enter) and rotationFlg == true then
            FPSflg = true
        end
    else
        --DestroyEntity(this)
        local m = GetComponent(this, "Mesh")
        m.toDraw = false;
    end
end
