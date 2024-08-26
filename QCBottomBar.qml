import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "./qcComponent"
import "./theme"
import "./singletonComponent"

Rectangle {
    id: bottomBar
    property QCTheme thisTheme: ThemeManager.theme
    property int fontSize: 11
    property string fontFamily: "黑体"
    width: parent.width
    height: 80
    color: "#"+ thisTheme.backgroundColor

    function setHeight(children,spacing) {
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

    Slider {
        id: bottomBarSlider
        property bool isMovePressed: false
        width: parent.width
        height: 5
        from: 0
        to: p_music_Player.duration
        anchors.bottom: parent.top
        background: Rectangle {
            color: "#1F" + thisTheme.iconColor
            Rectangle {
                width: p_music_Player.bufferProgress * parent.width
                height: parent.height
                color: "#2F" + thisTheme.iconColor
            }
            Rectangle {
                width: bottomBarSlider.visualPosition * parent.width
                height: parent.height
                color: "#FF" + thisTheme.iconColor
            }


            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    bottomBarSlider.height = 8
                }
                onExited: {
                    bottomBarSlider.height = 5
                }
            }
        }
        handle: Rectangle {
            z: 2
            id: handle
            implicitWidth: 20
            implicitHeight: width
            x: (bottomBarSlider.availableWidth - width)*bottomBarSlider.visualPosition
            y: -((height - bottomBarSlider.height)/2)
            color: bottomBarSlider.pressed ? "#" + thisTheme.iconColor :  "#"+ thisTheme.iconColor_2
            border.width: 1.5
            border.color: "#" + thisTheme.iconColor
            radius: 100
        }

        onMoved: {
            isMovePressed = true
        }
        onPressedChanged: {

            if(isMovePressed && pressed === false) {
                p_music_Player.position = value
                isMovePressed = pressed
            }
        }

        Connections {
            target: p_music_Player
            enabled: !bottomBarSlider.pressed
            function onPositionChanged() {
                bottomBarSlider.value = p_music_Player.position
            }
        }
    }

    Item {
        width: parent.width - 20
        height: parent.height - 15
        anchors.centerIn: parent

        Row {
            id: bottomBarLeft
            width: parent.width*.3
            height: parent.height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            visible: p_music_Player.thisPlayMusicInfo.name
            RoundImage {
                id: bottomBarCoverImg
                width: parent.height
                height: width
                source: p_music_Player.thisPlayMusicInfo.coverImg +"?thumbnail=" + width + "y" + height
                visible: p_music_Player.thisPlayMusicInfo.coverImg
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(musicLyricPage.isShow) {
                            musicLyricPage.hidePage()
                        } else {
                            musicLyricPage.showPage()
                        }
                    }
                }
            }
            Column {
                width: parent.width - bottomBarCoverImg.width - parent.spacing*2
                anchors.verticalCenter: bottomBarCoverImg.verticalCenter
                spacing: 3
                Row { // 歌曲名 喜欢按钮
                    width: parent.width
                    height: 35
                    spacing: 5
                    MouseArea {
                        property real maxWidth: parent.width - 35
                        width: nameList.minWidth > maxWidth ? maxWidth : nameList.minWidth
                        height: children[0].height
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            if(musicLyricPage.isShow) {
                                musicLyricPage.hidePage()
                            } else {
                                musicLyricPage.showPage()
                            }
                        }

                        onEntered: {
                            if(nameList.minWidth > maxWidth) {
                                bottomBarNameTextAni.to = nameList.itemAtIndex(1).x
                                bottomBarNameTextAni.duration = 4000
                                bottomBarNameTextAni.start()
                            }

                        }
                        ListView {
                            id: nameList
                            property real minWidth: contentWidth/2 - spacing/2
                            width: contentWidth
                            spacing: 20
                            model: 2
                            orientation: ListView.Horizontal
                            delegate: Text {
                                id: bottomBarNameText
                                width: contentWidth
                                height: contentHeight
                                font.pointSize: bottomBar.fontSize
                                text: p_music_Player.thisPlayMusicInfo.name
                                color: "#"+ thisTheme.fontColor
                                onContentHeightChanged: function (contentHeight){
                                    nameList.height = contentHeight
                                }
                            }
                        }

                        Connections {
                            target: p_music_Player
                            function onThisPlayMusicInfoChanged() {
                                bottomBarNameTextAni.stop()
                                favoriteBtn.isFavorite = FavoriteManager.favoriteIndexOf(p_music_Player.thisPlayMusicInfo.id) < 0 ? false : true
                            }
                        }
                        NumberAnimation {
                            id: bottomBarNameTextAni
                            target: nameList
                            property: "contentX"
                            from: 0
                            easing.type: Easing.Linear
                            onStopped: {
                                nameList.contentX = 0
                            }
                        }


                    }
                    QCToolTipButton {
                        id: favoriteBtn
                        property bool isFavorite: false
                        width: 35
                        height: width
                        cursorShape: Qt.PointingHandCursor
                        iconSource: if(isFavorite) return "qrc:/Images/myFavorite2.svg"
                        else return "qrc:/Images/myFavorite.svg"
                        iconColor: "#"+ thisTheme.iconColor
                        hovredColor: "#00000000"
                        color: "#00000000"
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            let id = p_music_Player.thisPlayMusicInfo.id
                            if(isFavorite) {
                                isFavorite = false
                                FavoriteManager.remove(id)
                                iconSource = "qrc:/Images/myFavorite.svg"
                            } else {
                                isFavorite = true
                                FavoriteManager.append(p_music_Player.thisPlayMusicInfo)
                                iconSource = "qrc:/Images/myFavorite2.svg"
                            }
                        }
                        Component.onCompleted: {
                            isFavorite = FavoriteManager.favoriteIndexOf(p_music_Player.thisPlayMusicInfo.id) < 0 ? false : true
                        }
                    }

                    Connections {
                        target: p_music_Player
                        function onThisPlayMusicInfoChanged() {
                            favoriteBtn.isFavorite = FavoriteManager.favoriteIndexOf(p_music_Player.thisPlayMusicInfo.id) < 0 ? false : true
                        }
                    }
                }

                MouseArea { // 作者名
                    property real maxWidth: parent.width
                    property real childWidth: children[0].width
                    width: artistsLists.minWidth > maxWidth ? maxWidth : artistsLists.minWidth
                    height: artistsLists.height
                    hoverEnabled: true
                    clip: true
                    onEntered: {
                        if(artistsLists.minWidth > maxWidth) {
                            bottomBarArtistTextAni.to = artistsLists.itemAtIndex(1).x
                            bottomBarArtistTextAni.duration = 4000
                            bottomBarArtistTextAni.start()
                        }
                    }
                    ListView {
                        id: artistsLists
                        property real minWidth: contentWidth / 2 - spacing/2
                        width: contentWidth
                        model: 2
                        spacing: 20
                        orientation: ListView.Horizontal
                        delegate: Row {
                            id: artistsList
                            clip: true
                            spacing: 0
                            anchors.verticalCenter: parent.verticalCenter
                            Repeater {
                                id: repeater
                                model: p_music_Player.thisPlayMusicInfo.artists
                                delegate: Text {
                                    id: artistsText
                                    property int currentIndex: index
                                    property bool isHoverd: false
                                    width: contentWidth
                                    height: contentHeight
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.weight: 2
                                    font.pointSize: fontSize - 1
                                    text: if(index === p_music_Player.thisPlayMusicInfo.artists.length - 1) return p_music_Player.thisPlayMusicInfo.artists[index].name
                                    else return p_music_Player.thisPlayMusicInfo.artists[index].name + " / "
                                    color: isHoverd ? "#"+ thisTheme.fontColor : "#AF"+ thisTheme.fontColor

                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            let lb = leftBar
                                            let rc = rightContent
                                            let getArtistInfo = p_music_Player.thisPlayMusicInfo.artists[index]
                                            var func = () => {
                                                lb.thisBtnText = ""
                                                rc.thisQml = "pageQml/PageArtistsDetail.qml"
                                                rc.item.getArtistInfo = getArtistInfo
                                            }
                                            func()
                                            rightContent.push({callBack:func,name:"artist: "+ getArtistInfo.name ,data: {}})
                                        }
                                        onEntered: {
                                            parent.isHoverd = true
                                        }
                                        onExited: {
                                            parent.isHoverd = false
                                        }
                                    }
                                }
                                onCountChanged: {
                                    let w = 0
                                    let h = 0
                                    for(let i = 0; i < count;i++) {
                                        w += itemAt(i).width
                                        if(itemAt(i).height > h) {
                                            h = itemAt(i).height
                                        }
                                    }
                                    artistsList.width = w
                                    artistsList.height = h
                                    artistsLists.height = h
                                }

                            }

                        }
                    }

                    NumberAnimation {
                        id: bottomBarArtistTextAni
                        target: artistsLists
                        property: "contentX"
                        duration: 0
                        from: 0
                        easing.type: Easing.Linear
                        onStopped: {
                            artistsLists.contentX = 0
                        }
                    }
                    Connections {
                        target: p_music_Player
                        function onThisPlayMusicInfoChanged() {
                            bottomBarArtistTextAni.stop()
                        }
                    }

                }

                Component.onCompleted: {
                    var h = 0
                    for(var i = 0; i < children.length;i++) {
                        if(children[i] instanceof Text) {
                            h += children[i].contentHeight
                        } else h += children[i]
                    }
                    height = h + spacing
                }
            }
        }

        Row {
            width: parent.width*.3
            height: 35
            anchors.centerIn: parent
            spacing: 10
            QCToolTipButton {
                id: musicPlayModeIcon
                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/loopPlay.svg"
                hovredColor: "#0F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                toolTip.border.color: "BLACK"
                onClicked: function (mouse){
                    p_music_Player.setPlayerModel()
                }
                Component.onCompleted: {
                    musicPlayModeIcon.selectPlayMode(p_music_Player.playMode)
                }

                Connections {
                    target: p_music_Player
                    function onPlayModeChanged () {
                        musicPlayModeIcon.selectPlayMode(p_music_Player.playMode)
                    }
                }
                function selectPlayMode(mode) {
                    switch(mode) {
                        case QCMusicPlayer.PlayerMode.ONELOOPPLAY:
                            musicPlayModeIcon.text = "单曲循环"
                            musicPlayModeIcon.iconSource = "qrc:/Images/repeatSinglePlay.svg"
                        break
                        case QCMusicPlayer.PlayerMode.LOOPPLAY:
                            musicPlayModeIcon.text = "列表循环"
                            musicPlayModeIcon.iconSource = "qrc:/Images/loopPlay.svg"
                        break
                        case QCMusicPlayer.PlayerMode.RANDOMPLAY:
                            musicPlayModeIcon.text = "随机播放"
                            musicPlayModeIcon.iconSource = "qrc:/Images/randomPlay.svg"
                        break
                        case QCMusicPlayer.PlayerMode.PLAYLISTPLAY:
                            musicPlayModeIcon.text = "顺序播放"
                            musicPlayModeIcon.iconSource = "qrc:/Images/playListPlay.svg"
                        break
                    }
                }

            }
            QCToolTipButton {
                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/prePlayer.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                onClicked: function (mouse) {
                    p_music_Player.preMusicPlay()
                }
            }
            QCToolTipButton {
                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                color: "#" +thisTheme.iconColor
                iconSource: if(!p_music_Player.isPaused) return "qrc:/Images/stop.svg"
                else return "qrc:/Images/player.svg"
                hovredColor: "#" + thisTheme.iconColor
                iconColor: "#"+ thisTheme.iconColor_2
                transformOrigin: Item.Center
                onClicked: function (mouse) {
                    if(p_music_Player.isPaused) {
                        p_music_Player.play()
                    } else {
                        p_music_Player.pause()
                    }
                }
                onEntered: {
                    scale = 1.2
                }
                onExited: {
                    scale = 1
                }

                Behavior on scale {
                    ScaleAnimator {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            QCToolTipButton {
                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/prePlayer.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                transformOrigin: Item.Center
                rotation: 180
                onClicked: function (mouse) {
                    p_music_Player.nextMusicPlay()
                }
            }
            QCToolTipButton {
                id: desktopLyricBtn

                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/lyric.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: if(window.desktopLyric && window.desktopLyric.visible) return "#" +thisTheme.iconColor
                else return "#7F" +thisTheme.iconColor
                transformOrigin: Item.Center
                rotation: 0
                onClicked: function (mouse) {
                    if(window.desktopLyric === null) {
                        let cmp = Qt.createComponent("./qcComponent/QCDesktopLyric.qml")
                        if(cmp.status === Component.Ready) {
                            window.desktopLyric = cmp.createObject()
                            window.desktopLyric.parentWindow = window

                            window.desktopLyric.lyricData = p_music_Player.thisMusicLyric
                            window.desktopLyric.mediaPlayer = p_music_Player
                            window.desktopLyric.show()

                        } else {
                            console.log("歌词加载失败！"+cmp.errorString())
                        }
                    } else if(window.desktopLyric.visible) {
                        window.desktopLyric.close()
                    } else {
                        window.desktopLyric.show()
                    }
                }
            }
            Component.onCompleted: {
                var w = 0
                for(var i = 0; i < children.length;i++) {
                    if(children[i] instanceof Text) {
                        w += children[i].contentWidth
                    } else w += children[i].width
                }
                width = w + children.length * spacing - spacing
            }
        }

        Row {
            width: parent.width*.3
            height: 35
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Row {
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    font.family: bottomBar.fontFamily
                    font.weight: 1
                    font.pointSize: bottomBar.fontSize
                    text: p_musicRes.setAllTime(bottomBarSlider.value)
                    color: "#"+ thisTheme.fontColor
                }
                Text {
                    font.family: bottomBar.fontFamily
                    font.weight: 1
                    font.pointSize: bottomBar.fontSize
                    text: "/" + p_musicRes.setAllTime(p_music_Player.duration)
                    color: "#"+ thisTheme.fontColor
                }
            }

            QCVolumeBtn {

                propagateComposedEvents: true
                cursorShape: Qt.PointingHandCursor
                textColor: "#FF" + thisTheme.iconColor
                backgroundColor: "#"+ thisTheme.iconColor_2
                sliderBackgroundColor: "#3F" + thisTheme.iconColor
                sliderColor: "#FF" + thisTheme.iconColor
                handleBorderColor: "#FF" + thisTheme.iconColor
                handleColor: "#"+ thisTheme.iconColor_2
                btnColor: "#00000000"
                btnHovredColor: "#1F" + thisTheme.iconColor
                btnIconColor: "#FF" + thisTheme.iconColor
            }

            QCToolTipButton {
                width: 35
                height: width
                propagateComposedEvents: true
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/playList.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                onClicked: function (mouse) {
                    mouse.accepted = false
                    if(p_qcThisPlayListLable.visible) {
                        isHighlight = false
                        p_qcThisPlayListLable.close()
                    } else {
                        isHighlight = true
                        p_qcThisPlayListLable.startX = bottomBar.width
                        p_qcThisPlayListLable.startY = bottomBar.y - p_qcThisPlayListLable.height
                        p_qcThisPlayListLable.open()

                    }
                }
            }
            Component.onCompleted: {
                var w = 0
                for(var i = 0; i < children.length;i++) {
                    if(children[i] instanceof Text) {
                        w += children[i].contentWidth
                    } else w += children[i].width
                }
                width = w + children.length * spacing - spacing
            }
        }

    }

}
