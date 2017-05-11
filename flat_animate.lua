flat_animate = class()

function flat_animate:init(s,e,t,c)
    self.start = s
    self._end = e
    self.duration = t
    self.time = 0
    self.last_time = ElapsedTime
    self.pos = self.start
    self.add_one_second = (self._end-self.start)/self.duration
    self.contains = c
end

function flat_animate:update()
    if self.time == self.duration then return end
    local delay = ElapsedTime-self.last_time
    self.last_time = ElapsedTime
    self.time = self.time+delay
    self.pos = self.pos+self.add_one_second*delay
    if self.time >= self.duration then
        self.pos = self._end
        self.time = self.duration
    end
    
end

function fasu(s)
    return {pos = s or 0,update = function() return end}
end