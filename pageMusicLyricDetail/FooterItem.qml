// FooterItem.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../qcComponent"
import "../../"

/*
    歌词详情页 尾部部分
*/


Item {
    id: footer
    property real iconSize: 50
    width: parent.width
    height: 90
//        color: "#AFFFFFFF"
    anchors.top: content.bottom
    Item {
        width: parent.width - 20
        height: parent.height - 15
        anchors.centerIn: parent
        Row {
            width: parent.width*.3
            height: 35
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

        }
        Item {
            width: 400
            height: 50
            anchors.centerIn: parent
            Row {
                height: 35
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                QCToolTipButton {
                    id: musicPlayModeIcon
                    width: 35
                    height: width
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                    iconSource: "qrc:/Images/loopPlay.svg"
                    hovredColor: "#4F000000"
                    iconColor: "#FFFFFF"
                    toolTip.border.color: "BLACK"
                    onClicked: function (mouse){
                        mouse.accepted = false
                        p_music_Player.setPlayerModel()
                    }
                    Component.onCompleted: {
                        selectPlayMode(p_music_Player.playMode)
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
                                musicPlayModeIcon.iconSource = "qrc:/Images/repeatSinglePlay.svg"
                            break
                            case QCMusicPlayer.PlayerMode.LOOPPLAY:
                                musicPlayModeIcon.iconSource = "qrc:/Images/loopPlay.svg"
                            break
                            case QCMusicPlayer.PlayerMode.RANDOMPLAY:
                                musicPlayModeIcon.iconSource = "qrc:/Images/randomPlay.svg"
                            break
                            case QCMusicPlayer.PlayerMode.PLAYLISTPLAY:
                                musicPlayModeIcon.iconSource = "qrc:/Images/playListPlay.svg"
                            break
                        }
                    }

                }
                QCToolTipButton {
                    width: 35
                    height: width
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                    iconSource: "qrc:/Images/prePlayer.svg"
                    hovredColor: "#4F000000"
                    iconColor: "#FFFFFF"
                    onClicked: function (mouse) {
                        mouse.accepted = false
                        p_music_Player.preMusicPlay()
                    }
                }
                QCToolTipButton {
                    width: 35
                    height: width
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                    color:  "#4F000000"
                    iconSource: if(!p_music_Player.isPaused) return "qrc:/Images/stop.svg"
                    else return "qrc:/Images/player.svg"
                    hovredColor: "#4F000000"
                    iconColor: "#FFFFFF"
                    transformOrigin: Item.Center
                    onClicked: function (mouse) {
                        mouse.accepted = false
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
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                    iconSource: "qrc:/Images/prePlayer.svg"
                    hovredColor: "#4F000000"
                    iconColor: "#FFFFFF"
                    transformOrigin: Item.Center
                    rotation: 180
                    onClicked: function (mouse) {
                        mouse.accepted = false
                        p_music_Player.nextMusicPlay()
                    }
                }
                QCToolTipButton {
                    id: desktopLyricBtn

                    width: 35
                    height: width
                    propagateComposedEvents: true
                    cursorShape: Qt.PointingHandCursor
                    iconSource: "qrc:/Images/lyric.svg"
                    hovredColor: "#4F000000"
                    iconColor: if(window.desktopLyric && window.desktopLyric.visible) return "#FFFFFFFF"
                    else return "#4F000000"
                    transformOrigin: Item.Center
                    rotation: 0
                    onClicked: function (mouse) {
                        mouse.accepted = false
                        if(window.desktopLyric === null) {
                            let cmp = Qt.createComponent("../../qcComponent/QCDesktopLyric.qml")
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

            Item {
                width: 400
                height: children[0].contentHeight
                anchors.bottom: parent.bottom
                Text {
                    font.pointSize: 8
                    text: p_musicRes.setAllTime(bottomBarSlider.value)
                    color: "#CFFFFFFF"
                }
                Slider {
                    id: bottomBarSlider
                    property bool isMovePressed: false
                    property bool isHoverd: false
                    width: parent.width - parent.children[0].contentWidth*2 - 10
                    height: 3
                    anchors.centerIn: parent
                    from: 0
                    to: p_music_Player.duration
                    value: p_music_Player.position
                    background: Rectangle {
                        transformOrigin: Item.Center
                        radius: width/2
                        color: bottomBarSlider.isHoverd ? "#7FFFFFFF" : "#4F000000"
                        Rectangle {
                            width: bottomBarSlider.visualPosition * parent.width
                            height: parent.height
                            radius: width/2
                            color: "#FF000000"
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                bottomBarSlider.height = 6
                                bottomBarSlider.isHoverd = true
                            }
                            onExited: {
                                bottomBarSlider.height = 4
                                bottomBarSlider.isHoverd = false
                            }
                        }
                    }
                    handle: Rectangle {
                        z: 2
                        id: handle
                        visible: bottomBarSlider.isHoverd
                        implicitWidth: 10
                        implicitHeight: width
                        x: (bottomBarSlider.availableWidth - width)*bottomBarSlider.visualPosition
                        y: -((height - bottomBarSlider.height)/2)
                        color: bottomBarSlider.pressed ? "#7F000000" : "#4E342E"
                        border.width: 2
                        border.color: "#CFFFFFFF"
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

                Text {
                    anchors.right: parent.right
                    font.weight: 1
                    font.pointSize: 8
                    text: p_musicRes.setAllTime(p_music_Player.duration)
                    color: "#CFFFFFFF"
                }

            }

        }

        Row {
            width: parent.width*.3
            height: 35
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            QCVolumeBtn {

                propagateComposedEvents: true
                cursorShape: Qt.PointingHandCursor
                textColor: "#FFFFFF"
                backgroundColor: "#4F000000"
                sliderBackgroundColor: "#7F000000"
                sliderColor: "#CF000000"
                handleBorderColor: "#FFFFFF"
                handleColor: "#AF000000"

                btnColor: "#00000000"
                btnHovredColor: "#4F000000"
                btnIconColor: "#FFFFFF"
            }

            QCToolTipButton {
                width: 35
                height: width
                propagateComposedEvents: true
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/playListPlay.svg"
                hovredColor: "#4F000000"
                iconColor: "#FFFFFF"
                onClicked: function (mouse) {
                    mouse.accepted = false
                    if(p_qcThisPlayListLable.visible) {

                        p_qcThisPlayListLable.close()
                    } else {
                        p_qcThisPlayListLable.startX = footer.width
                        p_qcThisPlayListLable.startY = footer.y - p_qcThisPlayListLable.height
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

