folder = class()

function folder:init(n,c)
    self.name = n
    self.type = "folder"
    self.files = {obj = self,open = fasu()}
    self.contains = c or {}
end