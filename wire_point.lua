wire_point = class()

function wire_point:init(pos,w,opens)
    self.x,self.y = pos:unpack()
    self.pos = pos
    self.wire = w
    self.opens = opens

    table.insert(self.wire.points,self)
end

function wire_point:draw(s,w)
    local o = self.opens
    rect(p.x*s,p.y*s,w*3) fill(COLOR2)
    rect(p.x*s,p.y*s,w)
    for j , ops in pairs(o) do
        local d = ops.d
        rect(p.x*s+d.x*w,p.y*s+d.y*w,w)
    end
end