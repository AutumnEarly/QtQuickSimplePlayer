import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qc.window

DesktopLyric  {
    id: root
    property var parentWindow: null
    property var mediaPlayer: null
    property ListModel lyricData: ListModel {}

    property string family: "黑体"
    property string lyric: "播放歌词"
    property string textColor: "#00ACC1"

    property double fontSize: 18

    property int current: -1
    property bool isHoverd: false
    width: 700
    height: 120
    minimumWidth: width
    minimumHeight: height
    title: lyric
    color: "#00000000"
    onCurrentChanged: {
        if(current <= -1) return
        lyricText.text = lyricData.get(current).lyric
        tlrcText.text = lyricData.get(current).tlrc

        setContentMask(lyricContent.x+lyricColumn.x,lyricContent.y+lyricColumn.y)
    }
    onIsHoverdChanged: {
        if(isHoverd) {
            setFillMask(0,0,root.width,root.height)
        }else {
            setContentMask(lyricContent.x+lyricColumn.x,lyricContent.y+lyricColumn.y)
        }
    }
    Component.onCompleted: {
        if(current > 0) {
            lyricText.text = lyricData.get(current).lyric
            tlrcText.text = lyricData.get(current).tlrc
            setContentMask(lyricContent.x+lyricColumn.x,lyricContent.y+lyricColumn.y)
        }
        isHoverd = true
        hoverdTimeOut.restart()
    }

    Connections {
        target: parentWindow
        function onClosing(e) {
            close()
        }
    }
    Connections {
        enabled: visible &&  mediaPlayer != null
        target: mediaPlayer
        function onPositionChanged() {
            let tim = 0
            let index = 0
            let pos = mediaPlayer.position
            for(let i = 0; i < lyricData.count;i++) {
                if(pos >= lyricData.get(i).tim) {
                    if(i === lyricData.count-1) {
                       index = i
                       break
                    } else if(pos < lyricData.get(i+1).tim) {
                       index = i
                       break
                    }
                }
            }
            current = index
        }
    }

    Rectangle {
        id: lyricBackground
        width: root.width
        height: root.height
        radius: 5
        clip: true
        color: if(isHoverd) return "#AF000000"
        else return "#00000000"
        MouseArea {
            z: 99
            width: root.width
            height: root.height
            clip: true
            anchors.centerIn: parent
            propagateComposedEvents: true
            hoverEnabled: true
            cursorShape: Qt.OpenHandCursor
            onClicked: {
                isHoverd = true
                hoverdTimeOut.stop()
            }

            onExited: {
                hoverdTimeOut.restart()
            }
            Column {
                id: lyricContent
                width: root.width - 40
                height: root.height - 20
                clip: true
                anchors.centerIn: parent
                spacing: 5
                Row {
                    id: toolBar
                    width: 35 * children.length
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    QCToolTipButton {
                        width: 35
                        height: width
                        propagateComposedEvents: true
                        cursorShape: Qt.PointingHandCursor
                        iconSource: "qrc:/Images/prePlayer.svg"
                        hovredColor: "#4FFFFFFF"
                        iconColor: "#FFFFFFFF"
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
                        iconSource: if(p_music_Player.playbackState === 1) return "qrc:/Images/stop.svg"
                                    else return "qrc:/Images/player.svg"
                        hovredColor: "#4FFFFFFF"
                        iconColor: "#FFFFFFFF"
                        onClicked: function (mouse) {
                            mouse.accepted = false
                            if(p_music_Player.isPaused) {
                                p_music_Player.play()
                            } else {
                                p_music_Player.pause()
                            }
                        }
                    }
                    QCToolTipButton {
                        width: 35
                        height: width
                        propagateComposedEvents: true
                        cursorShape: Qt.PointingHandCursor
                        iconSource: "qrc:/Images/prePlayer.svg"
                        hovredColor: "#4FFFFFFF"
                        iconColor: "#FFFFFFFF"
                        transformOrigin: Item.Center
                        rotation: 180
                        onClicked: function (mouse) {
                            mouse.accepted = false
                            p_music_Player.nextMusicPlay()
                        }
                    }
                    Rectangle {
                        id: quitWindowBtn
                        property bool isHoverd: false
                        width: 35
                        height: width
                        radius: 100
                        anchors.verticalCenter: parent.verticalCenter
                        color: if(isHoverd) return "#4FFFFFFF"
                               else return "#00000000"
                        Rectangle {
                            width: parent.width/2
                            height: 3
                            border.color: "#FFFFFFFF"
                            anchors.centerIn: parent
                            rotation: 45
                            color: "#FFFFFFFF"
                        }
                        Rectangle {
                            width: parent.width/2
                            height: 3
                            border.color: "#FFFFFFFF"
                            anchors.centerIn: parent
                            rotation: -45
                            color: "#FFFFFFFF"
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                forceActiveFocus()
                                root.close()
                            }
                            onEntered: {
                                parent.isHoverd = true
                            }
                            onExited: {
                                parent.isHoverd = false
                            }
                        }
                    }

                }

                Column {
                    id: lyricColumn
                    property double maxChildWidth: lyricText.contentWidth
                    width: maxChildWidth
                    height: lyricText.height + tlrcText.height + spacing
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id: lyricText
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: text === "" ? 0 : contentHeight
                        font.pointSize: fontSize
                        font.family: family
                        font.bold: true
                        text: lyric
                        color: textColor
                        onContentWidthChanged: function (contentWidth) {
                            if(contentWidth > lyricColumn.maxChildWidth) {
                                lyricColumn.maxChildWidth = contentWidth
                            }
                        }
                        layer.enabled: true
                        layer.effect: LinearGradient  {
                            anchors.fill: lyricText
                            source: lyricText
                            start: Qt.point(0,0)
                            end: Qt.point(0,lyricText.contentHeight)
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#fbc2eb" }
                                GradientStop { position: 1.0; color: "#a18cd1" }
                            }
                        }

                    }
                    Text {
                        id: tlrcText
                        y: lyricText.height + parent.spacing
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: text === "" ? 0 : contentHeight
                        font.pointSize: fontSize - 2
                        font.family: family
                        font.bold: true
                        text: ""
                        color: textColor
                        layer.enabled: true
                        layer.effect: LinearGradient  {
                            anchors.fill: tlrcText
                            source: tlrcText
                            start: Qt.point(0,0)
                            end: Qt.point(0,tlrcText.contentHeight)
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#fbc2eb" }
                                GradientStop { position: 1.0; color: "#a18cd1" }
                            }
                        }
                        onContentWidthChanged: function (contentWidth) {
                            if(contentWidth > lyricColumn.maxChildWidth) {
                                lyricColumn.maxChildWidth = contentWidth
                            }
                        }
                    }
                }


            }


        }

    }

    Timer {
        id: hoverdTimeOut
        interval: 3000
        onTriggered: {
            isHoverd = false
        }

    }

    function setContentMask(stratX,stratY,spacing) {
        if(isHoverd) return
        var maskPos = []
        for(let i = 0; i < lyricColumn.children.length;i++) {

            var child = lyricColumn.children[i]
            if(child instanceof Text) {
                let newX = stratX+child.x
                let newY = stratY+child.y
//                console.log("child: " + child +" x " + child.x +" y " + child.y)
                maskPos.push({"x": newX,"y": newY,"w": child.contentWidth,"h": child.contentHeight})
            }
        }
        setFillMask(maskPos)
    }
}

