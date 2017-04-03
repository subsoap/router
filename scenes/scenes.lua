local M = {}

local prefix="main:/scenes"

local function create_url(name)
	return msg.url(prefix .. name)
end	

M.scene1 = create_url("#scene1")
M.scene2 = create_url("#scene2")

return M