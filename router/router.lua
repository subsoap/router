--[[
Singleton. All get same router
all scenes will release/ input focus
]]
local M = {}
M.__index = M

----------------------------------------------------------------------------------------------------
-- Private interface
----------------------------------------------------------------------------------------------------
local routing_tables = {}
local loaded_scenes = {}
local init_scenes = {}
local enabled_scenes = {}

local hashes={
	proxy_loaded=hash("proxy_loaded"),
	release_input_focus=hash("release_input_focus"),
	proxy_unloaded=hash("proxy_unloaded"),
	change_scene=hash("change_scene")
}

-- Returns scene controller URL string

-- Unload a scene
local function unload_scene(url)
    msg.post(url, "disable")
    msg.post(url, "final")
    msg.post(url, "unload")
end

local function disable_scene(url)
	msg.post(url, "disable")
end

local function unload_scene(url)
	msg.post(url, "final")
    msg.post(url, "unload")
end	

local function load_scene(url)
	msg.post(url, "load")
end

local function load_async(url)
	msg.post(url, "async_load")
end

local routing =require("utils.router.routing")

----------------------------------------------------------------------------------------------------
-- Public interface
----------------------------------------------------------------------------------------------------

-- if scene whant to save state.It should do it by herself.(for now or for always=))
-- Push the new scene to scene stack
-- The current scene will be unloaded
-- When the pushed scene is closed, the current scene will receive "scene_popped"

M.methods = {
    push = 1,
    push_modal = 2,
    popup = 3,
}


M.load_type = {
	blocking = 1,
	async = 2
}



--change scene by string.
--input is input that new scene need.
--wait while next screen will be load then change screen
--while changing scene new scenes will be ignored
function M:change_scene(scene,method,load_type)
	msg.post("/scenes#script",hashes.change_scene,{scene=scene,method=method,load_type=load_type})
end


function M:restore(unload_current)
	--unload_current = unload_current and true or false
	--tofo need impl
end

local function enable_scene(self,url)
		msg.post(url,"acquire_input_focus")
		msg.post(url,"init")
		msg.post(url,"enable")
		loaded_scenes[self.next_scene_data.scene]=true
		local prev_url=self.prev_scene_url
		if(self.next_scene_data.method==M.methods.push)then
			msg.post(prev_url, "disable")
		elseif(self.next_scene_data.method==M.methods.push_modal)then
			msg.post(prev_url, "disable")
			msg.post(prev_url, "unload")
			--loaded_scenes[scene]=nil
		elseif(self.next_scene_data.method==M.methods.popup)then
			msg.post(prev_url, "release_input_focus")
		end
		self.prev_scene_url=self.next_scene_data.url
		self.next_scene_data.scene=nil
	end
	
local function msg_change_scene(self,scene,method,load_type)
	assert(scene,"scene can't be nil")
	method = method and method or M.methods.push
	load_type = load_type or M.load_type.async
	local url=routing[scene]
	assert(url,"cant't find url for " .. scene)
	--start load next scene
	--after loading get message
	--and disable prev states if need
	print(url)
	print(self.prev_scene_url)
	if(url==self.prev_scene_url) then
		print("already load scene:"..scene)		
	elseif(self.next_scene_data.scene~=nil) then 
		print("Can't change scene.Scene is already changing")		
	else
		self.next_scene_data={scene=scene,method=method,url=url}
		if(load_type==M.load_type.async)then 
			print("load async ".. url)
			if(loaded_scenes[scene]) then
				enable_scene(self,url)
			else load_async(url) end
		elseif(load_type==M.load_type.blocking)then
			load(url)
		end
	end	
end	


function M:on_message(message_id, message, sender)
	if(message_id == hashes.change_scene) then
		msg_change_scene(self,message.scene,message.method,message.load_type)	
	end
	if (message_id == hashes.proxy_loaded and sender==msg.url(self.next_scene_data.url)) then
		enable_scene(self,sender)
	end
end


function M.new()
	local self = setmetatable({},M)
	self.stack={}
	self.next_scene_data={scene=nil,method=nil,url=nil}
	self.prev_scene_url=nil
	return self
end

return M.new()