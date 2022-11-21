require "AdHoc"

local this                  = GetThis()
local entities              = {}
local entitiesHitFlg        = {}
local entitiesObjectFlag    = {}
local nextId                = 0
local time                  = 0
local positionX             = -0.9

local scaleSizes = {}
scaleSizes[1]    = 0.075
scaleSizes[2]    = 0.1
scaleSizes[3]    = 0.125

local objScript = [[
    local this = GetThis()
    type       = 10
    hit        = false
    hitAreaFlg = false
    particleflg=false
    local audio

    --パーティクル用変数
    local particleentities={}
    local rigidbodies = {}
    local nextId = 0
    local transform
    local destroyparticletime = 0

    local isSet = false

    function IsSet(x)
        isSet = x
    end

    -- FIXME
    function HitArea()
        local transforms = GetComponent(this, "Transform")
        
        if transforms.translate.z<1.0 and transforms.translate.z>0.8 then
            hitAreaFlg=true
        elseif transforms.translate.z>-1.0 and transforms.translate.z<-0.8 then
            hitAreaFlg=true
        elseif transforms.translate.x<1.0 and transforms.translate.x>0.8 then
            hitAreaFlg=true
        elseif transforms.translate.x>-1.0 and transforms.translate.x<-0.8 then
            hitAreaFlg=true
        elseif transforms.translate.x>-0.2 and transforms.translate.x<0.2 then
            if transforms.translate.z>-0.2 and transforms.translate.z<0.2 then
                hitAreaFlg=true
            else
                hitAreaFlg=false
            end
        else
            hitAreaFlg=false
        end

        if transforms.translate.y<0.4 then
            hitAreaFlg=false
        end

        if hitAreaFlg == true then
            material=GetComponent(this,"Material")
            material.albedo.x=0
            material.albedo.y=0
            material.albedo.z=1
        elseif isSet == false then
            material=GetComponent(this,"Material")
            material.albedo.x=1
            material.albedo.y=1
            material.albedo.z=1
        end
    end

    function Start()
       type = math.random(1, 4)
       audio = Audio:new()
       audio:Create("attack.wav")
    end

    function Update()
        local s = GetComponent(AdHoc.Global.g_NailId, "Script")
        local rotationFlg = s:Get("rotationFlg")
        if rotationFlg == false then
            HitArea()
        end

        local transforms = GetComponent(this, "Transform")
        local r          = GetComponent(this, "RigidBody")
        if transforms.translate.z > 1.0 then
            r:SetTranslation(transforms.translate.x, 0.5, -1.0 )
            r:UpdateGeometry()
        end

        if rotationFlg == true then
            if transforms.translate.y >= 0.5 then
                DestroyEntity(this)
            end
        end
    end

    function FixedUpdate()
        if particleflg == true then
            destroyparticletime = destroyparticletime+1
            if destroyparticletime > 3 then
                 destroyparticletime=0
                 for i = 0, nextId - 1 do  
                    DestroyEntity(particleentities[i])
                 end
                particleflg=false
            end
        end
    end

    function Particle()

        audio:Play()

        particleflg=true
        local count = 50
        transform = GetComponent(this, "Transform")
        for i = 0, count do
            particleentities[nextId] = CreateEntity()
            local m = GetComponent(particleentities[nextId], "Material")
            m.albedo.x = 1
            m.albedo.y = 1
            m.albedo.z = 0

            local t = GetComponent(particleentities[nextId], "Transform")
            t.scale.x = 0.01
            t.scale.y = 0.01
            t.scale.z = 0.01

            AddComponent(particleentities[nextId], "RigidBody", "Box", "Dynamic");

            rigidbodies[nextId] = GetComponent(particleentities[nextId], "RigidBody")

            rigidbodies[nextId]:SetRestitution(0.1)
            rigidbodies[nextId]:SetPosition(transform.translate.x + math.random(0, 0), 
            transform.translate.y + transform.scale.y, 
            transform.translate.z + math.random(0, 0))
            rigidbodies[nextId]:AddForce(math.random(-1, 1), 10, math.random(-10, 10))
            nextId = nextId + 1
        end
    end
]]

function SpawnObject()
    entities[nextId] = CreateEntity()
    local transforms = GetComponent(entities[nextId], "Transform")

    local randomScale  = math.random(1, 3)
    transforms.scale.x = scaleSizes[randomScale]
    transforms.scale.y = scaleSizes[randomScale]
    transforms.scale.z = scaleSizes[randomScale]

    AddComponent(entities[nextId], "RigidBody", "Box", "Dynamic")
    AddComponent(entities[nextId], "Script", objScript)
    local r = GetComponent(entities[nextId], "RigidBody")
    r:SetTranslation(positionX, 0.5, -1.0 )
    positionX = positionX + 0.2
    
    r:SetVelocity(0, 0, 0.2)
    r:SetHasGravity(false)
    r:SetTrigger(true)
    r:UpdateGeometry()
    
    nextId = nextId + 1
end

function FixedUpdate()
    time = time + 1
   if time > 60 and  positionX < 0.9 then
    local s = GetComponent(AdHoc.Global.g_NailId, "Script")
    local rotationFlg = s:Get("rotationFlg")
    if rotationFlg == false then
        SpawnObject()
        time = 0
    end
   end
end
