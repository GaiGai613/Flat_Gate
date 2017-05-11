port = class()

function port:init(obj,t,v)
    self.type = string.upper(t or "input")
    self.name = "PORT//NOT ABLE TO USE NOW."
    self.value = v or 0 self.gate_id = 100
    self.width,self.height = 1,1
    self.wire = wire() self.wire.lines = {{s = vec2(0,0),e = vec2(1,0)}}
    if obj then
        local s = obj.editor.size
        self.obj = obj
        self.button = flat_ui:add_button(obj.x*s,obj.y*s,s,s,color(0,10))
    end
end

function port:draw(s,x,y)
    local x,y = (x or 0)*s,(y or 0)*s 
    local wx = x if self.type == "OUTPUT" then wx = wx-s end
    translate(wx,y) self.wire:draw(s) translate(-wx,-y) gdc() -- Wire.
    rect(x,y,s) COLOR2.a = 255 fill(COLOR2) fontSize(s)
    text(string.sub(self.type,1,1),x,y)
end

function port:touched(t)
    flat_ui:button_draw(self.button)
end