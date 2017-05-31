ui_editor = class(editor)

function ui_editor:init()
    self.type,self.name = "ui_editor","U.I. Editor"
    self.files,self.contains = {},{}
    self.objs = {}
    self.camera = _camera(self) self.camera.move = false --Camera can't move.
    self.size = math.round(WIDTH/32)
end

function ui_editor:draw()
    ui:draw_editor(self,COLOR3)
    rectMode(CENTER)
    for k , one_obj in pairs(self.objs) do
        local obj = one_obj.obj
        obj:draw(self.size,obj.obj.x,obj.obj.y)
    end
end

function ui_editor:update()
    
end

function ui_editor:touched(t)
    for k , one_obj in pairs(self.objs) do
        one_obj.obj:touched(t)
    end
end