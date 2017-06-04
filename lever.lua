lever = class(gate_obj)

function lever:init(obj)
    self.value = 0
    self.name,self.type = "LEVER","input_gate"
    self.can_add_to = {"ui_editor"}
    self.gate_id = 3
    self.width,self.height = 1,1
    
    self:add_obj()
end

function lever:draw(s,x,y)
    local obj = self.obj
    local x,y = (x or 0)*s,(y or 0)*s
    
    strokeWidth(0)
    fill(COLOR2) rect(x,y,s)
    fill(COLOR1) --[strokeWidth(0) stroke(COLOR4)]
    rect(x,y+(-self.value+0.5)*0.6*s,s*0.8,s*0.2)

    --Button update.
    self:button_update()
end

function lever:update()
    if self.output then
        local value = self.value
        if self.output.input ~= value then
            self.output.input = value
            self.output:update()
        end
    end
end

function lever:touched(t)
    flat_ui:button_draw(self.button)
    if self.button.pressed then self.value = math.abs(self.value-1) end
end