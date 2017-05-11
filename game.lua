game = class()

function game:init(n)
    local nml = 100
    self.name,self.type = string.sub(n or "New Gate",1,nml),"project"
    self.main_editor,self.ui_editor = editor("Main"),ui_editor() -- Setup two main editor.
    self.scene = "edit"
    self.snap = true
    self.contains = {}
    self.files = {obj = self,open = fasu()}
    self.current_editor = self.main_editor --self.ui_editor -- Just for test.
    
    -- Add objs to game.
    game:add_obj(self.main_editor,self.contains)
    game:add_obj(self.ui_editor,self.contains)
    
    ui = ui()
end

function game:draw()
    game:update()
    game.current_editor.camera:draw() -- Animation for the camera.
    background(255)
    if self.scene == "edit" then
        if not self.current_editor then self.current_editor = self.main_editor end
        files:update()
        self.current_editor:update()
        self.current_editor:draw()
        files:draw()
    end
end

function game:update()
    if self.dis_nam then self.dis_nam:update() end
end

function game:add_obj(obj,path)
    if not self.editors then self.editors = {} end
    if obj.type == "editor" or obj.type == "ui_editor" then table.insert(self.editors,obj) end
    table.insert(path,{obj = obj,open = fasu()})
end

function game:display_name(n)
    local hh = HEIGHT/20
    local h = (self.dis_nam or {pos = HEIGHT+hh}).pos
    
    self.dis_nam = flat_animate(h,HEIGHT-hh,0.1,{name = n})
    tween.delay(1,function()
        self.dis_nam = flat_animate(self.dis_nam.pos,HEIGHT+hh,0.1,{name = n})
    end)
end

function game:touched(t)
    files:touched(t)
    if self.current_editor then
        self.current_editor:touched(t)
    end
end

function game:check_can_add_obj(obj,t)
    if obj.can_add_to then
        for k , add in pairs(obj.can_add_to) do
            if add == t then return true end
        end
        return false
    end
    return true
end

function cwg() 
    come_with_gates = {obj = folder("Come-with Gates",
    {{obj = not_gate()},{obj = lamp()},{obj = lever()},{obj = port()}}
    ),open = fasu()}
end

function gdc() --Gate defalt color.
    strokeWidth(2) COLOR1.a = 255
    fill(COLOR1)
    stroke(COLOR4)
end
