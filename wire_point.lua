wire_point = class()

function wire_point:init(pos,w,opens)
    self.x,self.y = pos:unpack()
    self.pos = pos
    self.wire = w
    self.opens = opens

    self.wire.points[(self.pos):unpack()] = self
end

function wire_point:draw(s,w)
    local p = self
    fill(COLOR3)
    rect(p.x*s,p.y*s,w*3) fill(COLOR2)
    rect(p.x*s,p.y*s,w)
    for k , d in pairs(self.opens) do
        rect(p.x*s+d.x*w,p.y*s+d.y*w,w)
    end
end