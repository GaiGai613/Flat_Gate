lamp = class(gate_obj)

function lamp:init(obj)
    self.value = 0
    self.name,self.type = "LAMP","output_gate"
    self.can_add_to = {"ui_editor"}
    self.obj = obj
    self.gate_id = 2
    self.width,self.height = 1,1

    self:add_obj()
end

function lamp:draw(s,x,y)
    local x,y = (x or 0)*s,(y or 0)*s 
    strokeWidth(0) fill(COLOR2+color(-30))
    rect(x,y,s) if self.value == 0 then fill(COLOR2+color(10)) else fill(235, 214, 67, 255) end
    rect(x,y,s*0.8)

    --Button update.
    self:update_button()
end

function lamp:update()
    if self.input then
        self.value = self.input.value
    end
end

function lamp:touched(t)
    
end