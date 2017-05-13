wire_line = class()

function wire_line:init(s,e,w,p)
    self.wire,self.p = w,p
    self.s,self.e = s,e -- Start, End.
    self.wire.lines[p] = self
    self:update_button_pos()
    self.selected = false
end

function wire_line:draw(s,w)
    local sx,sy = self.s:unpack()
    local ex,ey = self.e:unpack()

    stroke(COLOR3) strokeWidth(w*3) fill(COLOR3)
    line(sx*s,sy*s,ex*s,ey*s) stroke(COLOR2) strokeWidth(w)
    line(sx*s,sy*s,ex*s,ey*s)
    
    if self.button then flat_ui:button_draw(self.button) end
end

function wire_line:update_button_pos()
    if not self.wire.editor then return end
    if not self.button then self.button = flat_ui:add_button(0,0,0,0,color(0,0)) end
    local ed = self.wire.editor
    local cpos = vec2(ed.camera.x,ed.camera.y)
    local s,e = self.s*ed.size-cpos,self.e*ed.size-cpos
    
    self.button.x,self.button.y = ((s+e)/2):unpack()
    self.button.width,self.button.height = (s-e):unpack()
    self.button.width,self.button.height = math.abs(self.button.width),math.abs(self.button.height)
end

function wire_line:touched(t)
    if t.state == BEGAN then self.selected = false end
    if self.button.pressed and tap_count == 1 then self.selected = true end
end