
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
    console.log("PageMyMusicPlayListDetail.qml: " + findIndex)
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
    读取歌单数据
*/
function readData(dataPath) {
    let t = QCTool.readFile(dataPath)
    try {
        t = JSON.parse(t)
    } catch(err) {
        t = []
        console.log("PageMyMusicPlayListDetail.qml: " +err)
    }
    return t
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
