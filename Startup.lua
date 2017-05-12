function setup()
    if readLocalData("downloaded") then
        saveLocalData("downloaded",false)
        return
    end
    

    url = "https://raw.githubusercontent.com/GaiGai613/Flat_Gate/master/"

    print("Start downloading file index...")

    http.request(url.."download_files.lua",update_download_files,not_get_data)

    now_tab = 1
    
    saveLocalData("downloaded",true)
end

function request_data(id)
    local info = classes[id]
    http.request(url..(info.name)..(info.type),get_data,not_get_data)
end

function update_download_files(data,status,headers)
    print("Starting download files...")
    saveProjectTab("download_files",data)
    request_data(now_tab)
end

function get_data(data,status,headers)
    local info = classes[now_tab]
    print('Finished download file "'..(info.name)..(info.type)..'".')
    if info.type == ".lua" then
        saveProjectTab(info.name,data)
    elseif info.type == ".png" then
        saveImage("Project:"..info.name,data)
    end
    if now_tab == #classes then print("Finished.") restart() end
    now_tab = now_tab+1
    request_data(now_tab)
end

function not_get_data(error)
    print("Error\n"..error)
end