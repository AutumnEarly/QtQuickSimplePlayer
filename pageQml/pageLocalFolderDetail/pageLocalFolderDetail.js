

function selectMode(mode = 0) {

    let mode0_func = () => {
        console.log(contentData.length)
        let t = []
        for(let i = 0; i < localFolderPage.foldersData.length;i++) {
           t.push(...localFolderPage.foldersData[i].data)
        }
        contentData = t
        loaderItem.source = "./AllShowItem.qml"
        console.log(t.length)
    };
    let mode1_func = () => {
        if(localFolderPage.foldersData.length > 0) {
            contentData = localFolderPage.foldersData[0].data
        }
        loaderItem.source = "./FolderShowItem.qml"
    };
    switch(mode) {
        case 0: mode0_func();
            break
        case 1: mode1_func();
            break;
    }
    localFolderPage.mode = mode;
}

function parseFolder() {

    let t = []
    for(let i = 0; i < folderListModel.count;i++) {
        if(folderListModel.isFolder(i)) {

        } else {
            let name = folderListModel.get(i,"fileName")
            name = name.slice(0,name.lastIndexOf("."))
            let id = folderListModel.get(i,"filePath")
            let url = folderListModel.get(i,"filePath")
            t.push({
                   "id": id,
                   "name": name ,
                   "artists": [{"id":"","name":"未知"}],
                   "album": {"id":"","name":"本地音乐"},
                   "coverImg":"",
                   "url": url ,
                   "allTime":"00:00",
                   })
        }

    }
    return t
}

function addFolder(url) {

    let index = foldersData.findIndex( o => o.url === url)
    if(index !== -1)  {
        console.log("PageLocalFolderDetail.qml: 已有此文件夹！")
        return
    }

    foldersData.push({ "url": url,"data": parseFolder() })
    localFolderPage.foldersDataChanged()
    localFolderPage.dataValueChanged()
//        console.log("PageLocalFolderDetail.qml: "+ JSON.stringify(foldersData) )
}


/*
    为播放列表添加并播放单曲
*/
function addPlayOneMusic(index, localCurrent = -1) {
    var musicInfo = [{
        id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
        url: "file:///" + contentData[index].url, coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
    }]
    var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === musicInfo[0].id)

    console.log("PageMusicFavoriteDetail.qml: " + findIndex)
    if(findIndex === -1) {
        p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,musicInfo[0])
        p_music_Player.thisPlayListInfoChanged()
        p_music_Player.thisPlayingCurrent += 1
    } else {
        p_music_Player.thisPlayingCurrent = findIndex
    }
    p_music_Player.playMusic(contentData[index].id,musicInfo[0])
}


/*
    获取Column组件的高度
*/
function getAllHeight(children,spacing) {
    var h = 0
    for(var i = 0;i < children.length;i++) {
        if(children[i] instanceof Text) {
            h += children[i].contentHeight
        } else {
            h += children[i].height
        }
    }
    h += (children.length-1) *spacing
//        console.log("height: " + h)
    return h
}
