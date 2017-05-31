lamp = class()

function lamp:init(obj)
    self.value = 0
    self.name,self.type = "LAMP","output_gate"
    self.can_add_to = {"ui_editor"}
    self.obj = obj
    self.gate_id = 2
    self.width,self.height = 1,1
    if obj then
        local s = obj.editor.size
        self.obj = obj
        self.button = flat_ui:add_button(obj.x*s,obj.y*s,self.width*s,self.height*s,color(0,0))
    end
end

function lamp:draw(s,x,y)
    local x,y = (x or 0)*s,(y or 0)*s 
    strokeWidth(0) fill(COLOR2+color(-30))
    rect(x,y,s) if self.value == 0 then fill(COLOR2+color(10)) else fill(235, 214, 67, 255) end
    rect(x,y,s*0.8)

    --Button update.
    if self.button then flat_ui:button_draw(self.button) end
    if self.button.pressed then
        if tap_count == 1 then game.selected = self end
    end 
end

function lamp:update()
    if self.input then
        self.value = self.input.value
    end
end

function lamp:update_button_pos()
    if not self.obj.editor then return end
    if not self.button then self.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = self.obj.editor
    local pos = vec2(self.obj.x,self.obj.y)*ed.size
    
    self.button.x,self.button.y = pos:unpack()
    self.button.width,self.button.height = self.width*ed.size,self.height*ed.size
end

function lamp:touched(t)
    local b,obj = self.button,self.obj
    b.x,b.y = b.x-obj.editor.camera.x,b.x-obj.editor.camera.x
    flat_ui:button_draw(self.button)
    if self.button.pressed then print("xixi") end
end