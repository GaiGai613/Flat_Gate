not_gate = class()

function not_gate:init(obj)
    if obj then
        local s = obj.editor.size
        self.obj = obj
        self.button = flat_ui:add_button(obj.x*s,obj.y*s,s,s,color(0,10))
    end
    self.width,self.height = 1,1
    self.name,self.type = "NOT GATE","gate"
    self.can_add_to = {"editor"}
    self.gate_id = 1
    self.wire = wire()
    self.wire.lines = {{s = vec2(-1,0),e = vec2(1,0)}}
end

function not_gate:draw(s,x,y)
    local x,y = (x or 0)*s,(y or 0)*s 
    translate(x,y) self.wire:draw(s) translate(-x,-y) gdc() -- Wire
    rect(x,y,self.width*s,self.height*s) COLOR2.a = 255 -- Background
    fill(COLOR2) fontSize(s) text("N",x,y) -- "N"
end

function not_gate:update()
    if self.output and self.input then
        self.output.input.value = 1-self.input.output.value
    end
end

function not_gate:touched(t)
    flat_ui:button_draw(self.button)
end
