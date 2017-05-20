not_gate = class()

function not_gate:init(obj)
    self.width,self.height = 1,1
    self.name,self.type = "NOT GATE","gate"
    self.can_add_to = {"editor"}
    self.gate_id = 1

    if obj then
        local e = obj.editor
        local s = e.size
        local p = vec2(obj.x,obj.y)
        
        self.obj = obj
        self:update_button_pos() -- Add button.
        self.wire = wire_line(vec2(-1,0)+p,vec2(1,0)+p,e.wire,#e.wire.lines+1) -- Wire.
    end
end

function not_gate:draw(s,x,y,info)
    local x,y = (x or 0)*s,(y or 0)*s 

    -- We don't need draw wire here cause it will draw by editor.

    gdc()
    rect(x,y,self.width*s,self.height*s) COLOR2.a = 255 -- Background
    fill(COLOR2) fontSize(s) text("N",x,y) -- "N"

    if self.button then flat_ui:button_draw(self.button) end
    if self.button.pressed then
        if tap_count == 1 then game.selected = self end
    end 
end

function not_gate:update()
    if self.output and self.input then
        self.output.input.value = 1-self.input.output.value
    end
end

function not_gate:update_button_pos()
    if not self.obj.editor then return end
    if not self.button then self.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = self.obj.editor
    local cpos = vec2(ed.camera.x,ed.camera.y)
    local pos = vec2(self.obj.x,self.obj.y)*ed.size-cpos
    
    self.button.x,self.button.y = pos:unpack()
    self.button.width,self.button.height = self.width*ed.size,self.height*ed.size
end

function not_gate:touched(t)
    
end
