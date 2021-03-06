--Download setup.
if not readLocalData("VERSION") then saveLocalData("VERSION","Beta 0.1.0") end
VERSION = readLocalData("VERSION")

function download()
    url = "https://raw.githubusercontent.com/GaiGai613/Flat_Gate/master/"
    now_tab = 1
    print("Starting...")

    if not (string.sub(VERSION,1,17) == "NEED UPDATE FILES") then
        print("Checking update...")
        http.request(url.."VERSION.txt",get_update_info,not_get_data)
    else
        request_data(now_tab)
    end
end

function request_data(id)
    local info = classes[id]
    http.request(url..(info.name)..(info.type),get_data,not_get_data)
end

function get_update_info(data,status,headers)
    if string.sub(VERSION,1,11) == "NEED UPDATE" then
        http.request(url.."download_files.lua",update_download_files,not_get_data)
    elseif data == VERSION and not REDOWNLOAD then
        alert("Already on the latest version.")
        close()
    else
        saveLocalData("VERSION","NEED UPDATE"..data)
        restart()
    end
end

function update_download_files(data,status,headers)
    print("Starting download files...")
    saveProjectTab("download_files",data)
    saveLocalData("VERSION","NEED UPDATE FILES"..string.sub(VERSION,12))
    restart()
end

function get_data(data,status,headers)
    local info = classes[now_tab]
    local action_done

    print('Finished download file "'..(info.name)..(info.type)..'".')
    if info.type == ".lua" then
        local tab = readProjectTab(info.name)
        if not (tab == data) then
            saveProjectTab(info.name,data)
            action_done = "Saved tab.\n"..(string.len(data))
            changed_tab = (changed_tab or 0)+1
        else
            action_done = "No change."
        end
    elseif info.type == ".png" then
        action_done = "Changed image."
        saveImage("Documents:"..info.name,data)
    end
    print(action_done)

    if now_tab == #classes then print("Finished.") alert("Finished.\nChanged "..(changed_tab or "no").." tab.") close() end
    now_tab = now_tab+1
    request_data(now_tab)
end

function not_get_data(error)
    print("Error\n"..error)
    alert("Error\n"..error)
    close()
end