function setup()
    if classes then downloaded_index = true else downloaded_index = false end
    url = "https://raw.githubusercontent.com/GaiGai613/Flat_Gate/master/"
    now_tab = 1

    print("Start downloading file index...")

    if not downloaded_index then http.request(url.."download_files.lua",update_download_files,not_get_data) return end
    request_data(now_tab)
end

function request_data(id)
    local info = classes[id]
    http.request(url..(info.name)..(info.type),get_data,not_get_data)
end

function update_download_files(data,status,headers)
    print("Starting download files...")
    saveProjectTab("download_files",data)
    restart()
end

function get_data(data,status,headers)
    local info = classes[now_tab]
    print('Finished download file "'..(info.name)..(info.type)..'".')
    if info.type == ".lua" then
        saveProjectTab(info.name,data)
    elseif info.type == ".png" then
        saveImage("Project:"..info.name,data)
    end
    if now_tab == #classes then print("Finished.") alert("Finished.") if not DEVELOPMODE then restart() else close() end end
    now_tab = now_tab+1
    request_data(now_tab)
end

function not_get_data(error)
    print("Error\n"..error)
end