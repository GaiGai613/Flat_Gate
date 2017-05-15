wire = class()

function wire:init(e)
    self.editor = e
    self.lines,self.points = {},{}
    self.add_wire_animate = fasu(-0.3)
    self.st = vec2(0,0)
    self.current_wire_dir = vec2(0,0) -- Not useful now.
end

function wire:draw(s)
    local w = s/10
    for k , l in pairs(self.lines) do
        l:draw(s,w)
    end
    strokeWidth(0) 
    for k , p in pairs(self.points) do
        p:draw(s,w)
    end
    
    self:add_animate()
end

function wire:add_animate()
    self.adding = self.add_wire_animate.pos == 1
    if not self.editor then return end
    
    local c = self.editor.camera
    translate(c.x,c.y)
    local awa = self.add_wire_animate
    awa:update()
    if awa.pos >= 0 and awa.pos ~= 1 then
        local t = flat_ui:get_any_same_touch()
        if not t then return end
        stroke(COLOR2) strokeWidth(4)
        flat_ui:loading_bar(awa.pos,t.x,t.y+HEIGHT/12,COLOR1,WIDTH/13,HEIGHT/30,COLOR3,5)
    end
    translate(-c.x,-c.y)
end

function wire:add_line(s,e)
    local l = wire_line(s,e,self,#self.lines+1)
    for k , one_line in pairs(self.lines) do
        self:group_wires(l,one_line)
    end
end

function wire:add_point(pos,ws)
    local p;
    if not self.points[pos] then 
        p = wire_point(pos,self,{}) 
    else 
        p = self.points[pos]
    end

    for k , one_open in pairs(ws) do
        self:point_add_open(p,one_open)
    end
end

function wire:point_add_open(p,w)
    local od = -p.pos;
    if p.pos == w.s then od = od+w.e else od = od+w.s end

    if od.x > 0 then od.x = 1 elseif od.x < 0 then od.x = -1 end
    if od.y > 0 then od.y = 1 elseif od.y < 0 then od.y = -1 end

    p.opens[od] = od
end

function wire:check_group_wires(w1,w2)
    if w1.s == w2.s and w1.e == w2.e then return false end
    
    if w1.s.x-w1.e.x == 0 and w2.s.x-w2.e.x == 0 and w1.s.x == w2.s.x then
        local l1ymax,l1ymin = math.max(w1.s.y,w1.e.y),math.min(w1.s.y,w1.e.y)
        local l2ymax,l2ymin = math.max(w2.s.y,w2.e.y),math.min(w2.s.y,w2.e.y)

        if l1ymax >= l2ymin and l2ymax >= l1ymin then
            local maxy,miny = math.min(l1ymin,l2ymin),math.max(l1ymax,l2ymax)
            return vec2(w1.s.x,miny),vec2(w1.s.x,maxy)
        end
    elseif w1.s.y-w1.e.y == 0 and w2.s.y-w2.e.y == 0 and w1.s.y == w2.s.y then
        local l1xmax,l1xmin = math.max(w1.s.x,w1.e.x),math.min(w1.s.x,w1.e.x)
        local l2xmax,l2xmin = math.max(w2.s.x,w2.e.x),math.min(w2.s.x,w2.e.x)

        if l1xmax >= l2xmin and l2xmax >= l1xmin then
            local maxx,minx = math.min(l1xmin,l2xmin),math.max(l1xmax,l2xmax)
            return vec2(minx,w1.s.y),vec2(maxx,w1.s.y)
        end
    end
    return false
end

function wire:check_wire_collide(w1,w2)
    local l1xmax,l1xmin = math.max(w1.s.x,w1.e.x),math.min(w1.s.x,w1.e.x)
    local l1ymax,l1ymin = math.max(w1.s.y,w1.e.y),math.min(w1.s.y,w1.e.y)
    local l2xmax,l2xmin = math.max(w2.s.x,w2.e.x),math.min(w2.s.x,w2.e.x)
    local l2ymax,l2ymin = math.max(w2.s.y,w2.e.y),math.min(w2.s.y,w2.e.y)

    if l1xmax >= l2xmin and l2xmax >= l1xmin and l1ymax >= l2ymin and l2ymax >= l1ymin then
        local c1 = vec2(math.max(l1xmin,l2xmin),math.max(l1ymin,l2ymin))
        local c2 = vec2(math.min(l1xmax,l2xmax),math.min(l1ymax,l2ymax))
        return c1,c2
    end
    return false
end

function wire:group_wires(w1,w2)
    local s,e = self:check_group_wires(w1,w2)
    local s1,e1,s2,e2 = w1.s,w1.e,w2.s,w2.e
    local a1 = (s1-e1):angleBetween(vec2(1,0))
    local a2 = (s2-e2):angleBetween(vec2(1,0))

    if a1 ~= a2 then
        local c1,c2 = self:check_wire_collide(w1,w2)
        if c1 then 
            self:add_point(c1,{w1,w2})
        end
    end

    if s then
        w1.s,w1.e = s,e
        self.lines[w2.p] = nil
        w1:update_button_pos()
    end
end

function wire:update_camera(pos)
    for k , one_wire in pairs(self.lines) do
        one_wire:update_button_pos(pos)
    end
end

function wire:touched(t)
    if tap_count == 1 then
        if t.state == BEGAN then
            self.st = vec2(t.x,t.y)
            self.add_wire_animate = flat_animate(-1,1,0.8)
        elseif self.add_wire_animate.pos < 0 then
            self.add_wire_animate = fasu(-1)
        end
        if self.adding then
            local es,ec = self.editor.size,self.editor.camera
            local ax,ay = math.round((self.st.x+ec.x)/es),math.round((self.st.y+ec.y)/es)
            local tx,ty = math.round((t.x+ec.x)/es),math.round((t.y+ec.y)/es)
            if ax-tx ~= 0 then
                self:add_line(vec2(ax,ay),vec2(tx,ay))
                self.st = vec2(t.x,t.y)
            elseif ay-ty ~= 0 then
                self:add_line(vec2(ax,ay),vec2(ax,ty))
                self.st = vec2(t.x,t.y)
            end
        end
    elseif self.add_wire_animate ~= fasu(-1) then
        self.add_wire_animate = fasu(-1)
    end

    for k , one_wire in pairs(self.lines) do
        one_wire:touched(t)
    end
end
