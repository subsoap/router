# Router
This libary will help you to work with collection_proxy
# The main function
- change_scene - change current scene to new scene. Can be push or push modal.<br>
	* push - pushes the new scene to the stack and passes the input to it. The current scene will be unloaded to save memory<br>
	* push_modal - pushes the new scene to the stack and passes the input to it. The current scene is kept in memory but is disabled.<br>
- back - return to prev scene.If only one scene in stack, will be ignore. The current scene will be unload if it was loading, or will be disabled.<br>
- clear_stack - clear scene stack. Keep only top scene.<br>
## Table of Contents

- [Setup](#setup)
- [Work with router](#work-with-router)
- [Compare](#compare)

## Setup

1)Add the library zip URL as a [dependency](https://github.com/d954mas/router/archive/master.zip) to your Defold project: https://github.com/d954mas/router/archive/master.zip

2)Create a folder scenes in the root of project

3)Create a  lua module scenes/scenes.lua with the content
```lua
local M = {}
local prefix="main:/scenes"

local function create_url(name)
	return msg.url(prefix .. name)
end	

--Your scenes urls
M.menu = create_url("#menu")
M.settings = create_url("#settings")

--default scene
M.default_scene_name = "menu"

return M
```
4)create a scenes game object in main collection with yours collection proxy

5)The name of yours collections/collection_proxy must be the same as in scenes/scenes.lua.

## Work with router
```lua
msg.post("main:/router#script","change_scene",{scene="settings"})
msg.post("main:/router#script","back")
msg.post("main:/router#script","clear_stack")
```

## Compare
This libary was made when i looked at [defold router](https://github.com/Megus/defold-router). I try that library, but i have problem with it
and aslo a i don't like how it is implemented.So i create my own library.

My library pros:
- Use msg.post() instead of lua module.In defold router i must have a router object to change scene. In this library you can change scene throw messages
- logs in console.<br>
DEBUG:SCRIPT: scene:menu load<br>
DEBUG:SCRIPT: loading time:0.055<br>
DEBUG:SCRIPT: scene:menu was enable<br>
DEBUG:SCRIPT: no prev scene<br>
DEBUG:SCRIPT: start to load scene:settings<br>
DEBUG:SCRIPT: scene:settings load<br>
DEBUG:SCRIPT: loading time:0.06<br>
DEBUG:SCRIPT: scene:settings was enable<br>
DEBUG:SCRIPT: scene:menu was disabled<br>

My library cons:
- No input for scenes(will be added later)
- No popup(will be added later)
- No navigation stack.(not will be implemented)If you need it, you can implement it by yourself.
- No save state for scenes.(not will be implemented).If need scene must save state by itself.
There are few cases when you need to have multiple states for one scene(complex menu).For that cases your need to save states somewhere 
else and use input to understand what state you need.Or use defold router.


