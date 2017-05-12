function download()
    if readLocalData("downloaded") then
        saveLocalData("downloaded",false)
        return
    end
    
    url = "https://raw.githubusercontent.com/GaiGai613/Flat_Gate/master/"

    classes = {
    {name = "camera",type = ".lua"},
    {name = "editor",type = ".lua"},
    {name = "files",type = ".lua"},
    {name = "flat_animate",type = ".lua"},
    {name = "flat_ui",type = ".lua"},
    {name = "folder",type = ".lua"},
    {name = "game",type = ".lua"},
    {name = "lamp",type = ".lua"},
    {name = "lever",type = ".lua"},
    {name = "Main",type = ".lua"},
    {name = "not_gate",type = ".lua"},
    {name = "port",type = ".lua"},
    {name = "ui",type = ".lua"},
    {name = "ui_editor",type = ".lua"},
    {name = "wire",type = ".lua"},
    {name = "wire_line",type = ".lua"},
    {name = "wire_point",type = ".lua"},
    {name = "editor_icon",type = ".png"},
    {name = "folder_icon",type = ".png"},
    {name = "project_icon",type = ".png"},
    {name = "ui_icon",type = ".png"}
    }

    now_tab = 1
    
    request_data(now_tab)
    
    saveLocalData("downloaded",true)
end

function request_data(id)
    local info = classes[id]
    http.request(url..(info.name)..(info.type),get_data,not_get_data)
end

function get_data(data,status,headers)
    local info = classes[now_tab]
    if info.type == ".lua" then
        saveProjectTab(info.name,data)
    elseif info.type == ".png" then
        saveImage("Project:"..info.name,data)
    end
    if now_tab == #classes then restart() end
    now_tab = now_tab+1
    request_data(now_tab)
end

function not_get_data(error)
    print("Error\n"..error)
end
-- download()