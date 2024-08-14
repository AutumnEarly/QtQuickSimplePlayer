

/*
    为播放列表添加并播放单曲
*/
function addPlayOneMusic(index, localCurrent = -1) {
    var musicInfo = [{
        id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
        url: "", coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
    }]
    var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === contentData[index].id)
    if(localCurrent >= 0) {
        musicInfo[0].url = p_musicDownload.data[localCurrent].url
    }
    console.log("PageMusicAlbumDetail.qml: " + findIndex)
    if(findIndex === -1) {
        p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,contentData[index])
        p_music_Player.thisPlayListInfoChanged()
        p_music_Player.thisPlayingCurrent += 1
    } else {
        p_music_Player.thisPlayingCurrent = findIndex
    }
    p_music_Player.playMusic(contentData[index].id,musicInfo[0])
}
/*
    将播放列表替换为歌单列表
*/
function openRightMenu(parent , x , y , index) {

    oneMusicMenu.parent = parent
    oneMusicMenu.x = x
    oneMusicMenu.y = y
    oneMusicMenu.playListCurrent = index
    oneMusicMenu.open()
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
/*
    获取当前专辑的所有信息
*/
function getAlbumInfoData(obj) {

    var xhr = new XMLHttpRequest()
    var id = obj.id || ""
    var callBack = obj.callBack || (()=>{})
    if(!id) {
        callBack({status:xhr.status})
        return
    }

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var res = JSON.parse(xhr.responseText)
                contentData = res.songs.map(r => {
                                        return {
                                            id: r.id,
                                            name: r.name,
                                            artists: r.ar,
                                            album: r.al,
                                            url: "",
                                            coverImg: r.al.picUrl,
                                            allTime: p_musicRes.setAllTime(r.dt)
                                        }
                                    })
                albumInfo = res.album
                musicAlbumPageListView.currentIndex = -1
                callBack({status:xhr.status})
            } else {
                callBack({status:xhr.status})
                console.error("Request failed: " + xhr.status); // 请求失败
            }
        }
    };
    xhr.open("GET", "http://localhost:3000//album?id=" + id); // 发起 GET 请求
    xhr.send(); // 发送请求

}

function playerAll() { // 播放全部
    p_music_Player.thisPlayListInfo = []
    p_music_Player.thisPlayingCurrent = -1

    p_music_Player.thisPlayListInfo = contentData.slice(0,contentData.length)
    p_music_Player.playMusic(p_music_Player.thisPlayListInfo[0].id,p_music_Player.thisPlayListInfo[0])
    p_music_Player.thisPlayingCurrent = 0
}
function addPlayAll() { // 添加所有歌曲

    let insertIndex = p_music_Player.thisPlayingCurrent
    for(let i = 0; i < contentData.length;i++) {
        let index = p_music_Player.thisPlayListInfo.find( o => o.id === contentData[i].id)
        if(index) continue
        p_music_Player.thisPlayListInfo.splice(++insertIndex,0,contentData[i])
        console.log("已添加：歌曲" + contentData[i].name)
    }
    p_music_Player.thisPlayListInfoChanged()
    p_music_Player.thisPlayingCurrentChanged()
}
