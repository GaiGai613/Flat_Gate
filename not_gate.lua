not_gate = class(gate_obj)

function not_gate:init(obj)
    self.width,self.height = 1,1
    self.name,self.type = "NOT GATE","gate"
    self.can_add_to = {"editor"}
    self.gate_id = 1

    if self:add_obj() then
        self.wire = wire_line(vec2(-1,0)+p,vec2(1,0)+p,e.wire,#e.wire.lines+1) --Wire.
    end
end

function not_gate:draw(s,x,y,info)
    local x,y = (x or 0)*s,(y or 0)*s 

    --We don't need draw wire here cause it will draw by editor.

    gdc()
    rect(x,y,self.width*s,self.height*s) --Background
    fill(COLOR2) fontSize(s) text("N",x,y) --"N"

    --Button update.
    self:update_button()
end

function not_gate:update()
    if self.output and self.input then
        local value = 1-self.input.output.value
        if value ~= self.output.input.value then
            self.output.input.value = value
            self.output:update()
        end
    end
end

function not_gate:touched(t)
    
end
