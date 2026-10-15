--!strict
-- 원형 선로(레일 + 침목)를 생성합니다.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local TrackBuilder = {}

local function makePart(name: string, size: Vector3, cframe: CFrame, color: Color3, material: Enum.Material): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	return part
end

-- 각도 theta에서의 선로 중심 CFrame (진행방향 = theta 증가 방향)
function TrackBuilder.cframeAt(theta: number, height: number): CFrame
	local r = Config.TrackRadius
	local pos = Config.TrackCenter + Vector3.new(math.cos(theta) * r, height, math.sin(theta) * r)
	local tangent = Vector3.new(-math.sin(theta), 0, math.cos(theta))
	return CFrame.lookAt(pos, pos + tangent)
end

function TrackBuilder.build(parent: Instance): Model
	local model = Instance.new("Model")
	model.Name = "Track"

	local n = Config.TrackSegments
	local step = 2 * math.pi / n
	local r = Config.TrackRadius
	local chord = 2 * r * math.sin(step / 2)
	local railColor = Color3.fromRGB(120, 120, 125)
	local sleeperColor = Color3.fromRGB(90, 70, 50)

	for i = 0, n - 1 do
		local theta = (i + 0.5) * step
		local center = TrackBuilder.cframeAt(theta, 0)

		-- 좌우 레일: 선로 중심에서 궤간/2 만큼 좌우로
		for _, side in { -1, 1 } do
			local offset = center * CFrame.new(side * Config.Gauge / 2, Config.RailHeight / 2 + 0.4, 0)
			local rail = makePart(
				"Rail",
				Vector3.new(0.4, Config.RailHeight, chord + 0.1),
				offset,
				railColor,
				Enum.Material.Metal
			)
			rail.Parent = model
		end

		-- 침목
		for s = 0, Config.SleeperSpacing - 1 do
			local t = i * step + (s + 0.5) * step / Config.SleeperSpacing
			local sleeper = makePart(
				"Sleeper",
				Vector3.new(Config.Gauge + 3, 0.4, 1),
				TrackBuilder.cframeAt(t, 0.2),
				sleeperColor,
				Enum.Material.Wood
			)
			sleeper.Parent = model
		end
	end

	model.Parent = parent
	return model
end

return TrackBuilder
