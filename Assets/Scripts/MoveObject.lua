require "AdHoc"

local this = GetThis()
local entities = {}
local entitiesHitFlg = {}
local entitiesObjectFlag = {}
local nextId = 0
local once =false
local time=0
local Position_x=-0.9


local fbxname={}
fbxname[1]="bed.obj"
fbxname[2]="dai.obj"
fbxname[3]="sofa_double.obj"
fbxname[4]="table.obj"

local reel = {}


local ObjectType = [[
    local this = GetThis()
    value = 10
    Type = 10
    local t2={}
    t2["RayFront"]=Vector3D:new()
    function GetValue(x)
        return value * x
    end

    function Start()
        local m=math.random(1,4)
        Type=m
        t2["RayFront"].x=0
        t2["RayFront"].y=-1
        t2["RayFront"].z=0
    end

    function Update()
        -- local transform = GetComponent(this, "Transform")
        -- local e = Raycast(transform.translate, t2["RayFront"], 0.05)
        -- if e ~= 0 then
        --     material=GetComponent(this,"Material")
        --     material.albedo.x=0
        --     material.albedo.y=0
        --     material.albedo.z=1
        -- else
        --     material=GetComponent(this,"Material")
        --     material.albedo.x=1
        --     material.albedo.y=1
        --     material.albedo.z=1
        -- end
    end

    function TypeObject(_x)
        Type=_x
    end

    function OnTriggerEnter(rhs)
        material=GetComponent(this,"Material")
        material.albedo.x=0
        material.albedo.y=0
        material.albedo.z=1
    end

    function OnTriggerExit(rhs)
        material=GetComponent(this,"Material")
        material.albedo.x=1
        material.albedo.y=1
        material.albedo.z=1
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
        transforms.scale.x = 0.1
        transforms.scale.y = 0.1
        transforms.scale.z = 0.1
    elseif Ramdom==1 then
        transforms.scale.x = 0.075
        transforms.scale.y = 0.075
        transforms.scale.z = 0.075
    else
        transforms.scale.x = 0.05
        transforms.scale.y = 0.05
        transforms.scale.z = 0.05
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
    for i = 0, nextId-1 do
        local transforms = GetComponent(entities[i], "Transform")
        local tempRigidbody = GetComponent(entities[i], "RigidBody")
        if transforms.translate.z>1.0 then 
            tempRigidbody:SetTranslation(transforms.translate.x, 0.5, -1.0 )
            tempRigidbody:UpdateGeometry()
        end
    end
   
end

function FixedUpdate()
    time=time+1
   if time>60 and  Position_x<0.9 then
    PopObject()
    
    time=0
   end
end
