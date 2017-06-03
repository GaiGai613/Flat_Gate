supportedOrientations(LANDSCAPE_ANY)
displayMode(OVERLAY) displayMode(FULLSCREEN)
parameter.watch("1/DeltaTime")
sprite()

--DEVELOPMODE = false

TRYUPDATE = false

function setup()
    if TRYUPDATE then download() end
    cwg() --Setup set var.
    input_images()
    rectMode(CENTER) font("GillSans-Light")
    flat_ui = flat_ui()
    game = game()
    files = files()
end

function draw()
    flat_ui:draw()
    game:draw()
end

function touched(t)
    flat_ui:touched(t)
    game:touched(t)
    ui:touched(t)
end

function input_images()
    sprites = {} 
    local i = image(128,128)
    local w = i.width
    setContext(i)
    translate(w/2,w/2)
    stroke(COLOR4) strokeWidth(8)
    line(-w/2,w/2,w/2,0)
    line(-w/2,-w/2,w/2,0)
    setContext()
    sprites["open_arrow"] = i
end

function math.checkBetween(v,min,max)
    return math.min(math.max(v,min),max)
end

function math.roundTo(v,t)
    return math.round(v/t)*t
end

function get_gate_from_id(id,obj)
    if id == 1 then
        return not_gate(obj)
    elseif id == 2 then
        return lamp(obj)
    elseif id == 3 then
        return lever(obj)
    elseif id == 100 then
        return port(obj)
    end
end
