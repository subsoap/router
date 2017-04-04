local M = {}

local prefix="main:/scenes"

local function create_url(name)
	return msg.url(prefix .. name)
end	


M.menu = create_url("#menu")
M.settings = create_url("#settings")

M.default_scene_name = "menu"

return M