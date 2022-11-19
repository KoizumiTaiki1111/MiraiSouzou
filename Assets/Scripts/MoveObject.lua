require "AdHoc"

local this = GetThis()
local entities = {}
local entitiesHitFlg = {}
local entitiesObjectFlag = {}
local nextId = 0
local once =false

local fbxname={}
fbxname[1]="bed.obj"
fbxname[2]="dai.obj"
fbxname[3]="sofa_double.obj"
fbxname[4]="table.obj"

local reel = {}


local ObjectType = [[
    value = 10
    Type = 10
    function GetValue(x)
        return value * x
    end

    function Start()
        
    end

    function TypeObject(_x)
        Type=_x
    end

    
]]

function Start()
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
    tempRigidbody:SetTranslation(0.0 , 0.5, -1.0 )
    
    tempRigidbody:SetVelocity(0,0,0.2)
    tempRigidbody:SetHasGravity(false)
    tempRigidbody:SetTrigger(true)
    tempRigidbody:UpdateGeometry()
    
    -- local s = GetComponent(entities[0], "Script")
    -- LogMessage(s:Get("value"))
    -- LogMessage(s:Call("GetValue", 2))
    nextId=nextId+1
   
end

function Update()
    if once==false then
        for i = 0, nextId-1 do
            local m=math.random(1,4)
            local s = GetComponent(entities[i], "Script")
            LogMessage(s:Call("TypeObject", m))
            LogMessage(s:Get("Type"))
            
            -- local m=fbxname[reel[i]]
            -- local Ramdom=math.random(1,5)
            -- local m=fbxname[Ramdom]
            
           
        end
        once=true
    end
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
