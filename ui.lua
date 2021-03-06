ui = class()

function ui:init()
    self.display_selecting_obj_animate = fasu(vec4(-10,-10,WIDTH+20,HEIGHT+20))
    self.display_selecting_obj_is_nil = true
end

function ui:draw_game()
    self:display_selecting_obj()
end

function ui:draw_editor(e,c)
    local c = c or COLOR4
    strokeWidth(1)
    stroke(cca(c,70))
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
end

function ui:display_camera_pos(e)
    local c = e.camera
    local p = vec2(math.round(c.x/e.size),math.round(c.y/e.size))
    p.x,p.y = math.floor(p.x),math.floor(p.y)
    
    fill(COLOR2) fontSize(HEIGHT/24) textMode(CORNER)
    local t = "("..(p.x)..","..(p.y)..")"
    local w,h = textSize(t)
    text(t,WIDTH-w,HEIGHT-h)
    textMode(CENTER)
end

function ui:display_selecting_obj()
    --Reset delay.
    if game.selecting_obj then self.display_selecting_obj_is_nil = false end

    if self.display_selecting_obj_animate.pos == vec4(-10,-10,WIDTH+20,HEIGHT+20) and not game.selecting_obj then return end

    local dsoa = self.display_selecting_obj_animate
    dsoa:update()

    local obj = game.selecting_obj

    --Setup.
    local t
    local b,e
    local x,y,w,h
    if obj then
        t = flat_ui:get_any_same_touch()
        b,e = obj.button or obj,obj.editor or {size = game.current_editor.size}
        x,y,w,h = b.x,b.y,b.w or b.width,b.h or b.height
    end
    
    local sw = 2

    --Change destination.
    if game.selecting_obj and dsoa.contains ~= game.selecting_obj then
        local bt = math.checkBetween
        local ad = vec4(x-w/2,y-h/2,bt(w+x-w/2,0,w),bt(h+y-h/2,0,h))
        ad.x,ad.y = bt(ad.x,sw,WIDTH-sw),bt(ad.y,sw,HEIGHT-sw)
        self.display_selecting_obj_animate = flat_animate(dsoa.pos,ad,0.1,game.selecting_obj)
    elseif not game.selecting_obj and self.display_selecting_obj_is_nil then
        local ad = vec4(-10,-10,WIDTH+20,HEIGHT+20)
        self.display_selecting_obj_animate = flat_animate(dsoa.pos,ad,0.1)
    end

    --Draw all the lines.
    strokeWidth(sw) stroke(COLOR4) lineCapMode(ROUND)
    local dop = dsoa.pos
    local points = {vec2(dop.x,dop.y),vec2(dop.x,dop.y+dop.w),vec2(dop.x+dop.z,dop.y+dop.w),vec2(dop.x+dop.z,dop.y)}
    for k , point in pairs(points) do
        local x1,y1 = point:unpack()
        local x2,y2 = (points[k%#points+1]):unpack()
        line(x1,y1,x2,y2)
    end
    lineCapMode(SQUARE)

    --Add a one tick delay on reset.
    if not game.selecting_obj then self.display_selecting_obj_is_nil = true end
end

function ui:get_selecting_obj_info()
    local obj = game.selecting_obj
    if not obj then return false end
    local b = obj.button or obj
    local x,y = b.x,b.y
    local w,h = b.width or b.w,b.height or b.h
    return x,y,w,h
end

function ui:display_obj_info(obj)
    
end

function ui:touched(t)
    
end

function change_color_alpha(c,a)
    local cc = color(c.r,c.g,c.b,a)
    return cc
end
cca = change_color_alpha

--Theme colors.
COLOR1 = color(255,255,255)
COLOR2 = color(53,56,60)
COLOR3 = color(255,145,0)
COLOR4 = color(89,211,200) --CAN'T CHANGE.
COLOR5 = color(225, 225, 225, 255)