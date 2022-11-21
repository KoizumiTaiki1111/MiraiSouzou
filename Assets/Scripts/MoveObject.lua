require "AdHoc"

local this = GetThis()
local entities = {}
local entitiesHitFlg = {}
local entitiesObjectFlag = {}
local nextId = 0
local once =false
local time=0
local Position_x=-0.9
--LogMessage("")


local fbxname={}
fbxname[1]="bed.obj"
fbxname[2]="sofa_double.obj"
fbxname[3]="table.obj"
fbxname[4]="dai.obj"

local reel = {}

local ObjectType = [[
    local this = GetThis()
    value = 10
    Type = 10
    Hit=false
    HitAreaFlg=false
    Particleflg=false
    local t2={}
    t2["RayFront2"]=Vector3D:new()

    --パーティクル用変数
    Particleentities={}
    local rigidbodies = {}
    local nextId = 0
    local transform
    local destroyparticletime = 0

    function GetValue(x)
        return value * x
    end

    function SetHit()
       Hit=true
    end

    function SetParticle()
        Particleflg=true
     end

    function RotationHit()
        -- local transforms = GetComponent(this, "Transform")
        -- transforms.translate.y=transforms.translate.y+0.2
        -- local e = Raycast(transforms.translate, t2["RayFront2"], 0.5)
        -- transforms.translate.y=transforms.translate.y-0.2
        -- if e ~= 0 then
        --     material=GetComponent(this,"Material")
        --     LogMessage("hit")
        --     material.albedo.x=1
        --     material.albedo.y=0
        --     material.albedo.z=0
        -- else
        --     material=GetComponent(this,"Material")
        --     LogMessage("nohit")
        --     material.albedo.x=1
        --     material.albedo.y=1
        --     material.albedo.z=1
        -- end
    end

    function HitArea()
        local transforms = GetComponent(this, "Transform")
        
        if transforms.translate.z<1.0 and transforms.translate.z>0.8 then
            HitAreaFlg=true
        elseif transforms.translate.z>-1.0 and transforms.translate.z<-0.8 then
            HitAreaFlg=true
        elseif transforms.translate.x<1.0 and transforms.translate.x>0.8 then
            HitAreaFlg=true
        elseif transforms.translate.x>-1.0 and transforms.translate.x<-0.8 then
            HitAreaFlg=true
        elseif transforms.translate.x>-0.2 and transforms.translate.x<0.2 then
            if transforms.translate.z>-0.2 and transforms.translate.z<0.2 then
                HitAreaFlg=true
            else
                HitAreaFlg=false
            end
        else
            HitAreaFlg=false
        end

        if transforms.translate.y<0.4 then
            HitAreaFlg=false
        end

        if HitAreaFlg==true then
            material=GetComponent(this,"Material")
            material.albedo.x=0
            material.albedo.y=0
            material.albedo.z=1
        else
            material=GetComponent(this,"Material")
            material.albedo.x=1
            material.albedo.y=1
            material.albedo.z=1
        end
    end 


    function Start()
        local m=math.random(1,4)
        Type=m
        t2["RayFront2"].x=0
        t2["RayFront2"].y=1
        t2["RayFront2"].z=0

        local transforms = GetComponent(this, "Transform")
        if Type==1 or Type==2 then
            transforms.scale.x = 0.125
            transforms.scale.y = 0.125
            transforms.scale.z = 0.125
        elseif Type==3 then
            transforms.scale.x = 0.1
            transforms.scale.y = 0.1
            transforms.scale.z = 0.1
        else
            transforms.scale.x = 0.075
            transforms.scale.y = 0.075
            transforms.scale.z = 0.075
        end

    end

    function Update()
        if AdHoc.Global.RotationFlg==false then
            HitArea()
        else
            RotationHit()
        end
      
        local transforms = GetComponent(this, "Transform")
        local tempRigidbody = GetComponent(this, "RigidBody")
        if transforms.translate.z>1.0 then 
            tempRigidbody:SetTranslation(transforms.translate.x, 0.5, -1.0 )
            tempRigidbody:UpdateGeometry()
        end

        if AdHoc.Global.RotationFlg==true then
            if transforms.translate.y>=0.5 then 
                DestroyEntity(this)
            end
        end
    end

    function FixedUpdate()
        if Particleflg==true then
            destroyparticletime = destroyparticletime+1
            if destroyparticletime > 3 then
                 destroyparticletime=0
                 for i = 0, nextId - 1 do  
                    DestroyEntity(Particleentities[i])
                 end
                Particleflg=false
            end
        end
    end

    function TypeObject(_x)
        Type=_x
    end


    function Particle()
        Particleflg=true
        -- local audio = Audio:new()
        -- audio:Create("attack.wav", 0)
        -- audio:Play()
        local count = 50
        transform = GetComponent(this, "Transform")
        for i = 0, count do
            Particleentities[nextId] = CreateEntity()
            local m = GetComponent(Particleentities[nextId], "Material")
            m.albedo.x = 5
            m.albedo.y = 5
            m.albedo.z = 5

            local t = GetComponent(Particleentities[nextId], "Transform")
            t.scale.x = 0.01
            t.scale.y = 0.01
            t.scale.z = 0.01

            AddComponent(Particleentities[nextId], "RigidBody", "Box", "Dynamic");

            rigidbodies[nextId] = GetComponent(Particleentities[nextId], "RigidBody")

            rigidbodies[nextId]:SetRestitution(0.1)
            rigidbodies[nextId]:SetPosition(transform.translate.x + math.random(0, 0), 
            transform.translate.y + transform.scale.y, 
            transform.translate.z + math.random(0, 0))
            rigidbodies[nextId]:AddForce(math.random(-10, 10), 10, math.random(-10, 10))
            nextId = nextId + 1
        end
    end
]]

function SetTypeObject()
    local m=math.random(1,4)
    local s = GetComponent(entities[nextId], "Script")
    LogMessage(s:Call("TypeObject", m))
    LogMessage(s:Get("Type"))
   
end

function PopObject()
    entities[nextId] = CreateEntity()
    local transforms = GetComponent(entities[nextId], "Transform")
    -- if reel[nextId]==0 then
    --     transforms.scale.x = 0.1
    --     transforms.scale.y = 0.1
    --     transforms.scale.z = 0.1
    -- elseif reel[nextId]==1 then
    --     transforms.scale.x = 0.075
    --     transforms.scale.y = 0.075
    --     transforms.scale.z = 0.075
    -- else
    --     transforms.scale.x = 0.05
    --     transforms.scale.y = 0.05
    --     transforms.scale.z = 0.05
    -- end
    local Ramdom=math.random(0,2)
    if Ramdom==0 then
        transforms.scale.x = 0.125
        transforms.scale.y = 0.125
        transforms.scale.z = 0.125
    elseif Ramdom==1 then
        transforms.scale.x = 0.1
        transforms.scale.y = 0.1
        transforms.scale.z = 0.1
    else
        transforms.scale.x = 0.075
        transforms.scale.y = 0.075
        transforms.scale.z = 0.075
    end
    
    AddComponent(entities[nextId], "RigidBody", "Box", "Dynamic")
    AddComponent(entities[nextId],"Script",ObjectType)
    local tempRigidbody = GetComponent(entities[nextId], "RigidBody")
    tempRigidbody:SetTranslation(Position_x, 0.5, -1.0 )
    Position_x=Position_x+0.2
    
    tempRigidbody:SetVelocity(0,0,0.2)
    tempRigidbody:SetHasGravity(false)
    tempRigidbody:SetTrigger(true)
    tempRigidbody:UpdateGeometry()
    
    -- local s = GetComponent(entities[0], "Script")
    -- LogMessage(s:Get("value"))
    -- LogMessage(s:Call("GetValue", 2))
    nextId=nextId+1
   
end

function Start()
    
end

function Update()
    --SetTypeObject()
    -- if once==false then
    --     for i = 0, nextId-1 do
    --         local m=math.random(1,4)
    --         local s = GetComponent(entities[i], "Script")
    --         LogMessage(s:Call("TypeObject", m))
    --         LogMessage(s:Get("Type"))
            
    --         -- local m=fbxname[reel[i]]
    --         -- local Ramdom=math.random(1,5)
    --         -- local m=fbxname[Ramdom]
            
           
    --     end
    --     once=true
    -- end
    --位置のループ処理
    -- for i = 0, nextId-1 do
    --     if entities[i]~=0 then 
    --         local transforms = GetComponent(entities[i], "Transform")
    --         local tempRigidbody = GetComponent(entities[i], "RigidBody")
    --         if AdHoc.Global.RotationFlg==false then

    --         else
    --             if transforms.translate.y>0.4 then 
    --                 DestroyEntity(entities[i])
    --             end
    --         end
    --     end
    -- end
   
end

function FixedUpdate()
    time=time+1
   if time>60 and  Position_x<0.9 then
    if AdHoc.Global.RotationFlg==false then
    PopObject()
    time=0
    end
   end
end
