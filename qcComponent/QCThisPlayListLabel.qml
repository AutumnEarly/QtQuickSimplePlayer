import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./menu"
import "../theme"
import "../singletonComponent"

/*
    当前播放列表组件
*/
Item {
    id: qcThisPlayListLabel

    property var contentData: p_music_Player.thisPlayListInfo
    property int fontSize: 11
    property string activeFontColor: "WHITE"
    property string fontColor: "WHITE"
    property string backgroundColor: "#FAF2F1"
    property string labelColor: "WHITE"
    property string labelHoverdColor: "WHITE"

    property real startX: 0
    property real startY: 0

    width: 350
    height: 500
    x: startX
    y: startY
    visible: false
    opacity: 0

//    closePolicy: Popup.NoAutoClose
    Item { // 背景
        anchors.fill: parent
        Rectangle {
            id: popupBackground
            anchors.fill: parent
            radius: 8
            color: backgroundColor
        }
        DropShadow {
            z: -1
            width: popupBackground.width
            height: popupBackground.height
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8.0
            color: "#2F000000"
            source: popupBackground
        }
    }

    Item { // 内容
        width: parent.width
        height: parent.height
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onWheel: function (wheel) {

            }
        }
        ListView {
            id: qcThisPlayListLabelListView
            width: parent.width
            height: parent.height
            clip: true
            currentIndex: -1
            header: Item {
                width: qcThisPlayListLabel.width - 40
                height: children[0].height + 20
                anchors.horizontalCenter: parent.horizontalCenter
                Column {
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    width: parent.width
                    height: setHeight(children,spacing)
                    spacing: 10
                    Text {
                        width: parent.width
                        height: contentHeight
                        font.pointSize: fontSize + 2
                        wrapMode: Text.Wrap
                        color: fontColor
                        text: "当前播放 " + p_music_Player.thisPlayMusicInfo.name
                    }
                    Item {
                        width: parent.width
                        height: children[0].contentHeight
                        Text {
                            font.pointSize: fontSize
                            elide: Text.ElideRight
                            color: fontColor
                            text: "总共: " + p_music_Player.thisPlayListInfo.length
                        }
                        Text {
                            anchors.right: parent.right
                            font.pointSize: fontSize
                            elide: Text.ElideRight
                            color: fontColor
                            text: "清空列表"
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    p_music_Player.thisPlayMusicInfo = {
                                        "id":"",
                                        "name":"",
                                        "artists": [{"id":"","name":""}],
                                        "album": {"id":"","name":""},
                                        "coverImg":"",
                                        "url":"",
                                        "allTime":"00:00",
                                    }
                                    p_music_Player.thisPlayingCurrent = -1
                                    p_music_Player.thisPlayListInfo = []
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        radius: width/2
                        color: fontColor
                    }
                }


            }
            model: contentData.length

            delegate: listViewDelegate

            onCurrentIndexChanged: {
                if(currentItem != null) {
                    puausePlayIcon.parent = itemAtIndex(currentIndex)
                } else {
                    puausePlayIcon.parent = this
                }
                console.log("index: "+ currentIndex +" currentItem" +itemAtIndex(currentIndex))
            }
            Component.onCompleted: {
                if(currentItem != null) {
                   puausePlayIcon.parent = currentItem
                } else {
                    puausePlayIcon.parent = this
                }
            }

            Connections {
                target: p_music_Player
                function onThisPlayingCurrentChanged() {
                    qcThisPlayListLabelListView.currentIndex = p_music_Player.thisPlayingCurrent
                }
            }
        }

    }
    Component { // listView委托项
        id: listViewDelegate
        Rectangle {
            property bool isHoverd: false
            property string fontColor: if(p_music_Player.thisPlayingCurrent === index) return activeFontColor
            else return qcThisPlayListLabel.fontColor

            width: qcThisPlayListLabel.width
            height: children[0].height
            color: if(isHoverd) return labelHoverdColor
                   else if(index % 2) return backgroundColor
                   else return labelColor

            MouseArea{
                width: qcThisPlayListLabel.width
                height: children[0].height + 15
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                hoverEnabled: true
                onDoubleClicked: {
                    p_music_Player.thisPlayingCurrent = index
                    p_music_Player.playMusic(contentData[index].id,p_music_Player.thisPlayListInfo[index])
                    console.log("当前index: " + index)
                }
                onClicked: function (mouse){
                    if(mouse.button === Qt.RightButton) {
                        rightMenu.playListCurrent = index
                        rightMenu.parent = this
                        rightMenu.x = mouseX
                        rightMenu.y = mouseY
                        rightMenu.open()
                    }
                }

                onExited: {
                    parent.isHoverd = false
                }
                onEntered: {
                    parent.isHoverd = true
                }
                Row {
                    width: parent.width - 40
                    height: children[0].contentHeight
                    anchors.centerIn: parent
                    spacing: 10
                    Text {
                        width: parent.width * .3
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: fontSize - 1
                        elide: Text.ElideRight
                        text: contentData[index].name
                        color: fontColor
                    }
                    Row {
                        id: artistsList
                        property int thisIndex: index
                        width: parent.width *.3

                        clip: true
                        spacing: 0
                        anchors.verticalCenter: parent.verticalCenter
                        Repeater {
                            id: artistsRepeater
                            model: contentData[artistsList.thisIndex].artists.length
                            delegate: Text {
                                id: artistsText
                                property int currentIndex: index
                                property bool isHoverd: false
                                height: contentHeight
                                anchors.verticalCenter: parent.verticalCenter
                                font.weight: 2
                                font.pointSize: fontSize - 1
                                text: if(index === contentData[artistsList.thisIndex].artists.length - 1) return contentData[artistsList.thisIndex].artists[index].name
                                else return contentData[artistsList.thisIndex].artists[index].name + " / "
                                color: fontColor

                                Connections {
                                    target: artistsList
                                    function onWidthChanged() {
                                        artistsText.surplusWidth()
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        let lb = leftBar
                                        let rc = rightContent
                                        let getArtistInfo = contentData[artistsList.thisIndex].artists[index]
                                        if(getArtistInfo.id === "") return

                                        var func = () => {
                                            lb.thisBtnText = ""
                                            rc.thisQml = "pageQml/PageArtistsDetail.qml"
                                            rc.item.getArtistInfo = getArtistInfo
                                        }
                                        func()
                                        rightContent.push({callBack:func,name: "artist: "+lb.thisBtnText ,data: {}})
                                    }

                                    onEntered: {
                                        parent.isHoverd = true
                                    }
                                    onExited: {
                                        parent.isHoverd = false
                                    }
                                }

                                function surplusWidth() {

                                    let ch = null
                                    let allWidth = 0
                                    for(let i = 0; i <= artistsText.currentIndex;i++) {
                                        allWidth += artistsRepeater.itemAt(i).contentWidth
                                    }
                                    let surplusW = artistsList.width - allWidth
                                    if(surplusW >= 0) {
                                        elide = Text.ElideNone
                                        width = contentWidth
                                    } else {

                                        if(width - Math.abs(surplusW) < width) {
                                            elide = Text.ElideRight
                                            width = width - Math.abs(surplusW)
                                        } else {
                                            width = 0
                                        }

                                    }
                                }
                            }
                            Component.onCompleted:  {
                                artistsList.height = itemAt(0).height
                            }

                        }

                    }
                    MouseArea {
                        property bool isHoverd: false
                        width: parent.width *.2
                        height: children[0].height
                        anchors.verticalCenter: parent.verticalCenter
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            let lb = leftBar
                            let rc = rightContent
                            let getAlbumInfo = contentData[artistsList.thisIndex].album
                            if(getAlbumInfo.id === "") return

                            var func = () => {
                                lb.thisBtnText = ""
                                rc.thisQml = "pageQml/PageMusicAlbumDetail.qml"
                                rc.item.getAlbumInfo = getAlbumInfo
                            }
                            func()
                            rightContent.push({callBack:func,name:"album: "+lb.thisBtnText ,data: {}})
                        }

                        onEntered: {
                            isHoverd = true
                        }
                        onExited: {
                            isHoverd = false
                        }
                        Text {
                            width: parent.width
                            height: contentHeight
                            horizontalAlignment: Text.AlignLeft
                            anchors.verticalCenter: parent.verticalCenter
                            font.pointSize: fontSize - 1
                            font.weight: 2
                            elide: Text.ElideRight
                            text: contentData[index].album.name
                            color: fontColor
                        }
                    }

                    Text {
                        width: parent.width *.2-30
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: fontSize - 2
                        elide: Text.ElideRight
                        text: contentData[index].allTime
                        color: fontColor
                    }
                }
            }


        }

    }

    ParallelAnimation { // 显示动画
        id: openAni
        NumberAnimation {
            target: qcThisPlayListLabel
            property: "x"
            duration: 500
            easing.type: Easing.InOutCubic
            to: qcThisPlayListLabel.startX - qcThisPlayListLabel.width - 20
        }
        NumberAnimation {
            target: qcThisPlayListLabel
            property: "opacity"
            duration: 500
            easing.type: Easing.InOutCubic
            to: 1
        }
        onStarted: {
            qcThisPlayListLabel.visible = true
        }
    }

    ParallelAnimation { // 隐藏动画
        id: closeAni
        NumberAnimation {
            target: qcThisPlayListLabel
            property: "x"
            duration: 500
            easing.type: Easing.InOutCubic
            to: qcThisPlayListLabel.startX
        }
        NumberAnimation {
            target: qcThisPlayListLabel
            property: "opacity"
            duration: 500
            easing.type: Easing.InOutCubic
            to: 0
        }
        onStopped: {
            qcThisPlayListLabel.visible = false
        }
    }


    QCImage {
        id: puausePlayIcon
        width: 15
        height: width
        visible: qcThisPlayListLabelListView.currentIndex >= 0
        anchors.verticalCenter: parent.verticalCenter
        source: if(p_music_Player.playbackState === 1) return "qrc:/Images/stop.svg"
        else return "qrc:/Images/player.svg"
        color: activeFontColor
    }
    Text { // 提示信息
        visible: p_music_Player.thisPlayListInfo.length  <=0
        anchors.centerIn: parent
        font.pointSize: fontSize + 2
        elide: Text.ElideRight
        color: fontColor
        text: "当前还未添加任何歌曲!"
    }

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
                let cmp = Qt.createComponent("QCSelectAddPlayListPopup.qml")
                if(cmp.status === Component.Ready) {
                    cmp = cmp.createObject(windowPage)
                    cmp.musicInfo = p_music_Player.thisPlayListInfo[rightMenu.playListCurrent]
                    cmp.open()
                }
            }

        }

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
        MenuSeparator{}
        QCMenuItem { // 从列表中移除音乐
            width: rightMenu.width
            text: "从列表中删除"
            textColor: "#"+ ThemeManager.theme.fontColor
            icon.source: "qrc:/Images/delete.svg"
            icon.color: "#"+ ThemeManager.theme.iconColor
            background: Rectangle {
               color: parent.highlighted ? "#1F"+ ThemeManager.theme.iconColor : "#00000000"
            }
            onClicked: {
                remove()
            }
            function remove() {
                if(rightMenu.playListCurrent >= 0) {
                    let isPlay = !p_music_Player.isPaused
                    let current = p_music_Player.thisPlayingCurrent
                    rightMenu.parent = qcThisPlayListLabelListView
                    rightMenu.close()

                    if(p_music_Player.thisPlayListInfo.length -1 > 0) {
                        if(rightMenu.playListCurrent === current ) {
                            if(current === 0) {
                                p_music_Player.thisPlayMusicInfo = p_music_Player.thisPlayListInfo[current+1]
                            } else if(current === p_music_Player.thisPlayListInfo.length -1) {
                                p_music_Player.thisPlayMusicInfo = p_music_Player.thisPlayListInfo[--current]
                            } else {
                                p_music_Player.thisPlayMusicInfo = p_music_Player.thisPlayListInfo[current+1]
                            }
                        } else if(rightMenu.playListCurrent < current) {
                            -- current
                        }
                    } else {
                        p_music_Player.thisPlayMusicInfo = {
                                                        "id":"",
                                                        "name":"",
                                                        "artists":[],
                                                        "album": {},
                                                        "coverImg":"",
                                                        "url":"",
                                                        "allTime":"00:00",
                                                        }
                        current = -1
                    }
                    if(isPlay) {
                        p_music_Player.playMusic(p_music_Player.thisPlayMusicInfo.id,p_music_Player.thisPlayMusicInfo)
                    }

                    p_music_Player.thisPlayListInfo.splice(rightMenu.playListCurrent ,1)
                    p_music_Player.thisPlayListInfoChanged()
                    p_music_Player.thisPlayingCurrent = current
                    p_music_Player.thisPlayingCurrentChanged()

                }
            }
        }
    }

    function open() {
        openAni.restart()
    }
    function close() {
        closeAni.restart()
    }

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
        return h
    }

}


