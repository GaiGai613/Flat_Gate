port = class()

function port:init(obj,t,v)
    self.type = string.upper(t or "input")
    self.name = "PORT//NOT ABLE TO USE NOW."
    self.value = v or 0 self.gate_id = 100
    self.width,self.height = 1,1
    if obj then
        local e = obj.editor
        local s = e.size
        self.obj = obj
        self.update_button_pos(self) -- Add button.
        self.wire = wire_line(vec2(-1,0),vec2(1,0),e,#e.wire.lines+1) -- Wire.
    end
end

function port:draw(s,x,y,info)
    local x,y = (x or 0)*s,(y or 0)*s 
    local wx = x if self.type == "OUTPUT" then wx = wx-s end

    if self.wire then -- Wire.
        translate(x,y) self.wire:draw(s) translate(-x,-y) 
    end    

    gdc()
    rect(x,y,s) COLOR2.a = 255 fill(COLOR2) fontSize(s)
    text(string.sub(self.type,1,1),x,y)
end

function port:update_button_pos(s)
    local s = self or s
    if not s.obj.editor then return end
    if not s.button then s.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = s.obj.editor
    local cpos = vec2(ed.camera.x,ed.camera.y)
    local pos = vec2(s.obj.x,s.obj.y)*ed.size-cpos
    
    s.button.x,s.button.y = pos:unpack()
    s.button.width,s.button.height = s.width*ed.size,s.height*ed.size
end

function port:touched(t)
    flat_ui:button_draw(self.button)
end