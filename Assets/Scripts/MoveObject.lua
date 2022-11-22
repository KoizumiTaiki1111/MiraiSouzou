require "AdHoc"

local this                  = GetThis()
local entities              = {}
local entitiesHitFlg        = {}
local entitiesObjectFlag    = {}
local nextId                = 0
local time                  = 0
local positionX             = -0.9

local objScript = [[
    local this = GetThis()
    type       = 10
    hit        = false
    local audio
    local idletime = 0
    local randomScale  = math.random(1, 3)
    local scaleSizes = {}
    scaleSizes[1]    = 0.075
    scaleSizes[2]    = 0.1
    scaleSizes[3]    = 0.125
    local once = false

    --flg
    hitAreaFlg = false
    particleflg=false
    moveflg=true
    moveingtime=0
    idleflg = true

    --gorst
    local gorstentities = {}
    local gorstnextid = 0
    
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

   
    function Hit()
        moveflg=false
        DestoryGorst()
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
       randomScale  = math.random(1, 3)
       type = math.random(1, 4)
       audio = Audio:new()
       audio:Create("attack.wav")
       GorstSpawn()
    end

    function Update()
        if idleflg == true then
            StartAction()
        else
            if once == false then
                local r = GetComponent(this, "RigidBody")
                r:SetVelocity(0, 0, 0.2)
                once=true
            end
            if moveflg==true then
                Moveing()
            end
            GorstFollow()

            local s = GetComponent(AdHoc.Global.g_NailId, "Script")
            local rotationFlg = s:Get("rotationFlg")
            if rotationFlg == false then
                HitArea()
            else
                local transforms = GetComponent(this, "Transform")
                if transforms.translate.y >= 0.3 then
                    DestroyEntity(this)
                    DestoryGorst()
                end
            end
        end
    end

    function FixedUpdate()
        moveingtime=moveingtime+0.1
        if idletime>2 then
            idleflg=false
        else
            idletime=idletime+0.1
        end
        if particleflg == true then
            destroyparticletime = destroyparticletime+1
            if destroyparticletime > 2 then
                 destroyparticletime=0
                 for i = 0, nextId - 1 do  
                    DestroyEntity(particleentities[i])
                 end
                particleflg=false
            end
        end
    end

    function StartAction()
        local transforms = GetComponent(this, "Transform")
        local r = GetComponent(this, "RigidBody")
        transforms.scale.x     =  scaleSizes[randomScale]*(idletime/2)
        transforms.scale.y     =  scaleSizes[randomScale]*(idletime/2)
        transforms.scale.z     =  scaleSizes[randomScale]*(idletime/2)
        r.scale.x= transforms.scale.x
        r.scale.y= transforms.scale.y
        r.scale.z= transforms.scale.z
        for i = 0, gorstnextid-1 do
            local gorsttransforms = GetComponent(gorstentities[i], "Transform")
            gorsttransforms.scale.x     = transforms.scale.x * 0.7
            gorsttransforms.scale.y     = transforms.scale.y * 0.7
            gorsttransforms.scale.z     = transforms.scale.z * 0.7
            gorsttransforms.translate.x = transforms.translate.x
            gorsttransforms.translate.y = transforms.translate.y
            gorsttransforms.translate.z = (transforms.translate.z- transforms.scale.z * 2.5)+( transforms.scale.z * 5*i)
            gorsttransforms.rotation.x  =  math.rad(-90)
            gorsttransforms.rotation.y  = math.rad((180/(idletime/2)))
            gorsttransforms.rotation.z  =0
            if i==1 then
                gorsttransforms.rotation.x = math.rad(-90)
                gorsttransforms.rotation.y = math.rad(180)+math.rad((180/(idletime/2)))
                gorsttransforms.rotation.z =0
            end
           
        end
       r:UpdateGeometry()
    end

    function GorstSpawn()
        for i = 0, 1 do
            gorstentities[gorstnextid] = CreateEntity()
            local gorsttransforms = GetComponent(gorstentities[gorstnextid], "Transform")
            local meshes = GetComponent(gorstentities[gorstnextid], "Mesh")
            meshes:Load("ghost_simple.fbx")
            gorstnextid = gorstnextid + 1
        end
    end

    function GorstFollow()
        for i = 0, gorstnextid-1 do
            local transforms = GetComponent(this, "Transform")
            local gorsttransforms = GetComponent(gorstentities[i], "Transform")
            gorsttransforms.translate.x = transforms.translate.x
            gorsttransforms.translate.y = transforms.translate.y
            gorsttransforms.translate.z = (transforms.translate.z-transforms.scale.z * 2.5)+(transforms.scale.z * 5*i)
        end
    end

    function Moveing()
        local transforms = GetComponent(this, "Transform")
        transforms.translate.x = transforms.translate.x
        transforms.translate.y = transforms.translate.y+(math.sin(moveingtime)/200)
        transforms.translate.z = transforms.translate.z
        local r = GetComponent(this, "RigidBody")
        r:SetTranslation( transforms.translate.x, transforms.translate.y,  transforms.translate.z )
        
        if transforms.translate.z > 1.0 then
            r:SetTranslation(transforms.translate.x,transforms.translate.y, -1.0 )
        end
    end

    function DestoryGorst()
        for i = 0, gorstnextid-1 do
            gorstnextid=0
            DestroyEntity(gorstentities[i])
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
    transforms.scale.x =0
    transforms.scale.y =0
    transforms.scale.z = 0

    AddComponent(entities[nextId], "RigidBody", "Box", "Dynamic")
    AddComponent(entities[nextId], "Script", objScript)
    local r = GetComponent(entities[nextId], "RigidBody")
    r:SetTranslation(positionX, 0.5, -1.0 )
    positionX = positionX + 0.2
    
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
