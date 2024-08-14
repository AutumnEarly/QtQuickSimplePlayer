import QtQuick 2.15
import QtQuick.Controls
import "../../qcComponent/menu"
import "../../qcComponent"
import "../../theme"
import "../../singletonComponent"

QCMenu { // 右键菜单
    id: rightMenu
    property int playListCurrent: -1
    width: 200
    clip: false
    topPadding: 10
    bottomPadding: 10
    background: Rectangle {
        clip: false
        radius: 8
        color: "#"+ ThemeManager.theme.backgroundColor_2
    }
    QCMenuItem { // 播放
        width: rightMenu.width
        text: "播放"
        textColor: "#"+ ThemeManager.theme.fontColor
        icon.source: "qrc:/Images/player_2.svg"
        icon.color: "#"+ ThemeManager.theme.iconColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
        }
        onClicked: {
            playOneMusic()
        }
        function playOneMusic() {
            let contentData = musicFavoritePage.contentData
            let localCurrent = rightMenu.parent.localCurrent
            let index = rightMenu.playListCurrent
            var musicInfo = [{
                id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
                url: "", coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
            }]
            var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === contentData[index].id)
            if(localCurrent >= 0) {
                musicInfo[0].url = p_musicDownload.data[localCurrent].url
            }
            console.log("PageMusicFavoriteDetail.qml: " + findIndex)
            if(findIndex === -1) {
                p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,contentData[index])
                p_music_Player.thisPlayListInfoChanged()
                p_music_Player.thisPlayingCurrent += 1
            } else {
                p_music_Player.thisPlayingCurrent = findIndex
            }
            p_music_Player.playMusic(contentData[index].id,musicInfo[0])
        }
    }

    QCMenuItem { // 下一首播放
        width: rightMenu.width
        text: "下一首播放"
        textColor: "#"+ ThemeManager.theme.fontColor
        icon.source: "qrc:/Images/player_2.svg"
        icon.color: "#"+ ThemeManager.theme.iconColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
        }
        onClicked: {
            addOneMusic()
        }
        function addOneMusic() {
            let contentData = musicFavoritePage.contentData
            let localCurrent = rightMenu.parent.localCurrent
            let index = rightMenu.playListCurrent
            var musicInfo = [{
                id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
                url: "", coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
            }]
            var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === contentData[index].id)
            if(localCurrent >= 0) {
                musicInfo[0].url = p_musicDownload.data[localCurrent].url
            }
            console.log("PageMusicPlayListDetail.qml: " + findIndex)
            if(findIndex !== -1)  {
                return
            }
            p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,contentData[index])
            p_music_Player.thisPlayListInfoChanged()
            p_music_Player.thisPlayingCurrentChanged()

            console.log("PageMusicPlayListDetail.qml: 已添加："+JSON.stringify(musicInfo[0]))
        }
    }
    MenuSeparator{}

    QCMenuItem { // 添加到指定歌单
        width: rightMenu.width
        text: "添加到歌单"
        textColor: "#"+ ThemeManager.theme.fontColor
        icon.source: "qrc:/Images/musicPlayList.svg"
        icon.color: "#"+ ThemeManager.theme.iconColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
        }
        onClicked: {
            let cmp = Qt.createComponent("../../qcComponent/QCSelectAddPlayListPopup.qml")
            if(cmp.status === Component.Ready) {
                cmp = cmp.createObject(windowPage)
                cmp.musicInfo = musicFavoritePage.contentData[rightMenu.playListCurrent]
                cmp.open()
            }
        }

    }
    QCMenuItem { // 从此歌单移除
        width: rightMenu.width
        text: "从此歌单移除"
        textColor: "#"+ ThemeManager.theme.fontColor
        icon.source: "qrc:/Images/delete.svg"
        icon.color: "#"+ ThemeManager.theme.iconColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
        }
        onClicked: {
            removePlayList()
        }
        function removePlayList() {
            let contentData = musicFavoritePage.contentData
            let localCurrent = rightMenu.parent.localCurrent
            let index = rightMenu.playListCurrent
            p_favoriteMusic.remove(contentData[index].id)
            p_favoriteMusic.dataChanged()
        }
    }

    MenuSeparator{}

    QCMenuItem { // 下载音乐
        width: rightMenu.width
        text: "下载"
        textColor: "#"+ ThemeManager.theme.fontColor
        icon.source: "qrc:/Images/download.svg"
        icon.color: "#"+ ThemeManager.theme.iconColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
        }
        onClicked: {
            let index = rightMenu.playListCurrent
            let id = p_music_Player.thisPlayListInfo[index].id
            let artists = p_music_Player.thisPlayListInfo[index].artists
            let name = p_music_Player.thisPlayListInfo[index].name

            var musicUrlcallBack = res=> {
                var url = res.data.url
                if(!url) {
                    console.log("下载失败！")
                    return
                }
                var ar = artists.map(ar => ar.name).join(",")
                console.log("下载地址: " + url)
                p_musicDownload.addTask(url,ar + " - "+name,id)
                p_musicDownload.startDownload(id,p_music_Player.thisPlayListInfo[index])
            }

            p_musicRes.getMusicUrl({id: id,callBack:musicUrlcallBack})
        }
    }

}
