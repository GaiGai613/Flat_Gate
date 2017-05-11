files = class()

function files:init(w)
    self.width = w or WIDTH-HEIGHT
    self.x = -self.width+WIDTH/30 -- or 0
    self.dis_hei = 0
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
    
    -- Draw files
    local w,h = WIDTH/30,HEIGHT/30
    fontSize(h) textMode(CORNER) rectMode(CORNER)
    translate(w*1.5,HEIGHT-h*2) stroke(COLOR4) 
    clip(self.x,0,self.width-sw/2,HEIGHT)
    self.dis_hei = -1
    files:display_files(game.files,self.dis_hei) -- Game files
    files:display_files(come_with_gates,self.dis_hei) -- Come-with functions
    clip() textMode(CENTER) rectMode(CENTER) resetMatrix()
    
    -- Draw
    if self.bgc <= 0 or (tap_count == 2 and CurrentTouch.state == ENDED and self.current_on.obj.open) then
        if self.current_on then self.current_on.obj:open() end
        self.bgc,self.dragging = 1,false
        game:display_name(self.current_on.obj.name)

        self.current_on = nil
    elseif self.dragging then
        if tap_count == 2 and self.current_on.obj.open then
            local td = flat_ui:touch_check_move().y
            self.bgc = math.min(self.bgc+math.min(td,0)/300,1)
            fill(0,50*self.bgc) strokeWidth(0)
            rect(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT)
        else
            local t = flat_ui:get_any_same_touch()
            if t.x > self.width+sw and self.current_on.obj.width and game:check_can_add_obj(self.current_on.obj,game.current_editor.type) then 
                clip(self.width+sw,0,WIDTH,HEIGHT) -- Pre view for the obj.
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
    
    -- Display open name.
    if game.dis_nam then
        fill(COLOR3) fontSize(HEIGHT/10) textMode(CENTER)
        text(game.dis_nam.contains.name,(WIDTH-self.width-self.x)/2+self.width+self.x,game.dis_nam.pos)
    end
end

function files:display_files(t,n) 
    self.dis_hei = self.dis_hei+1 
    local w,h = WIDTH/30,HEIGHT/30
    local _t = CurrentTouch
    local co = not(t.obj.contains == nil) -- If there is the "contains" array.
    
    -- Touch checks.
    if tap_count == 1 and self.current_on == nil then 
        if _t.x < self.width+self.x-WIDTH/160 then
            local cy = self.dis_hei*-h+HEIGHT-h*2
            if _t.y >= cy and _t.y <= cy+h then
                self.current_on = t
            end
        end
    elseif tap_count == 0 then self.current_on = nil self.dragging = false end
    
    if self.current_on == t then
        if flat_ui:touch_check_multi_tap(0.2,1) and t.open and _t.state == BEGAN and _t.x <= self.width+self.x then
            t.open = flat_animate(t.open.pos,math.ceil(-t.open.pos/90)*90-90,0.2)
        elseif _t.state == MOVING then
            self.dragging = true -- Moving the obj.
        end
    end
    
    if co then t.open:update() end -- Update arrow animation.
    
    local i = image(0,0)
    if files_icons[t.obj.type] then i = files_icons[t.obj.type] end
    fill(COLOR2+color(-10))
    strokeWidth(0)
    if self.current_on ~= t then rect(-WIDTH/32-WIDTH/100,0,textSize((t.obj.name).."\t\t  ")) else
        local _,nh = textSize(t.obj.name)
        rect(-WIDTH*3,0,WIDTH*6,nh)
    end
    
    strokeWidth(2)
    sprite(i,-WIDTH/100,WIDTH/68,WIDTH/50)
    if co then pushMatrix() translate(-WIDTH/32,WIDTH/68) rotate(t.open.pos) -- Draw point arrow.
    sprite(sprites["open_arrow"],0,0,WIDTH/50) end popMatrix() fill(COLOR4) 
    text(t.obj.name,0,0)
    translate(0,-h)
    
    -- Read files inside
    if co then if t.open.pos == 0 then return end
        translate(w,0)
        for k , o in pairs(t.obj.contains) do
            files:display_files(o,self.dis_hei)
        end
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

files_icons = {} -- Icons for files.
files_icons["project"] = readImage("Project:project_icon")
files_icons["ui_editor"] = readImage("Project:ui_icon")
files_icons["editor"] = readImage("Project:editor_icon")
files_icons["folder"] = readImage("Project:folder_icon")