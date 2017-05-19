ui = class()

function ui:init()
    self.display_camera_pos_animate = fasu(HEIGHT/20)
    self.display_camera_pos_value = vec2(0,0)
end

function ui:draw_editor(e,c)
    local c = c or COLOR4
    strokeWidth(1)
    c.a = 70
    stroke(c)
    local s = e.size
    local x,y = e.camera.x,e.camera.y
    local tl = 4
    for px = 1 , WIDTH/s do
        if math.floor(px+x/s)%tl == 0 then strokeWidth(2) else strokeWidth(1) end
        line(px*s-x%s,-10,px*s-x%s,HEIGHT+10)
    end
    for py = 1 , HEIGHT/s do
        if math.floor(py+y/s)%tl == 0 then strokeWidth(2) else strokeWidth(1) end
        line(-10,py*s-y%s,WIDTH+10,py*s-y%s)
    end
    c.a = 255
end

function ui:display_camera_pos(e)
    self.display_camera_pos_animate:update()

    local c = e.camera
    local p = vec2(math.roundTo(c.x,e.size),math.roundTo(c.y,e.size))
    local s = self.display_camera_pos_animate
    fill(COLOR2) fontSize(s.pos) textMode(CORNER)
    local t = "("..(p.x)..","..(p.y)..")"
    local w,h = textSize(t)
    text(t,WIDTH-w,HEIGHT-h)
    textMode(CENTER)

    -- Change pos animate.
    local sp = self.display_camera_pos_value
    if p.x ~= sp.x or p.y ~= sp.y then
        local ap = self.display_camera_pos_animate
        ap = flat_animate(ap.pos,HEIGHT/18,0.1)
        tween.delay(0.1,function()
            ap = flat_animate(ap.pos,HEIGHT/20,0.1)
        end
        )
        sp = p
    end
end

function ui:display_obj_info(obj)
    
end

function ui:touched(t)
    
end

-- Theme colors.
COLOR1 = color(255,255,255)
COLOR2 = color(53,56,60)
COLOR3 = color(255,145,0)
COLOR4 = color(89,211,200) -- CAN'T CHANGE.
COLOR5 = color(225, 225, 225, 255)