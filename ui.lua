ui = class()

function ui:init()
    
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
        --if math.floor(px+x/s)%tl == 0 then strokeWidth(2) else strokeWidth(1) end
        line(px*s-x%s,-10,px*s-x%s,HEIGHT+10)
    end
    for py = 1 , HEIGHT/s do
        --if math.floor(py+y/s)%tl == 0 then strokeWidth(2) else strokeWidth(1) end
        line(-10,py*s-y%s,WIDTH+10,py*s-y%s)
    end
    c.a = 255
end

function ui:display_camera_pos(e)
    local c = e.camera
    local p = vec2(math.roundTo(c.x,e.size),math.roundTo(c.y,e.size))
    fill(COLOR2) fontSize(HEIGHT/24) textMode(CORNER)
    local t = "("..(p.x)..","..(p.y)..")"
    local w,h = textSize(t)
    text(t,WIDTH-w,HEIGHT-h)
    textMode(CENTER)
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