import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia
import qc.window
import QtCore
import "./singletonComponent"
import "./pageQml"
import "./qcComponent"
import "./theme"

FramelessWindow {
    id: window
    property var desktopLyric: null

    width: 1010
    height: 710
    minimumWidth: 1010 
    minimumHeight: 710
    title: "正在播放: " + p_music_Player.thisPlayMusicInfo.name + "~"

    MusicResource { // 音乐资源访问管理
        id: p_musicRes
    }
    QCMusicPlayer {
        id: p_music_Player
    }

    MusicDownload { // 下载音乐
        id: p_musicDownload
        downloadSavePath: "Download"
    }


    Rectangle { // 页面管理
        id: windowPage
        property string operatingInfoPath: "system/operatingInfo.json"
        property var operatingInfo: null
        width: window.width
        height: window.height
        radius: 5
        clip: true
        color: "#" + ThemeManager.theme.backgroundColor

        Item { // 主页面
            id: mainPage
            width: window.width
            height: window.height
            Column {
                width: parent.width
                height: parent.height
                QCTitleBar { // 标题栏
                    id: titleBar
                }
                Row { // 主体部分
                    id: content
                    width: parent.width
                    height:  window.height - titleBar.height - bottomBar.height
                    QCLeftBar {
                        id: leftBar
                    }
                    QCRightContent {
                        id: rightContent
                    }
                }

                QCBottomBar { // 底部栏
                    z: 25
                    id: bottomBar
                    width: parent.width
                    height: 80
                }
            }

            QCThemeConfigLabel {
                id: p_ThemeManagerConfigLabel
                x: windowPage.width - width - 15
                y: titleBar.height - 1
            }
        }
        Loader { // 歌词详情页面
            id: musicLyricPage
            property bool isShow: false
            width: parent.width
            height: parent.height
            active: false
            source: "./pageQml/PageMusicLyricDetail.qml"
            onLoaded: {
                item.y = height
            }

            Binding  {
                when: musicLyricPage.item != null
                property: "lyricData"
                target: musicLyricPage.item
                value: p_musicRes.thisMusicLyric
            }

            // 加载/卸载歌词页面动画
            SequentialAnimation {
                id: musicLyricPageAni
                property double endY: 0
                property double endOpacity: 1

                ParallelAnimation {

                    PropertyAnimation {
                        target: musicLyricPage.item
                        property: "y"
                        duration: 300
                        to: musicLyricPageAni.endY
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        target: musicLyricPage.item
                        property: "opacity"
                        duration: 300
                        to: musicLyricPageAni.endOpacity
                        easing.type: Easing.InOutQuad
                    }
                }
                onStopped: {
                    if(musicLyricPage.item.y !== musicLyricPage.height) {
                        musicLyricPage.isShow = true
                        mainPage.visible = false
                    } else {
                        musicLyricPage.isShow = false
                        musicLyricPage.active = false
                    }
                }
            }

            function showPage() { // 加载歌词页面
                musicLyricPage.active = true
                musicLyricPageAni.endY = 0
                musicLyricPageAni.endOpacity = 1
                musicLyricPageAni.start()
            }
            function hidePage() { // 卸载歌词页面
                musicLyricPageAni.endY = parent.height
                musicLyricPageAni.endOpacity = 0
                musicLyricPageAni.start()
                mainPage.visible = true
            }

        }

        QCThisPlayListLabel {
            id: p_qcThisPlayListLable
            fontColor: if(musicLyricPage.isShow === true) return "#CFFFFFFF"
                else return "#"+ ThemeManager.theme.fontColor
            activeFontColor: if(musicLyricPage.isShow === true) return "#FFFFFFFF"
                else "#"+ ThemeManager.theme.iconColor
            backgroundColor: if(musicLyricPage.isShow === true) return "#2F000000"
                else  "#"+ ThemeManager.theme.backgroundColor
            labelColor: if(musicLyricPage.isShow === true) return "#2FFFFFFF"
                else "#10"+ ThemeManager.theme.iconColor
            labelHoverdColor: if(musicLyricPage.isShow === true) return "#4FFFFFFF"
                else "#1F"+ ThemeManager.theme.iconColor

        }

        Connections { // 保存操作信息
            target: window
            function onClosing(e) {
                windowPage.saveOperatingInfo()
            }
        }
        Component.onCompleted: { // 恢复操作信息
            regainOperatingInfo()
        }

        function saveOperatingInfo() { // 保存操作信息
            let operatingInfo = {
                "thisPlayListInfo": null, "thisPlayMusicInfo": null, "themeConfig": null,
            }
            let getThisPlayListInfo = ()=> { // 获取当前播放列表信息
                let thisPlayListInfo = p_music_Player.thisPlayListInfo
                return thisPlayListInfo
            }
            let getThisPlayMusicInfo = () => { // 获取当前播放音乐信息
                let thisPlayMusicInfo = {"musicInfo": {} , "playInfo": {}}
                if(p_music_Player.thisPlayListInfo.length > 0) {
                    thisPlayMusicInfo.musicInfo = p_music_Player.thisPlayListInfo[p_music_Player.thisPlayingCurrent]
                } else {
                    thisPlayMusicInfo.musicInfo = p_music_Player.thisPlayMusicInfo

                }
                thisPlayMusicInfo.playInfo = {
                    "position": p_music_Player.position,
                    "volume": p_music_Player.volume,
                    "playMode": p_music_Player.playMode,
                    "playingCurrent": p_music_Player.thisPlayingCurrent,
                }
                return thisPlayMusicInfo
            }

            let getThemeConfig = () => { // 获取当前主题配置信息
                let config = ThemeManager.config
                return config
            }

            operatingInfo.thisPlayListInfo = getThisPlayListInfo()
            operatingInfo.thisPlayMusicInfo = getThisPlayMusicInfo()
            operatingInfo.themeConfig = getThemeConfig()
//            console.log( "operatingInfo: "+ JSON.stringify(operatingInfo))
            QCTool.writeFile(windowPage.operatingInfoPath,JSON.stringify(operatingInfo))
        }
        function regainOperatingInfo() { // 恢复操作信息
            let operatingInfo = QCTool.readFile(windowPage.operatingInfoPath)
            try {
                operatingInfo = JSON.parse(operatingInfo)
                windowPage.operatingInfo = operatingInfo
                p_music_Player.thisPlayListInfo = operatingInfo.thisPlayListInfo
                p_music_Player.thisPlayingCurrent = operatingInfo.thisPlayMusicInfo.playInfo.playingCurrent
                p_music_Player.thisPlayMusicInfo = operatingInfo.thisPlayMusicInfo.musicInfo
                p_music_Player.position = operatingInfo.thisPlayMusicInfo.playInfo.position
                p_music_Player.volume = operatingInfo.thisPlayMusicInfo.playInfo.volume
                p_music_Player.playMode = operatingInfo.thisPlayMusicInfo.playInfo.playMode

                ThemeManager.config = operatingInfo.themeConfig
                ThemeManager.switchTheme(ThemeManager.config.name , ThemeManager.config.type)
                console.log(JSON.stringify(p_music_Player.thisPlayListInfo[p_music_Player.thisPlayingCurrent]))
            } catch(err) {
                console.log("operatingInfo: 保存操作错误 " + err)
                return
            }
        }
    }

}
