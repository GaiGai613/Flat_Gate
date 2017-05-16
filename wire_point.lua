wire_point = class()

function wire_point:init(pos,w,opens)
    self.x,self.y = pos:unpack()
    self.pos = pos
    self.wire = w
    self.opens = opens

    local t = self.wire.points
    if not t[self.x] then t[self.x] = {} end
    t[self.x][self.y] = self
end

function wire_point:draw(s)
    local w = s/10
    fill(COLOR3)
    rect(self.x*s,self.y*s,w*3) fill(COLOR2)
    rect(self.x*s,self.y*s,w)
    for k , d in pairs(self.opens) do
        rect(self.x*s+d.x*w,self.y*s+d.y*w,w)
    end
end