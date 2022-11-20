require "AdHoc"

local this = GetThis()
local input = GetInput()
local camera = GetComponent(this,"Camera3D")
local nextScene = "End.scene" -- 移動先シーンの名前

local speedSlide = 40 -- 1秒間に視線を回す角度
local speedMove = 1 -- 1秒間に移動する距離
local check =0
local time = 0
local timechange = 60 -- ボタンを押してから遷移するまでの時間（単位：秒）
local count =true
local countTime=0
local shake=false
local shaketime=0
local counter=true
local once=false

function Move()
    if once==false then
        camera.eyePosition.x = 0
        camera.eyePosition.y = 0.5
        camera.eyePosition.z = -1
        camera.focusPosition.x =0
        camera.focusPosition.y =0.5
        camera.focusPosition.z =1
        once=true
    end
    local _d = 0 

    if input:GetKey(AdHoc.Key.q) == true then
        _d = _d + 1
    end
    if input:GetKey(AdHoc.Key.e) == true then
        _d = _d - 1
    end

    if _d == 0 then -- 何もしない
    else
        -- 移動角度を求める(ラジアン度にする)
        local _angleSlide = speedSlide * _d * math.pi / 180

        -- 現在の視点の角度を求める
        local _vecAngle = Vector2D:new()
        _vecAngle.x = camera.focusPosition.x - camera.eyePosition.x
        _vecAngle.y = camera.focusPosition.z - camera.eyePosition.z

        local _angleLookingAt = math.atan(_vecAngle.y,_vecAngle.x)

        local _angleWillingToLook = _angleLookingAt + _angleSlide * DeltaTime()

        -- focusPositionを移動させる
        camera.focusPosition.x = camera.eyePosition.x + math.cos(_angleWillingToLook)
        camera.focusPosition.z = camera.eyePosition.z + math.sin(_angleWillingToLook)
    end


    local _x = 0
    local _z = 0
    local _put = false

    -- キーの入力処理
    if input:GetKey(AdHoc.Key.d) == true then
        _put=true
        _x = _x+0.01
    end
    if input:GetKey(AdHoc.Key.a) == true then
        _put=true
        _x = _x-0.01
    end
    if input:GetKey(AdHoc.Key.w) == true then
        _put=true
        _z = _z+0.01
    end
    if input:GetKey(AdHoc.Key.s) == true then
        _put=true
        _z = _z-0.01
    end
   

    if _put == true then
        -- 移動角度求める
        local _angle = math.atan(_z,_x)

        -- 現在の視点の角度を求める
        local _vecAngle = Vector2D:new()
        _vecAngle.x = camera.focusPosition.x - camera.eyePosition.x
        _vecAngle.y = camera.focusPosition.z - camera.eyePosition.z

        local _angleLookingAt = math.atan(_vecAngle.y,_vecAngle.x)
       _angleLookingAt = _angleLookingAt - 90 * math.pi / 180-- 調整

        local _angleMove = _angle + _angleLookingAt -- 最終的な移動方向

        -- 移動処理
        camera.eyePosition.x = camera.eyePosition.x + speedMove * math.cos(_angleMove) * DeltaTime()
        camera.eyePosition.z = camera.eyePosition.z + speedMove * math.sin(_angleMove) * DeltaTime()

        -- 合わせて注目点も移動
        camera.focusPosition.x = camera.focusPosition.x + speedMove * math.cos(_angleMove) * DeltaTime()
        camera.focusPosition.z = camera.focusPosition.z + speedMove * math.sin(_angleMove) * DeltaTime()
    end
end

function Start()

end

function Update()
    if AdHoc.Global.FPSflg==true then
        Move()
        if input:GetKeyUp(AdHoc.Key.space) then 
            LoadScene(nextScene)
        end
    end
end
