_camera = class()

function _camera:init(e)
    self.move = true
    self.x,self.y = 0,0
    self.apos = flat_animate(vec2(self.x,self.y),vec2(self.x,self.y),0)
    self.editor = e
end

function _camera:draw()
    self.apos:update()
    self.x,self.y = self.apos.pos:unpack()
end

function _camera:check_can_move(t)
    if not (t.x > files.width+WIDTH/80+files.x) then return false end --Check files touch.
    --Check add wire.
    if self.editor.wire then if self.editor.wire.add_wire_animate.pos > 0 then return false end end
    return true
end

function _camera:touched(t)
    self.moving = false
    if self.move and tap_count == 1 and self:check_can_move(t) then
        self.x,self.y = self.x-t.deltaX,self.y-t.deltaY
        self.moving = true
    end
    self.apos.pos = vec2(self.x,self.y)
    if t.state == ENDED then 
        local e = game.current_editor
        local pos = vec2(math.roundTo(self.x,e.size),math.roundTo(self.y,e.size))
        self.apos = flat_animate(self.apos.pos,pos,0.2)
        e.wire:update_camera(pos)
        e:update_camera(pos)
    end
end
