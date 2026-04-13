--!native
--!optimize 2
--!divine-intellect
-- https://discord.gg/wx4ThpAsmw

local function string_find(s, pattern)
	return string.find(s, pattern, nil, true)
end

local function ArrayToDict(t, hydridMode, valueOverride, typeStrict)
	local tmp = {}

	if hydridMode then
		for any1, any2 in t do
			if type(any1) == "number" then
				tmp[any2] = valueOverride or true
			elseif type(any2) == "table" then
				tmp[any1] = ArrayToDict(any2, hydridMode)
			else
				tmp[any1] = any2
			end
		end
	else
		for _, key in t do
			if not typeStrict or typeStrict and type(key) == typeStrict then
				tmp[key] = true
			end
		end
	end

	return tmp
end

local global_container
do
	local filename = "UniversalMethodFinder"

	local finder
	finder, global_container = loadstring(
		game:HttpGet("https://raw.githubusercontent.com/luau/SomeHub/main/" .. filename .. ".luau", true),
		filename
	)()

	finder({
		base64encode = 'local a={...}local b=a[1]local function c(a,b)return string.find(a,b,nil,true)end;return c(b,"encode")and(c(b,"base64")or c(string.lower(tostring(a[2])),"base64"))',
		gethiddenproperty = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"prop",nil,true) and string.sub(...,#...) ~= "s"',
		gethui = 'string.find(...,"get",nil,true) and string.find(...,"h",nil,true) and string.find(...,"ui",nil,true)',
		getnilinstances = 'string.find(...,"nil",nil,true) and string.find(...,"get",nil,true) and string.sub(...,#...) == "s"',
		getscriptbytecode = 'string.find(...,"get",nil,true) and string.find(...,"script",nil,true) and string.find(...,"bytecode",nil,true)',
		protectgui = 'string.find(...,"protect",nil,true) and string.find(...,"ui",nil,true) and not string.find(...,"un",nil,true)',
		setthreadidentity = 'string.find(...,"identity",nil,true) and string.find(...,"set",nil,true)',
	}, true, 10)
end

local identify_executor = identifyexecutor or getexecutorname or whatexecutor
local EXECUTOR_NAME = identify_executor and identify_executor() or ""

local gethiddenproperty = global_container.gethiddenproperty

local appendfile = appendfile
local isfile = isfile
local readfile = readfile
local writefile = writefile
local makefolder = makefolder
local isfolder = isfolder

-- Get executor workspace folder
local function GetWorkspaceFolder()
	-- Try common workspace folder names
	local workspaceFolders = { "workspace", "Workspace", "scripts", "Scripts" }
	for _, folder in workspaceFolders do
		if isfolder and isfolder(folder) then
			return folder .. "/"
		end
	end
	-- Return empty string if no workspace folder found (some executors use root)
	return ""
end

local WORKSPACE_FOLDER = GetWorkspaceFolder()

-- Ensure folder exists
local function EnsureFolder(path)
	if makefolder and not isfolder(path) then
		pcall(makefolder, path)
	end
end

local getscriptbytecode = global_container.getscriptbytecode
local base64encode = global_container.base64encode

local service = setmetatable({}, {
	__index = function(self, serviceName)
		local o, s = pcall(Instance.new, serviceName)
		local Service = o and s
			or game:GetService(serviceName)
			or settings():GetService(serviceName)
			or UserSettings():GetService(serviceName)

		if Service then
			self[serviceName] = Service
		end
		return Service
	end,
})

local SharedString_identifier = 1e15
local SharedStrings = setmetatable({}, {
	__index = function(self, str)
		local identifier = base64encode(tostring(SharedString_identifier))
		SharedString_identifier += 1
		self[str] = identifier
		return identifier
	end,
})

local inherited_properties = {}
local default_instances = {}
local referents, ref_size = {}, 0

local function GetRef(instance)
	local ref = referents[instance]
	if not ref then
		ref = ref_size
		referents[instance] = ref
		ref_size += 1
	end
	return ref
end

local function index(self, index_name)
	return self[index_name]
end

local version = version
if not version then
	version = function()
		return "UNKNOWN"
	end
end

local FULL_VERSION = version()
local CLIENT_VERSION = tonumber(string.match(FULL_VERSION, "%d+%.(%d+)")) or 9e9

local attr_Type_IDs = {
	string = 0x02,
	boolean = 0x03,
	int32 = 0x04,
	number = 0x06,
	UDim = 0x09,
	UDim2 = 0x0A,
	Ray = 0x0B,
	Faces = 0x0C,
	Axes = 0x0D,
	BrickColor = 0x0E,
	Color3 = 0x0F,
	Vector2 = 0x10,
	Vector3 = 0x11,
	Vector2int16 = 0x12,
	Vector3int16 = 0x13,
	CFrame = 0x14,
	EnumItem = 0x15,
	NumberSequence = 0x17,
	NumberSequenceKeypoint = 0x18,
	ColorSequence = 0x19,
	ColorSequenceKeypoint = 0x1A,
	NumberRange = 0x1B,
	Rect = 0x1C,
	PhysicalProperties = 0x1D,
	Region3 = 0x1F,
	Region3int16 = 0x20,
	Font = 0x21,
	SecurityCapabilities = 0x22,
	Path2DControlPoint = 0x23,
}

local CFrame_Rotation_IDs = {
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x02,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x03,
	["\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x05,
	["\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x06,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x07,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x09,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x0a,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x0c,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0d,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x0e,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\63\0\0\0\0\0\0\0\0"] = 0x10,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\128"] = 0x11,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x14,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128"] = 0x15,
	["\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x17,
	["\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128"] = 0x18,
	["\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63"] = 0x19,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0"] = 0x1b,
	["\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128\0\0\0\0\0\0\0\0\0\0\128\191"] = 0x1c,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0"] = 0x1e,
	["\0\0\0\0\0\0\128\63\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\191\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x1f,
	["\0\0\0\0\0\0\0\0\0\0\128\63\0\0\0\0\0\0\128\63\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x20,
	["\0\0\0\0\0\0\128\191\0\0\0\0\0\0\0\0\0\0\0\0\0\0\128\63\0\0\128\191\0\0\0\0\0\0\0\0"] = 0x22,
	["\0\0\0\0\0\0\0\0\0\0\128\191\0\0\0\0\0\0\128\191\0\0\0\128\0\0\128\191\0\0\0\0\0\0\0\128"] = 0x23,
}

local BASE_CAPABILITIES
pcall(function()
	BASE_CAPABILITIES = SecurityCapabilities.new()
end)

local CAPABILITY_BITS = {
	Plugin = 2 ^ 0,
	LocalUser = 2 ^ 1,
	WritePlayer = 2 ^ 2,
	RobloxScript = 2 ^ 3,
	RobloxEngine = 2 ^ 4,
	NotAccessible = 2 ^ 5,
	RunClientScript = 2 ^ 8,
	RunServerScript = 2 ^ 9,
	Unknown = 2 ^ 10,
	AccessOutsideWrite = 2 ^ 11,
	Unassigned = 2 ^ 15,
	LoadUnownedAsset = 2 ^ 16,
	LoadString = 2 ^ 17,
	ScriptGlobals = 2 ^ 18,
	CreateInstances = 2 ^ 19,
	Basic = 2 ^ 20,
	Audio = 2 ^ 21,
	DataStore = 2 ^ 22,
	Network = 2 ^ 23,
	Physics = 2 ^ 24,
	UI = 2 ^ 25,
	CSG = 2 ^ 26,
	Chat = 2 ^ 27,
	Animation = 2 ^ 28,
	AvatarAppearance = 2 ^ 29,
	Input = 2 ^ 30,
	Environment = 2 ^ 31,
	RemoteEvent = 2 ^ 32,
	LegacySound = 2 ^ 33,
	Players = 2 ^ 34,
	CapabilityControl = 2 ^ 35,
	AssetRead = 2 ^ 36,
	AssetManagement = 2 ^ 37,
	DynamicGeneration = 2 ^ 38,
	PlatformAvatarEditing = 2 ^ 39,
	AssetCreateUpdate = 2 ^ 40,
	Capture = 2 ^ 41,
	SensitiveInput = 2 ^ 42,
	Monetization = 2 ^ 43,
	LoadOwnedAsset = 2 ^ 44,
	Social = 2 ^ 45,
	ServerCommunication = 2 ^ 46,
	Logging = 2 ^ 47,
	PromptExternalPurchase = 2 ^ 48,
	Groups = 2 ^ 49,
	Teleport = 2 ^ 50,
	Consequences = 2 ^ 51,
	Material = 2 ^ 52,
	AvatarBehavior = 2 ^ 53,
	RemoteCommand = 2 ^ 59,
	InternalTest = 2 ^ 60,
	PluginOrOpenCloud = 2 ^ 61,
	Assistant = 2 ^ 62,
}

local function __COUNT_CAPABILITY_BITS(raw)
	local result = 0
	for _, flag in string.split(tostring(raw), " | ") do
		local bit = CAPABILITY_BITS[flag]
		if bit then
			result += bit
		end
	end
	return result
end

local function __COUNT_BITS(...)
	local Value = 0
	for i, bit in { ... } do
		if bit then
			Value += 2 ^ (i - 1)
		end
	end
	return Value
end

local Binary_Descriptors
Binary_Descriptors = {
	__PACK_MULTIPLE = function(descriptor, value1, value2, value3)
		local buf1, size1 = descriptor(value1)
		local buf2, size2 = descriptor(value2)
		local len = size1 + size2
		local buf3, size3
		if value3 ~= nil then
			buf3, size3 = descriptor(value3)
			len += size3
		end
		local b = buffer.create(len)
		buffer.copy(b, 0, buf1)
		buffer.copy(b, size1, buf2)
		if value3 ~= nil then
			buffer.copy(b, size1 + size2, buf3)
		end
		return b, len
	end,
	__construct_Sequence = function(keypoint_handler, keypointSize)
		return function(raw)
			local Keypoints = raw.Keypoints
			local Keypoints_n = #Keypoints
			local len = 4 + keypointSize * Keypoints_n
			local b = buffer.create(len)
			buffer.writeu32(b, 0, Keypoints_n)
			local offset = 4
			for _, keypoint in Keypoints do
				keypoint_handler(keypoint, b, offset)
				offset += keypointSize
			end
			return b, len
		end
	end,
	__writei64 = function(b, offset, raw)
		local low = bit32.band(raw, 0xFFFFFFFF)
		local high = (raw - low) / 0x100000000
		buffer.writei32(b, offset, low)
		buffer.writei32(b, offset + 4, high)
	end,
	__PACK_F32 = nil,
	__PACK_I16 = nil,
	__construct__PACKER = function(float)
		local writeFunc = float and buffer.writef32 or buffer.writei16
		local elementSize = float and 4 or 2
		return function(X, Y, Z)
			local len = Z and (elementSize * 3) or (elementSize * 2)
			local b = buffer.create(len)
			writeFunc(b, 0, X)
			writeFunc(b, elementSize, Y)
			if Z then
				writeFunc(b, elementSize * 2, Z)
			end
			return b, len
		end
	end,
	["string"] = function(raw)
		local raw_len = #raw
		local len = 4 + raw_len
		local b = buffer.create(len)
		buffer.writeu32(b, 0, raw_len)
		buffer.writestring(b, 4, raw)
		return b, len
	end,
	["boolean"] = function(raw)
		local b = buffer.create(1)
		buffer.writeu8(b, 0, raw and 1 or 0)
		return b, 1
	end,
	["number"] = function(raw)
		local b = buffer.create(8)
		buffer.writef64(b, 0, raw)
		return b, 8
	end,
	["UDim"] = function(raw)
		local b = buffer.create(8)
		buffer.writef32(b, 0, raw.Scale)
		buffer.writei32(b, 4, raw.Offset)
		return b, 8
	end,
	["UDim2"] = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["UDim"], raw.X, raw.Y)
	end,
	["Ray"] = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector3"], raw.Origin, raw.Direction)
	end,
	["Faces"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, __COUNT_BITS(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front))
		return b, 4
	end,
	["Axes"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, __COUNT_BITS(raw.X, raw.Y, raw.Z))
		return b, 4
	end,
	["BrickColor"] = function(raw)
		local b = buffer.create(4)
		buffer.writeu32(b, 0, raw.Number)
		return b, 4
	end,
	["Color3"] = function(raw)
		return Binary_Descriptors.__PACK_F32(raw.R, raw.G, raw.B)
	end,
	["Vector2"] = function(raw)
		return Binary_Descriptors.__PACK_F32(raw.X, raw.Y)
	end,
	["Vector3"] = function(raw)
		return Binary_Descriptors.__PACK_F32(raw.X, raw.Y, raw.Z)
	end,
	["Vector2int16"] = function(raw)
		return Binary_Descriptors.__PACK_I16(raw.X, raw.Y)
	end,
	["Vector3int16"] = function(raw)
		return Binary_Descriptors.__PACK_I16(raw.X, raw.Y, raw.Z)
	end,
	["CFrame"] = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		local rotation_ID
		do
			local b = buffer.create(36)
			buffer.writef32(b, 0, R00)
			buffer.writef32(b, 4, R01)
			buffer.writef32(b, 8, R02)
			buffer.writef32(b, 12, R10)
			buffer.writef32(b, 16, R11)
			buffer.writef32(b, 20, R12)
			buffer.writef32(b, 24, R20)
			buffer.writef32(b, 28, R21)
			buffer.writef32(b, 32, R22)
			rotation_ID = CFrame_Rotation_IDs[buffer.tostring(b)]
		end
		local len = rotation_ID and 13 or 49
		local b = buffer.create(len)
		local __PACK_F32 = Binary_Descriptors.__PACK_F32
		local position = __PACK_F32(X, Y, Z)
		buffer.copy(b, 0, position)
		if rotation_ID then
			buffer.writeu8(b, 12, rotation_ID)
		else
			buffer.writeu8(b, 12, 0x0)
			local xBasis = __PACK_F32(R00, R01, R02)
			buffer.copy(b, 13, xBasis)
			local yBasis = __PACK_F32(R10, R11, R12)
			buffer.copy(b, 13 + 12, yBasis)
			local zBasis = __PACK_F32(R20, R21, R22)
			buffer.copy(b, 13 + 24, zBasis)
		end
		return b, len
	end,
	["EnumItem"] = function(raw)
		local b_Name, Name_size = Binary_Descriptors["string"](tostring(raw.EnumType))
		local len = Name_size + 4
		local b = buffer.create(len)
		buffer.copy(b, 0, b_Name)
		buffer.writeu32(b, Name_size, raw.Value)
		return b, len
	end,
	["NumberSequence"] = nil,
	["NumberSequenceKeypoint"] = function(keypoint, b, offset)
		if not b then
			return Binary_Descriptors.__PACK_F32(keypoint.Envelope, keypoint.Time, keypoint.Value)
		end
		buffer.writef32(b, offset, keypoint.Envelope)
		offset += 4
		buffer.writef32(b, offset, keypoint.Time)
		offset += 4
		buffer.writef32(b, offset, keypoint.Value)
	end,
	["ColorSequence"] = nil,
	["ColorSequenceKeypoint"] = function(keypoint, b, offset)
		local Value = Binary_Descriptors["Color3"](keypoint.Value)
		if not b then
			b = buffer.create(20)
			offset = 0
		end
		buffer.writef32(b, offset, 0)
		offset += 4
		buffer.writef32(b, offset, keypoint.Time)
		offset += 4
		buffer.copy(b, offset, Value)
		return b, 20
	end,
	["NumberRange"] = function(raw)
		return Binary_Descriptors.__PACK_F32(raw.Min, raw.Max)
	end,
	["Rect"] = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector2"], raw.Min, raw.Max)
	end,
	["PhysicalProperties"] = function(raw)
		local len = 1
		if raw then
			len += 24
		end
		local b = buffer.create(len)
		buffer.writeu8(b, 0, raw and 3 or 0)
		if raw then
			buffer.writef32(b, 1, raw.Density)
			buffer.writef32(b, 5, raw.Friction)
			buffer.writef32(b, 9, raw.Elasticity)
			buffer.writef32(b, 13, raw.FrictionWeight)
			buffer.writef32(b, 17, raw.ElasticityWeight)
			buffer.writef32(b, 21, raw.AcousticAbsorption)
		end
		return b, len
	end,
	["Region3"] = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5
		return Binary_Descriptors.__PACK_MULTIPLE(
			Binary_Descriptors["Vector3"],
			Translation - HalfSize,
			Translation + HalfSize
		)
	end,
	["Region3int16"] = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(Binary_Descriptors["Vector3int16"], raw.Min, raw.Max)
	end,
	["Font"] = function(raw)
		local string__descriptor = Binary_Descriptors["string"]
		local b_Family, Family_size = string__descriptor(raw.Family)
		local b_CachedFaceId, CachedFaceId_size = string__descriptor("")
		local len = 3 + Family_size + CachedFaceId_size
		local b = buffer.create(len)
		local ok_w, weight = pcall(index, raw, "Weight")
		local ok_s, style = pcall(index, raw, "Style")
		buffer.writeu16(b, 0, ok_w and weight.Value or 0)
		buffer.writeu8(b, 2, ok_s and style.Value or 0)
		buffer.copy(b, 3, b_Family)
		buffer.copy(b, 3 + Family_size, b_CachedFaceId)
		return b, len
	end,
	["SecurityCapabilities"] = function(raw)
		local b = buffer.create(8)
		if raw == BASE_CAPABILITIES then
			return b, 8
		end
		Binary_Descriptors.__writei64(b, 0, __COUNT_CAPABILITY_BITS(raw))
		return b, 8
	end,
	["Path2DControlPoint"] = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(
			Binary_Descriptors["UDim2"],
			raw.Position,
			raw.LeftTangent,
			raw.RightTangent
		)
	end,
}

do
	Binary_Descriptors["NumberSequence"] =
		Binary_Descriptors.__construct_Sequence(Binary_Descriptors["NumberSequenceKeypoint"], 12)
	Binary_Descriptors["ColorSequence"] =
		Binary_Descriptors.__construct_Sequence(Binary_Descriptors["ColorSequenceKeypoint"], 20)
end

do
	Binary_Descriptors.__PACK_F32 = Binary_Descriptors.__construct__PACKER(true)
	Binary_Descriptors.__PACK_I16 = Binary_Descriptors.__construct__PACKER()
end

local ESCAPES_PATTERN = "[&<>\"'\0\1-\9\11-\12\14-\31\127-\255]"
local ESCAPES = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	['"'] = "&#34;",
	["'"] = "&#39;",
	["\0"] = "",
}

for rangeStart, rangeEnd in string.gmatch(ESCAPES_PATTERN, "(.)%-(.)") do
	for charCode = string.byte(rangeStart), string.byte(rangeEnd) do
		ESCAPES[string.char(charCode)] = "&#" .. charCode .. ";"
	end
end

local XML_Descriptors
XML_Descriptors = {
	__CDATA = function(raw)
		return "<![CDATA[" .. raw .. "]]>"
	end,
	__NORMALIZE_NUMBER = function(raw)
		if raw ~= raw then
			return "NAN"
		elseif raw == math.huge then
			return "INF"
		elseif raw == -math.huge then
			return "-INF"
		end
		return raw
	end,
	__NORMALIZE_RANGE = function(raw)
		return raw ~= raw and "0" or raw
	end,
	__MINMAX = function(min, max, descriptor)
		return "<min>" .. descriptor(min) .. "</min><max>" .. descriptor(max) .. "</max>"
	end,
	__PROTECTEDSTRING = function(raw)
		return string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES) or XML_Descriptors.__CDATA(raw)
	end,
	__construct_Sequence = function(keypoint_handler)
		return function(raw)
			local sequence = ""
			for _, keypoint in raw.Keypoints do
				sequence ..= keypoint_handler(keypoint)
			end
			return sequence
		end
	end,
	__VECTOR = function(X, Y, Z)
		local Value = "<X>" .. X .. "</X><Y>" .. Y .. "</Y>"
		if Z then
			Value ..= "<Z>" .. Z .. "</Z>"
		end
		return Value
	end,
	Axes = function(raw)
		return "<axes>" .. __COUNT_BITS(raw.X, raw.Y, raw.Z) .. "</axes>"
	end,
	BinaryString = function(raw)
		return raw == "" and "" or base64encode(raw)
	end,
	BrickColor = function(raw)
		return raw.Number
	end,
	CFrame = function(raw)
		local X, Y, Z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = raw:GetComponents()
		return XML_Descriptors.__VECTOR(X, Y, Z)
			.. "<R00>" .. R00 .. "</R00><R01>" .. R01 .. "</R01><R02>" .. R02 .. "</R02><R10>" .. R10 .. "</R10><R11>" .. R11 .. "</R11><R12>" .. R12 .. "</R12><R20>" .. R20 .. "</R20><R21>" .. R21 .. "</R21><R22>" .. R22 .. "</R22>",
			"CoordinateFrame"
	end,
	Color3 = function(raw)
		return "<R>" .. raw.R .. "</R><G>" .. raw.G .. "</G><B>" .. raw.B .. "</B>"
	end,
	Color3uint8 = function(raw)
		return 0xFF000000
			+ (math.floor(raw.R * 255) * 0x10000)
			+ (math.floor(raw.G * 255) * 0x100)
			+ math.floor(raw.B * 255)
	end,
	ColorSequence = nil,
	ColorSequenceKeypoint = function(keypoint)
		local __NORMALIZE_RANGE = XML_Descriptors.__NORMALIZE_RANGE
		local color3 = keypoint.Value
		return __NORMALIZE_RANGE(keypoint.Time)
			.. " "
			.. __NORMALIZE_RANGE(color3.R)
			.. " "
			.. __NORMALIZE_RANGE(color3.G)
			.. " "
			.. __NORMALIZE_RANGE(color3.B)
			.. " 0 "
	end,
	Content = function(raw)
		local SourceType = raw.SourceType
		return SourceType == Enum.ContentSourceType.None and "<null></null>"
			or SourceType == Enum.ContentSourceType.Uri and "<uri>" .. XML_Descriptors.string(raw.Uri) .. "</uri>"
			or SourceType == Enum.ContentSourceType.Object and "<Ref>" .. GetRef(raw.Object) .. "</Ref>"
			or SourceType == Enum.ContentSourceType.Opaque and "<Ref>" .. GetRef(raw.Opaque) .. "</Ref>"
	end,
	ContentId = function(raw)
		return raw == "" and "<null></null>" or "<url>" .. XML_Descriptors.string(raw) .. "</url>", "Content"
	end,
	CoordinateFrame = function(raw)
		return "<CFrame>" .. XML_Descriptors.CFrame(raw) .. "</CFrame>"
	end,
	EnumItem = function(raw)
		return raw.Value, "token"
	end,
	Faces = function(raw)
		return "<faces>" .. __COUNT_BITS(raw.Right, raw.Top, raw.Back, raw.Left, raw.Bottom, raw.Front) .. "</faces>"
	end,
	Font = function(raw)
		local ok_w, weight = pcall(index, raw, "Weight")
		local ok_s, style = pcall(index, raw, "Style")
		return "<Family>"
			.. XML_Descriptors.ContentId(raw.Family)
			.. "</Family><Weight>"
			.. (ok_w and XML_Descriptors.EnumItem(weight) or "")
			.. "</Weight><Style>"
			.. (ok_s and style.Name or "")
			.. "</Style>"
	end,
	NumberRange = function(raw)
		local __NORMALIZE_RANGE = XML_Descriptors.__NORMALIZE_RANGE
		return __NORMALIZE_RANGE(raw.Min) .. " " .. __NORMALIZE_RANGE(raw.Max)
	end,
	NumberSequence = nil,
	NumberSequenceKeypoint = function(keypoint)
		local __NORMALIZE_RANGE = XML_Descriptors.__NORMALIZE_RANGE
		return __NORMALIZE_RANGE(keypoint.Time)
			.. " "
			.. __NORMALIZE_RANGE(keypoint.Value)
			.. " "
			.. __NORMALIZE_RANGE(keypoint.Envelope)
			.. " "
	end,
	PhysicalProperties = function(raw)
		local CustomPhysics = "<CustomPhysics>" .. XML_Descriptors.bool(raw and true or false) .. "</CustomPhysics>"
		return raw
				and CustomPhysics .. "<Density>" .. raw.Density .. "</Density><Friction>" .. raw.Friction .. "</Friction><Elasticity>" .. raw.Elasticity .. "</Elasticity><FrictionWeight>" .. raw.FrictionWeight .. "</FrictionWeight><ElasticityWeight>" .. raw.ElasticityWeight .. "</ElasticityWeight><AcousticAbsorption>" .. raw.AcousticAbsorption .. "</AcousticAbsorption>"
			or CustomPhysics
	end,
	Ray = function(raw)
		local vector3 = XML_Descriptors.Vector3
		return "<origin>" .. vector3(raw.Origin) .. "</origin><direction>" .. vector3(raw.Direction) .. "</direction>"
	end,
	Rect = function(raw)
		return XML_Descriptors.__MINMAX(raw.Min, raw.Max, XML_Descriptors.Vector2), "Rect2D"
	end,
	Region3 = function(raw)
		local Translation = raw.CFrame.Position
		local HalfSize = raw.Size * 0.5
		return XML_Descriptors.__MINMAX(
			Translation - HalfSize,
			Translation + HalfSize,
			XML_Descriptors.Vector3
		)
	end,
	Region3int16 = function(raw)
		return XML_Descriptors.__MINMAX(raw.Min, raw.Max, XML_Descriptors.Vector3int16)
	end,
	SharedString = function(raw)
		return SharedStrings[XML_Descriptors.BinaryString(raw)]
	end,
	SecurityCapabilities = function(raw)
		if raw == BASE_CAPABILITIES then
			return 0
		end
		return __COUNT_CAPABILITY_BITS(raw)
	end,
	Path2DControlPoint = function(raw)
		return Binary_Descriptors.__PACK_MULTIPLE(
			Binary_Descriptors["UDim2"],
			raw.Position,
			raw.LeftTangent,
			raw.RightTangent
		)
	end,
	UDim = function(raw)
		return "<S>" .. raw.Scale .. "</S><O>" .. raw.Offset .. "</O>"
	end,
	UDim2 = function(raw)
		local X, Y = raw.X, raw.Y
		return "<XS>" .. X.Scale .. "</XS><XO>" .. X.Offset .. "</XO><YS>" .. Y.Scale .. "</YS><YO>" .. Y.Offset .. "</YO>"
	end,
	UniqueId = function(raw)
		return string.gsub(raw, "-", "")
	end,
	Vector2 = function(raw)
		return XML_Descriptors.__VECTOR(raw.X, raw.Y)
	end,
	Vector3 = function(raw)
		return XML_Descriptors.__VECTOR(raw.X, raw.Y, raw.Z)
	end,
	bool = function(raw)
		return raw and "true" or "false"
	end,
	string = function(raw)
		return (raw == nil or raw == "") and ""
			or string_find(raw, "]]>") and string.gsub(raw, ESCAPES_PATTERN, ESCAPES)
			or XML_Descriptors.__CDATA(string.gsub(raw, "\0", ""))
	end,
}

do
	XML_Descriptors.NumberSequence = XML_Descriptors.__construct_Sequence(XML_Descriptors.NumberSequenceKeypoint)
	XML_Descriptors.ColorSequence = XML_Descriptors.__construct_Sequence(XML_Descriptors.ColorSequenceKeypoint)
end

for descriptorName, redirectName in
	{
		NetAssetRef = "SharedString",
		Vector2int16 = "Vector2",
		Vector3int16 = "Vector3",
		double = "__NORMALIZE_NUMBER",
		float = "__NORMALIZE_NUMBER",
		int = "__NORMALIZE_NUMBER",
		int64 = "__NORMALIZE_NUMBER",
	}
do
	XML_Descriptors[descriptorName] = XML_Descriptors[redirectName]
end

local ClassList
local function FetchAPI()
	local API_Dump = game:HttpGet(
		"https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json",
		true
	)

	local API = game:GetService("HttpService"):JSONDecode(API_Dump)

	local Classes = {}
	local NotScriptableFixes = {
		AnimationClip = {
			Looping = function(instance)
				return instance.Looping
			end,
		},
		BaseWrap = {
			CageMeshId = function(instance)
				return instance.CageMeshId
			end,
			CageOrigin = function(instance)
				return instance.CageOrigin
			end,
			CageOriginWorld = function(instance)
				return instance.CageOriginWorld
			end,
			ImportOrigin = function(instance)
				return instance.ImportOrigin
			end,
			ImportOriginWorld = function(instance)
				return instance.ImportOriginWorld
			end,
		},
		Humanoid = {
			AutoJumpEnabled = function(instance)
				return instance.AutoJumpEnabled
			end,
			JumpPower = function(instance)
				return instance.JumpPower
			end,
			WalkSpeed = function(instance)
				return instance.WalkSpeed
			end,
		},
		HumanoidDescription = {
			BackAccessory = function(instance)
				return instance.BackAccessory
			end,
			ClimbAnimation = function(instance)
				return instance.ClimbAnimation
			end,
			DepthScale = function(instance)
				return instance.DepthScale
			end,
			Face = function(instance)
				return instance.Face
			end,
			FallAnimation = function(instance)
				return instance.FallAnimation
			end,
			FrontAccessory = function(instance)
				return instance.FrontAccessory
			end,
			GraphicTShirt = function(instance)
				return instance.GraphicTShirt
			end,
			HairAccessory = function(instance)
				return instance.HairAccessory
			end,
			HatAccessory = function(instance)
				return instance.HatAccessory
			end,
			Head = function(instance)
				return instance.Head
			end,
			HeadScale = function(instance)
				return instance.HeadScale
			end,
			HeightScale = function(instance)
				return instance.HeightScale
			end,
			IdleAnimation = function(instance)
				return instance.IdleAnimation
			end,
			JumpAnimation = function(instance)
				return instance.JumpAnimation
			end,
			LeftArm = function(instance)
				return instance.LeftArm
			end,
			LeftLeg = function(instance)
				return instance.LeftLeg
			end,
			MoodAnimation = function(instance)
				return instance.MoodAnimation
			end,
			NeckAccessory = function(instance)
				return instance.NeckAccessory
			end,
			Pants = function(instance)
				return instance.Pants
			end,
			ProportionScale = function(instance)
				return instance.ProportionScale
			end,
			RightArm = function(instance)
				return instance.RightArm
			end,
			RightLeg = function(instance)
				return instance.RightLeg
			end,
			RunAnimation = function(instance)
				return instance.RunAnimation
			end,
			Shirt = function(instance)
				return instance.Shirt
			end,
			ShouldersAccessory = function(instance)
				return instance.ShouldersAccessory
			end,
			SwimAnimation = function(instance)
				return instance.SwimAnimation
			end,
			Torso = function(instance)
				return instance.Torso
			end,
			WaistAccessory = function(instance)
				return instance.WaistAccessory
			end,
			WalkAnimation = function(instance)
				return instance.WalkAnimation
			end,
			WidthScale = function(instance)
				return instance.WidthScale
			end,
		},
		Keyframe = {
			Time = function(instance)
				return instance.Time
			end,
		},
		KeyframeMarker = {
			Value = function(instance)
				return instance.Value
			end,
		},
		Model = {
			ModelMeshCFrame = function(instance)
				return instance.ModelMeshCFrame
			end,
			ModelMeshSize = function(instance)
				return instance.ModelMeshSize
			end,
		},
		Pose = {
			CFrame = function(instance)
				return instance.CFrame
			end,
			MaskWeight = function(instance)
				return instance.MaskWeight
			end,
			Weight = function(instance)
				return instance.Weight
			end,
		},
		Sound = {
			Channel = function(instance)
				return instance.Channel
			end,
		},
		Trail = {
			Color = function(instance)
				return instance.Color
			end,
			Lifetime = function(instance)
				return instance.Lifetime
			end,
			Transparency = function(instance)
				return instance.Transparency
			end,
		},
		VehicleSeat = {
			Steer = function(instance)
				return instance.Steer
			end,
			Throttle = function(instance)
				return instance.Throttle
			end,
		},
		Workspace = {
			CurrentCamera = function(instance)
				return instance.CurrentCamera
			end,
		},
	}

	for _, Class in API.Classes do
		local ClassName = Class.Name
		local Properties = {}
		local ClassWhitelist, ClassBlacklist

		for _, Member in Class.Members do
			if Member.MemberType == "Property" then
				local Serialization = Member.Serialization
				local PropertyName = Member.Name
				local Tags = ArrayToDict(Member.Tags)
				local ValueType = Member.ValueType

				if
					(Serialization.CanSave or ClassWhitelist and ClassWhitelist[PropertyName])
					and not (ClassBlacklist and ClassBlacklist[PropertyName])
					and not Tags.NotScriptable
					then
					local Category = ValueType.Category
					local Property = {
						Name = PropertyName,
						Default = Member.Default,
						ValueType = ValueType.Name,
					}

					if Category == "Enum" then
						Property.Category = "Enum"
					elseif Category == "Primitive" then
						local PrimitiveType = ValueType.Name
						if PrimitiveType == "int64" then
							Property.Category = "int64"
						elseif
								PrimitiveType == "float"
								or PrimitiveType == "double"
								or PrimitiveType == "int"
							then
							Property.Category = "number"
						else
							Property.Category = PrimitiveType
						end
					else
						Property.Category = "Other"
					end

					table.insert(Properties, Property)
				end
			end
		end

		if #Properties > 0 then
			Classes[ClassName] = Properties
		end
	end

	for ClassName, Properties in Classes do
		local inherited = {}
		local CurrentClass = API.Classes[ClassName]

		while CurrentClass do
			local SuperClass = CurrentClass.Superclass
			if SuperClass and SuperClass ~= "<<<ROOT>>>" then
				local ParentProperties = Classes[SuperClass]
				if ParentProperties then
					for _, Property in ParentProperties do
						table.insert(inherited, Property)
					end
				end
				CurrentClass = API.Classes[SuperClass]
			else
				break
			end
		end

		for _, Property in Properties do
			table.insert(inherited, Property)
		end

		Classes[ClassName] = inherited
	end

	return Classes
end

local function GetProperties(instance)
	local ClassName = instance.ClassName
	local Properties = inherited_properties[ClassName]

	if not Properties then
		if not ClassList then
			ClassList = FetchAPI()
		end
		Properties = ClassList[ClassName] or {}
		inherited_properties[ClassName] = Properties
	end

	return Properties
end

local function GetDefaultInstance(ClassName)
	local default = default_instances[ClassName]
	if default == nil then
		local success, result = pcall(Instance.new, ClassName)
		if success then
			default = result
			default_instances[ClassName] = default
		else
			default_instances[ClassName] = false
			return nil
		end
	end
	return default
end

local function IgnoreSpecialProperties(PropertyName, ValueType, instance)
	if PropertyName == "Source" then
		return true
	end

	local ClassName = instance.ClassName
	if ClassName == "MeshPart" then
		if PropertyName == "MeshId" or PropertyName == "TextureID" then
			return true
		end
	elseif ClassName == "UnionOperation" or ClassName == "NegateOperation" or ClassName == "IntersectionOperation" then
		if PropertyName == "AssetId" then
			return true
		end
	end

	return false
end

local function CanSaveProperty(instance, Property)
	local PropertyName = Property.Name
	local ValueType = Property.ValueType

	if IgnoreSpecialProperties(PropertyName, ValueType, instance) then
		return false
	end

	local success, value = pcall(index, instance, PropertyName)
	if not success then
		return false
	end

	local default = GetDefaultInstance(instance.ClassName)
	if default then
		local success_default, default_value = pcall(index, default, PropertyName)
		if success_default and value == default_value then
			return false
		end
	end

	return true
end

local function GetPropertyValue(instance, Property)
	local PropertyName = Property.Name
	local success, value = pcall(index, instance, PropertyName)

	if not success then
		local NotScriptableFix = NotScriptableFixes[instance.ClassName]
		if NotScriptableFix and NotScriptableFix[PropertyName] then
			success, value = pcall(NotScriptableFix[PropertyName], instance)
		end
	end

	return success and value or nil
end

local function SerializeValue(value, ValueType, Category)
	if Category == "Enum" then
		return tostring(value), "token"
	elseif ValueType == "CFrame" then
		return XML_Descriptors.CFrame(value)
	elseif ValueType == "Vector3" then
		return XML_Descriptors.Vector3(value)
	elseif ValueType == "Vector2" then
		return XML_Descriptors.Vector2(value)
	elseif ValueType == "Color3" then
		return XML_Descriptors.Color3(value)
	elseif ValueType == "UDim2" then
		return XML_Descriptors.UDim2(value)
	elseif ValueType == "UDim" then
		return XML_Descriptors.UDim(value)
	elseif ValueType == "Rect" then
		return XML_Descriptors.Rect(value)
	elseif ValueType == "NumberRange" then
		return XML_Descriptors.NumberRange(value)
	elseif ValueType == "NumberSequence" then
		return XML_Descriptors.NumberSequence(value)
	elseif ValueType == "ColorSequence" then
		return XML_Descriptors.ColorSequence(value)
	elseif ValueType == "PhysicalProperties" then
		return XML_Descriptors.PhysicalProperties(value)
	elseif ValueType == "Font" then
		return XML_Descriptors.Font(value)
	elseif ValueType == "Faces" then
		return XML_Descriptors.Faces(value)
	elseif ValueType == "Axes" then
		return XML_Descriptors.Axes(value)
	elseif ValueType == "Ray" then
		return XML_Descriptors.Ray(value)
	elseif ValueType == "BrickColor" then
		return XML_Descriptors.BrickColor(value)
	elseif ValueType == "Content" or ValueType == "ContentId" then
		return XML_Descriptors.ContentId(value)
	elseif ValueType == "BinaryString" then
		return XML_Descriptors.BinaryString(value)
	elseif ValueType == "SharedString" then
		return XML_Descriptors.SharedString(value)
	elseif ValueType == "UniqueId" then
		return XML_Descriptors.UniqueId(value)
	elseif ValueType == "SecurityCapabilities" then
		return XML_Descriptors.SecurityCapabilities(value)
	elseif ValueType == "bool" then
		return XML_Descriptors.bool(value)
	elseif ValueType == "string" then
		return XML_Descriptors.string(value)
	elseif ValueType == "double" or ValueType == "float" or ValueType == "int" or ValueType == "int64" then
		return XML_Descriptors.__NORMALIZE_NUMBER(value)
	else
		return tostring(value)
	end
end

local function SaveInstance(instance, options)
	options = options or {}
	local FileName = options.FileName or instance.Name .. ".rbxmx"
	
	-- Ensure filename has proper extension
	if not string.find(FileName, "%.rbxmx$") and not string.find(FileName, "%.rbxlx$") and not string.find(FileName, "%.rbxl$") then
		FileName = FileName .. ".rbxmx"
	end
	local SaveScripts = options.SaveScripts ~= false
	local DecompileScripts = options.DecompileScripts ~= false
	local DecompileTimeout = options.DecompileTimeout or 10
	local SaveNonCreatable = options.SaveNonCreatable ~= false
	local IgnoreArchivable = options.IgnoreArchivable
	local IgnoreSpecial = options.IgnoreSpecial
	local SafeMode = options.SafeMode

	if SafeMode then
		local Players = service.Players
		local LocalPlayer = Players.LocalPlayer
		if LocalPlayer then
			LocalPlayer:Kick("Saving instance...")
		end
	end

	local DecompiledScripts = {}
	local DecompileQueue = {}

	if SaveScripts and DecompileScripts and getscriptbytecode then
		local function QueueDecompile(obj)
			if obj:IsA("LuaSourceContainer") then
				table.insert(DecompileQueue, obj)
			end
		end

		local function DecompileAll()
			for _, script_obj in DecompileQueue do
				local success, bytecode = pcall(getscriptbytecode, script_obj)
				if success and bytecode then
					local hash = tostring(#bytecode)
					if not DecompiledScripts[hash] then
						local decompiled = decompile(script_obj, DecompileTimeout)
						if decompiled and decompiled ~= "" then
							DecompiledScripts[hash] = decompiled
						end
					end
				end
			end
		end

		local function CollectScripts(obj)
			QueueDecompile(obj)
			for _, child in obj:GetDescendants() do
				QueueDecompile(child)
			end
		end

		CollectScripts(instance)
		DecompileAll()
	end

	local xml = { '<?xml version="1.0" encoding="UTF-8"?>', '<roblox version="4">' }

	local function ProcessInstance(obj, isRoot)
		if not IgnoreArchivable and not obj.Archivable then
			return
		end

		local ClassName = obj.ClassName
		local Ref = GetRef(obj)

		table.insert(xml, string.format('<Item class="%s" referent="RBX%s">', ClassName, Ref))
		table.insert(xml, "<Properties>")

		local Properties = GetProperties(obj)
		for _, Property in Properties do
			if CanSaveProperty(obj, Property) then
				local value = GetPropertyValue(obj, Property)
				if value ~= nil then
					local ValueType = Property.ValueType
					local Category = Property.Category
					local serialized, typeOverride = SerializeValue(value, ValueType, Category)

					if serialized ~= nil then
						local tag = typeOverride or ValueType
						table.insert(
							xml,
							string.format("<%s name=\"%s\">%s</%s>", tag, Property.Name, serialized, tag)
						)
					end
				end
			end
		end

		if SaveScripts and obj:IsA("LuaSourceContainer") then
			local Source = ""
			if DecompileScripts and getscriptbytecode then
				local success, bytecode = pcall(getscriptbytecode, obj)
				if success and bytecode then
					local hash = tostring(#bytecode)
					Source = DecompiledScripts[hash] or ""
				end
			end
			if Source == "" then
				Source = "-- Script source could not be decompiled"
			end
			table.insert(xml, string.format('<ProtectedString name="Source">%s</ProtectedString>', XML_Descriptors.__PROTECTEDSTRING(Source)))
		end

		table.insert(xml, "</Properties>")

		for _, child in obj:GetChildren() do
			ProcessInstance(child)
		end

		table.insert(xml, "</Item>")
	end

	ProcessInstance(instance, true)
	table.insert(xml, "</roblox>")

	-- Ensure proper file path
	local fullPath = WORKSPACE_FOLDER .. FileName
	
	-- Ensure the folder exists (for subfolders in filename)
	local folderPath = string.match(fullPath, "^(.*)/[^/]+$")
	if folderPath and folderPath ~= "" then
		EnsureFolder(folderPath)
	end
	
	local content = table.concat(xml, "\n")
	local success, err = pcall(writefile, fullPath, content)
	
	if not success then
		-- Try without workspace folder as fallback
		success, err = pcall(writefile, FileName, content)
		if success then
			fullPath = FileName
		else
			error("Failed to write file: " .. tostring(err))
		end
	end
	
	print("[UniversalSynSaveInstance] Saved to: " .. fullPath)
	return fullPath
end

local function synsaveinstance(options)
	options = options or {}
	local Objects = options.Objects
	local FileName = options.FileName or "place"
	local SaveFormat = options.SaveFormat or "rbxmx"

	if not Objects then
		Objects = { game }
	end

	if typeof(Objects) ~= "table" then
		Objects = { Objects }
	end
	
	print("[UniversalSynSaveInstance] Starting save...")
	print("[UniversalSynSaveInstance] Workspace folder: " .. (WORKSPACE_FOLDER ~= "" and WORKSPACE_FOLDER or "(root)"))

	for _, obj in Objects do
		local name = obj.Name or "object"
		-- Clean up name for filename (remove special chars)
		name = string.gsub(name, "[^%w%s_-]", "")
		name = string.gsub(name, "%s+", "_")
		
		local filename = FileName .. "_" .. name .. "." .. SaveFormat
		print("[UniversalSynSaveInstance] Saving: " .. obj.ClassName .. " (" .. (obj.Name or "unnamed") .. ")")
		
		local success, result = pcall(function()
			return SaveInstance(obj, {
				FileName = filename,
				SaveScripts = options.SaveScripts,
				DecompileScripts = options.DecompileScripts,
				DecompileTimeout = options.DecompileTimeout,
				SaveNonCreatable = options.SaveNonCreatable,
				IgnoreArchivable = options.IgnoreArchivable,
				IgnoreSpecial = options.IgnoreSpecial,
				SafeMode = options.SafeMode,
			})
		end)
		
		if not success then
			warn("[UniversalSynSaveInstance] Error saving " .. name .. ": " .. tostring(result))
		else
			print("[UniversalSynSaveInstance] Successfully saved: " .. result)
		end
	end
	
	print("[UniversalSynSaveInstance] Save complete!")
end

getgenv().synsaveinstance = synsaveinstance
getgenv().saveinstance = synsaveinstance

return synsaveinstance
