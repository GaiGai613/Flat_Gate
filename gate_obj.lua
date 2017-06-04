gate_obj = class()

function gate_obj:add_obj()
    if not obj then return false end
    local e = obj.editor
    local s = e.size
    local p = vec2(obj.x,obj.y)
    
    self.obj = obj
    self:update_button_pos() --Add button.
    return true
end

function gate_obj:update_button()
    if self.button then 
        flat_ui:button_draw(self.button)
        if self.button.pressed then
            game.selecting_obj = self
        end
    end 
end

function gate_obj:update_button_pos()
    if not self.obj.editor then return end
    if not self.button then self.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = self.obj.editor
    local cpos = vec2(ed.camera.x,ed.camera.y)
    local pos = vec2(self.obj.x,self.obj.y)*ed.size-cpos
    
    self.button.x,self.button.y = pos:unpack()
    self.button.width,self.button.height = self.width*ed.size,self.height*ed.size
end