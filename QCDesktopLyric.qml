pragma Singleton
import QtQuick
import qc.window

Window {
    id: root
    property var mediaPlayer: null
    property ListModel lyricData: ListModel {}

    property string family: "黑体"
    property string lyric: "播放歌词"
    property string textColor: "#00ACC1"


    property double fontSize: 15
    property double lastX: 700.
    property double lastY: 500.

    property int current: -1
    property bool isHoverd: false
    width: lyricContent.width
    height: lyricContent.height
    minimumWidth: width
    minimumHeight: height
    title: lyric
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "#00000000"

    onCurrentChanged: {

        lyricText.text = lyricData.get(current).lyric
        tlrcText.text = lyricData.get(current).tlrc
        console.log("当前播放歌词: " + lyricText.text + " 翻译: " +lyricData.get(current).tlrc)
        setCenterPoint()
    }

    function setCenterPoint() {
        let lx = (root.x + lyricColumn.width)
        let ly = (root.y + lyricColumn.height)
        let offsetx = 0
        let offsety = 0
        if(lastX - lx > 0) {
            root.x += lastX - lx
        } else {
            root.x -= lx - lastX
        }


        lx = (root.x + lyricColumn.width)
        console.log("中心点: " + lastX +" y" + lastY)
        console.log("初始位置：" + lx +" " + ly)
    }

    Connections {
        enabled: visible && mediaPlayer != null
        target: mediaPlayer

        function onPositionChanged(pos) {
            let tim = 0
            let index = 0
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
        id: lyricContent
        width: lyricColumn.width
        height: lyricColumn.height
        anchors.centerIn: parent
        color: if(isHoverd) return "#3F000000"
        else return "#00000000"

        Item {
            width: lyricColumn.width
            height: lyricColumn.height
            anchors.centerIn: parent
            Column {
                id: lyricColumn
                property double maxChildWidth: lyricText.contentWidth
                width: maxChildWidth
                height: lyricText.height + tlrcText.height + spacing
                anchors.centerIn: parent
                spacing: 5
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
                        if(contentWidth > lyricContent.maxChildWidth) {
                            lyricContent.maxChildWidth = contentWidth
                        }
                    }
                }
                Text {
                    id: tlrcText
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: text === "" ? 0 : contentHeight
                    font.pointSize: fontSize
                    font.family: family
                    font.bold: true
                    text: ""
                    color: textColor
                    onContentWidthChanged: function (contentWidth) {
                        if(contentWidth > lyricContent.maxChildWidth) {
                            lyricContent.maxChildWidth = contentWidth
                        }
                    }
                }
            }
            MouseArea {
                property var click_pos: Qt.point(0,0)
                anchors.fill: parent
                propagateComposedEvents: true
                hoverEnabled: true
                cursorShape: Qt.OpenHandCursor
                onPositionChanged: function (mouse) {
                    if(!root.startSystemMove()) { // 启用系统自带的拖拽功能
                        var offset = Qt.point(mouseX - click_pos.x,mouseY - click_pos.y)
                        root.x += offset.x
                        root.y += offset.y
                    } else {

                    }
                }
                onPressedChanged: function (mouse) {
                    click_pos = Qt.point(mouseX,mouseY)
                    console.log("winX: " + root.x + " winY: " + root.y + " x: " + parent.x + " y: " + parent.y)
                }
                onReleased: {

                }

                onEntered: {
                    isHoverd = true
                }
                onExited: {
                    lastX = (root.x + lyricColumn.width)
                    lastY = (root.y + lyricColumn.height)
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


}

