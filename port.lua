port = class()

function port:init(obj,t,v)
    self.type = string.upper(t or "input")
    self.name = "PORT//NOT ABLE TO USE NOW."
    self.value = v or 0 self.gate_id = 100
    self.width,self.height = 1,1
    self.wire = wire() self.wire.lines = {{s = vec2(0,0),e = vec2(1,0)}}
    if obj then
        local e = obj.editor
        local s = e.size
        self.obj = obj
        self:update_button_pos() -- Add button.
        self.wire = wire_line(vec2(-1,0)+p,vec2(1,0)+p,e.wire,#e.wire.lines+1) -- Wire.
    end
end

function port:draw(s,x,y,info)
    local x,y = (x or 0)*s,(y or 0)*s 
    local wx = x if self.type == "OUTPUT" then wx = wx-s end

    -- We don't need wire here because it will draw by editor.

    gdc()
    rect(x,y,s) COLOR2.a = 255 fill(COLOR2) fontSize(s)
    text(string.sub(self.type,1,1),x,y)
end

function port:update_button_pos()
    if not self.obj.editor then return end
    if not self.button then self.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = self.obj.editor
    local cpos = vec2(ed.camera.x,ed.camera.y)
    local pos = vec2(self.obj.x,self.obj.y)*ed.size-cpos
    
    self.button.x,self.button.y = pos:unpack()
    self.button.width,self.button.height = self.width*ed.size,self.height*ed.size
end

function port:touched(t)
    flat_ui:button_draw(self.button)
end