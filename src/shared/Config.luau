--!strict
-- 철도 데모 설정값
-- 길이 단위 환산: Roblox 공식 문서 기준 1 stud = 0.28 m
-- (https://create.roblox.com/docs/physics/units)

local STUD_PER_METER = 1 / 0.28

local Config = {
	-- 선로
	TrackCenter = Vector3.new(0, 0, 0),
	TrackRadius = 150, -- studs (약 42 m)
	TrackSegments = 96,
	-- 표준궤간 1,435 mm (국토교통부 「철도의 건설기준에 관한 규정」, UIC 표준)
	Gauge = 1.435 * STUD_PER_METER, -- 약 5.1 studs
	RailHeight = 0.6,
	SleeperSpacing = 2, -- 선로 1분할당 침목 개수

	-- 차량
	CarLength = 24,
	CarWidth = 10,
	CarHeight = 9,
	CarCount = 3,
	CarGap = 1.5,

	-- 운전 (studs/s, studs/s²)
	MaxSpeed = 60,
	Acceleration = 6,
	BrakeDeceleration = 10,
	CoastDeceleration = 0.8, -- 주행저항에 의한 자연 감속

	RemoteName = "TrainThrottle",
	TrainName = "DemoTrain",
}

return Config
