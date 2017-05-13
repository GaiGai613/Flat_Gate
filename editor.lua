editor = class()

function editor:init(n)
    self.size = math.round(WIDTH/32)
    self.name = n
    self.type = "editor"
    self.camera = _camera(self)
    self.files,self.contains = {},{}
    self.wire = wire(self)
    self.objs = {}
end

function editor:draw()
    ui:draw_editor(self)
    rectMode(CENTER)
    translate(-self.camera.x,-self.camera.y)
    self.wire:draw(self.size)
    for k , one_obj in pairs(self.objs) do
        local obj = one_obj.obj
        obj:draw(self.size,obj.obj.x,obj.obj.y)
    end
    resetMatrix()
end

function editor:draw_pre_view(obj,p)
    local s,c = self.size,self.camera
    local p = vec2(math.round((p.x+c.x)/s),math.round((p.y+c.y)/s))*s
    translate(-c.x+p.x,-c.y+p.y)
    obj:draw(s,0,0)
    resetMatrix()
end

function editor:add_obj(obj,p)
    local o = {obj = get_gate_from_id(obj.gate_id,{x = p.x,y = p.y,editor = self})}
    table.insert(self.objs,o)
end

function editor:update()
    
end

function editor:update_camera(pos)
    for k , one_obj in pairs(self.objs) do
        local obj = one_obj.obj
        if obj.update_camera then obj:update_camera(pos) end
    end
end

function editor:open()
    game.current_editor = self
end

function editor:touched(t)
    self.camera:touched(t)
    self.wire:touched(t)
    for k , one_obj in pairs(self.objs) do
        one_obj.obj:touched(t)
    end
end
