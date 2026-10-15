--!strict
-- 열차 생성 및 운전 시뮬레이션 (서버 권한)
-- 플레이어는 RemoteEvent로 노치(-1 제동, 0 타행, 1 역행)만 보냅니다.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = require(ReplicatedStorage.Shared.Config)
local TrackBuilder = require(script.Parent.TrackBuilder)

local TrainService = {}

type Car = { model: Model, offset: number }

local cars: { Car } = {}
local theta = 0 -- 선두차 위치 (rad)
local speed = 0 -- studs/s
local notch = 0
local driver: Player? = nil

local function buildCar(index: number): Model
	local car = Instance.new("Model")
	car.Name = "Car" .. index

	local body = Instance.new("Part")
	body.Name = "Body"
	body.Anchored = true
	body.CanCollide = true
	body.Size = Vector3.new(Config.CarWidth, Config.CarHeight, Config.CarLength)
	body.Color = index == 1 and Color3.fromRGB(0, 90, 170) or Color3.fromRGB(230, 230, 235)
	body.Material = Enum.Material.SmoothPlastic
	body.Parent = car
	car.PrimaryPart = body

	local stripe = Instance.new("Part")
	stripe.Name = "Stripe"
	stripe.Anchored = true
	stripe.CanCollide = false
	stripe.Size = Vector3.new(Config.CarWidth + 0.1, 1, Config.CarLength + 0.1)
	stripe.Color = Color3.fromRGB(0, 150, 220)
	stripe.Material = Enum.Material.Neon
	stripe.CFrame = body.CFrame * CFrame.new(0, -1.5, 0)
	stripe.Parent = car

	if index == 1 then
		local seat = Instance.new("Seat")
		seat.Name = "DriverSeat"
		seat.Anchored = true
		seat.Size = Vector3.new(2, 1, 2)
		seat.CFrame = body.CFrame * CFrame.new(0, Config.CarHeight / 2 + 0.5, -Config.CarLength / 2 + 3)
		seat.Parent = car
	end

	return car
end

local function placeCars()
	local r = Config.TrackRadius
	local height = 0.8 + Config.RailHeight + Config.CarHeight / 2
	for _, car in cars do
		local t = theta - car.offset / r
		car.model:PivotTo(TrackBuilder.cframeAt(t, height))
	end
end

local function step(dt: number)
	if notch > 0 then
		speed += Config.Acceleration * dt
	elseif notch < 0 then
		speed -= Config.BrakeDeceleration * dt
	else
		speed -= Config.CoastDeceleration * dt
	end
	speed = math.clamp(speed, 0, Config.MaxSpeed)

	theta = (theta + speed / Config.TrackRadius * dt) % (2 * math.pi)
	placeCars()

	local train = workspace:FindFirstChild(Config.TrainName)
	if train then
		-- 클라이언트 표시용 (km/h 환산: 1 stud = 0.28 m)
		train:SetAttribute("SpeedKmh", math.floor(speed * 0.28 * 3.6 + 0.5))
		train:SetAttribute("Notch", notch)
	end
end

function TrainService.start()
	TrackBuilder.build(workspace)

	local train = Instance.new("Model")
	train.Name = Config.TrainName
	for i = 1, Config.CarCount do
		local model = buildCar(i)
		model.Parent = train
		table.insert(cars, { model = model, offset = (i - 1) * (Config.CarLength + Config.CarGap) })
	end
	train.Parent = workspace
	placeCars()

	local remote = Instance.new("RemoteEvent")
	remote.Name = Config.RemoteName
	remote.Parent = ReplicatedStorage

	-- 운전석에 앉은 플레이어만 운전 가능
	local seat = cars[1].model:FindFirstChild("DriverSeat") :: Seat
	seat:GetPropertyChangedSignal("Occupant"):Connect(function()
		local humanoid = seat.Occupant
		driver = if humanoid then Players:GetPlayerFromCharacter(humanoid.Parent) else nil
		if not driver then
			notch = 0
		end
	end)

	remote.OnServerEvent:Connect(function(player: Player, value: unknown)
		if player ~= driver or typeof(value) ~= "number" then
			return
		end
		notch = math.clamp(math.round(value), -1, 1)
	end)

	RunService.Heartbeat:Connect(step)
end

return TrainService
