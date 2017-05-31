files = class()

function files:init(w)
    self.width = w or WIDTH-HEIGHT
    self.x = -self.width+WIDTH/30 --or 0
    self.dragging = false
    self.bgc = 1
end

function files:draw()
    translate(self.x,0)
    rectMode(CENTER) strokeWidth(0)
    local sw = WIDTH/160
    if self.touching_side then sw = WIDTH/100 end
    fill(COLOR2) rect(self.width/2,HEIGHT/2,self.width,HEIGHT)
    fill(COLOR4) rect(self.width+WIDTH/320,HEIGHT/2,sw,HEIGHT)
    
    --Draw files
    local w,h = WIDTH/30,HEIGHT/30
    fontSize(h) textMode(CORNER) rectMode(CORNER)
    translate(w*1.5,HEIGHT-h*2) stroke(COLOR4) 
    clip(self.x,0,self.width-sw/2,HEIGHT)
    self.dis_pos = vec2(1.5,-1)
    files:display_files(game.files,self.dis_pos) --Game files
    files:display_files(come_with_gates,self.dis_pos) --Come-with functions
    clip() textMode(CENTER) rectMode(CENTER) resetMatrix()
    
    --Draw
    if self.bgc <= 0 or (tap_count == 2 and CurrentTouch.state == ENDED and self.current_on.obj.open) then
        if self.current_on then self.current_on.obj:open() end
        self.bgc,self.dragging = 1,false
        game:display_name(self.current_on.obj.name)

        self.current_on = nil
    elseif self.dragging then
        local t = flat_ui:get_any_same_touch()
        if tap_count == 2 and self.current_on.obj.open then
            local td = flat_ui:touch_check_move().y
            self.bgc = math.min(self.bgc+math.min(td,0)/300,1)
            fill(0,50*self.bgc) strokeWidth(0)
            rect(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
        elseif t then
            if t.x > self.width+sw and self.current_on.obj.width and game:check_can_add_obj(self.current_on.obj,game.current_editor.type) then 
                clip(self.width+sw,0,WIDTH,HEIGHT) --Pre view for the obj.
                game.current_editor:draw_pre_view(self.current_on.obj,t) clip()
            else
                if t.x > self.width+sw then
                    fill(0,50*self.bgc) strokeWidth(0)
                    rect(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
                end
                fill(127, 127, 127, 84) rectMode(CENTER) strokeWidth(2)
                rect(t.x,t.y,WIDTH/8,WIDTH/8)
            end
            self.bgc = 1
        end
    else
        self.bgc = 1
    end
    
    --Display open name.
    if game.dis_nam then
        fill(COLOR3) fontSize(HEIGHT/10) textMode(CENTER)
        text(game.dis_nam.contains.name,(WIDTH-self.width-self.x)/2+self.width+self.x,game.dis_nam.pos)
    end
end

function files:display_files(t,n) 
    self.dis_pos.y = self.dis_pos.y-1 
    local w,__nu,h = WIDTH/30,textSize("l")
    local _t = CurrentTouch
    local co = not(t.obj.contains == nil) --If there is the "contains" array.
    
    local sh = h*0.6
    local rw = textSize(t.obj.name)+h

    --Touch checks.
    local _sw,_sh = rw,h
    local _sx,_sy = w*self.dis_pos.x+_sw/2-sh,h*self.dis_pos.y+_sh*0.75+HEIGHT
    local tc = flat_ui:touch_check_rect(_sx,_sy,_sw,_sh,TOUCH)

    if self.current_on == t then
        game.selecting_obj = {x = _sx,y = _sy,w = _sw,h = _sh,s = t}
        if flat_ui:touch_check_soft_tap(_sx,_sy,_sw,_sh) and t.open then
            t.open = flat_animate(t.open.pos,math.ceil(-t.open.pos/90)*90-90,0.2)
        elseif _t.state == MOVING and tc then
            self.dragging = true --Moving the obj.
        end
    else
        local gso = game.selecting_obj
        if gso and s == t then
            game.selecting_obj = nil
        end

    end

    if flat_ui:touch_check_soft_tap(_sx,_sy,_sw,_sh) then 
        self.current_on = t
    elseif tap_count == 1 and _t.state == BEGAN and not tc then
        self.current_on = nil
    end
    
    if co then t.open:update() end --Update arrow animation.
    
    local i
    if files_icons[t.obj.type] then i = files_icons[t.obj.type] else i = image(0,0) end
    fill(COLOR2+color(-10))
    strokeWidth(0)


    --Draw
    rect(-sh,0,rw,h)

    strokeWidth(0)
    sprite(i,-sh/8,h/2,sh)
    if co then pushMatrix() translate(-sh*2,h/2) rotate(t.open.pos) --Draw point arrow.
    sprite(sprites["open_arrow"],0,0,sh-WIDTH/200) end popMatrix() fill(COLOR4)

    text(t.obj.name,h/4,0)
    translate(0,-h)
    
    --Read files inside
    if co then if t.open.pos == 0 then return end
        translate(w,0)
        self.dis_pos.x = self.dis_pos.x+1
        for k , o in pairs(t.obj.contains) do
            files:display_files(o,self.dis_pos)
        end
        self.dis_pos.x = self.dis_pos.x-1
        translate(-w,0)
    end
    
end

function files:update()
    local lw = WIDTH/30
    if self.touching_side and CurrentTouch.state == MOVING then 
        self.x = math.max(math.min(CurrentTouch.x-self.width,0),-self.width+lw)
    else
        local m = 0
        if self.x > (-self.width+lw)*0.3 then m = 1 else m = -1 end
        m = m*DeltaTime*800
        self.x = math.max(math.min(self.x+m,0),-self.width+lw)
    end
    game.current_editor.camera.move = not (self.touching_side or self.dragging)
end

function files:touched(t)
    if tap_count == 1 then
        local sw = WIDTH/40
        if flat_ui:touch_check_one_rect(self.width+self.x,HEIGHT/2,sw,HEIGHT,t) and t.state == BEGAN then
            self.touching_side = true
        end
    else
        self.touching_side = false
    end
    if t.state == ENDED then 
        self.touching_side = false 
        
        if self.dragging and t.x > self.width+WIDTH/160 and self.current_on.obj.width then
            local e = game.current_editor 
            if game:check_can_add_obj(self.current_on.obj,e.type) then
                e:add_obj(self.current_on.obj,vec2(math.round((t.x+e.camera.x)/e.size),math.round((t.y+e.camera.y)/e.size)))
            end
        end
    end
end

files_icons = {} --Icons for files.
files_icons["project"] = readImage("Documents:project_icon")
files_icons["ui_editor"] = readImage("Documents:ui_icon")
files_icons["editor"] = readImage("Documents:editor_icon")
files_icons["folder"] = readImage("Documents:folder_icon")