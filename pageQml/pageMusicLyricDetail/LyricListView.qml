// LyricListView.qml
import QtQuick
import QtQuick.Controls
import "../../qcComponent"

/*
    歌词详情页 歌词详情
*/

Item {
    id: lyricItemRoot
    property var mediaPlayer: null // 播放源
    property var lyricData: ListModel{}

    property string coverImg: ""
    property string textColor: "#FFFFFF"
    property string contentItemColor: "000000"
    property string scroolBarColor: "1F000000"

    property double contItemMaxScale: 1.2
    property double contItemMinScale: 0.9

    property alias currentIndex: listView.currentIndex

    property int fontSize: 17
    property int current: -1
    property int delayFollow: 10000 //  等待多久跟随播放歌词
    property bool isFollow: true // 是否跟随正在播放的歌词

    Component.onCompleted: {
        mediaPlayer.positionChanged()
    }

    onIsFollowChanged: {
        console.log("当前是否跟随: " + isFollow)
    }
    onCurrentChanged: {

        var lrc =  lyricData.get(current).lyric
        var tlrc = lyricData.get(current).tlrc
        if(isFollow) listView.currentIndex = current
    }

    function setScaleOffset(index,currentIndex) { // 设置委托项缩放
        var offset = Math.abs(index - currentIndex)
        if(offset > 3) offset = 4
        return  contItemMaxScale - offset/10.
    }
    function setBlurOffset(index) { // 设置委托项模糊
        var offset = Math.abs(index - currentIndex)
        if(offset > 3) offset = 3
        return  15*offset
    }

    Connections {
        enabled: mediaPlayer != null
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
//            console.log(pos)
        }
    }

    MouseArea { // 每次滑动数量
        anchors.fill: lyricItemRoot
        onWheel: function (wheel) {
            var wy =  wheel.angleDelta.y
            if(wy < 0 && lyricItemRoot.currentIndex < listView.count-1) {
                lyricItemRoot.currentIndex += 1

            } else if(wy > 0 && lyricItemRoot.currentIndex > 0) {
                lyricItemRoot.currentIndex -= 1
            }
            lyricItemRoot.isFollow = false
            lyricTimer.restart()
        }
    }
    ListView { // 歌词视图
        id: listView

        width: parent.width - 30
        height: parent.height
        anchors.centerIn: parent
        clip: true
        currentIndex: 0
        interactive: false
        highlightMoveDuration: 500
        preferredHighlightBegin: parent.height / 2-40
        preferredHighlightEnd: parent.height / 2
        highlightRangeMode: ListView.StrictlyEnforceRange
        spacing: 15
        model: lyricData

        delegate: lyricDelegate
        populate: Transition {
            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1.0
                duration: 1000
            }
        }
        move: Transition {
                NumberAnimation {

                    property: "y"
                    duration: 400
                    easing.type: Easing.OutQuart
                    onRunningChanged: {
                        console.log("AA")
                    }
                }
        }

        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor:  "#"+ scroolBarColor
        }
    }

    Timer { // 歌词跟随
        id: lyricTimer
        interval: 10000
        onTriggered: {
            lyricItemRoot.isFollow = true
        }
    }
    Component { // 等待委托项
        id: delayCmp
        Rectangle {
            width: 200
            height: 80
        }
    }

    Component { // 歌词委托项
        id: lyricDelegate
        Rectangle {
            id: lyricItem
            property bool isHoverd: false
            property double offsetScale: lyricItemRoot.setScaleOffset(index,currentIndex)
            property double maxWidth: lyricItemRoot.width * .6
            property int blur: lyricItemRoot.setBlurOffset(index)
            width: children[0].width
            height: children[0].height
            radius: 12
            transformOrigin: Item.Left
            scale: offsetScale
            color: if(isHoverd) return "#2F" + lyricItemRoot.contentItemColor
            else return "#00000000"

            Behavior on scale {

                NumberAnimation {
                    property: "scale"
                    duration: 500
                    easing.type: Easing.OutQuart
                }

            }

            Behavior on color {
                ColorAnimation {
                    duration: 350
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                id: lyricBack
                width: children[0].width + 30
                height: children[0].height + 30
                color: "#00000000"
                Column {
                    id: textColumn

                    property double childMaxWidth: children[0].contentWidth
                    anchors.centerIn: parent
                    width: childMaxWidth > lyricItem.maxWidth ? lyricItem.maxWidth : childMaxWidth
                    height: children[0].height + children[1].height + spacing
                    spacing: 10

                    Text {
                        width: parent.width
                        height: text === "" ? 0 : contentHeight
                        font.pointSize: lyricItemRoot.fontSize
                        font.bold: lyricItemRoot.current === index
                        wrapMode: Text.Wrap
                        text: lyric
                        color: if(lyricItemRoot.current === index) return lyricItemRoot.textColor
                        else return "#70FFFFFF"

                        Behavior on color {
                            ColorAnimation {
                                duration: 300
                                easing.type: Easing.Linear
                            }
                        }
                        onContentWidthChanged: function(contentWidth) {
                            if(contentWidth > parent.childMaxWidth) {
                                parent.childMaxWidth = contentWidth
                            }
                        }
                    }
                    Text {
                        width: parent.width
                        height: text === "" ? 0 : contentHeight
                        font.pointSize: lyricItemRoot.fontSize
                        font.bold: lyricItemRoot.current === index
                        wrapMode: Text.Wrap
                        text: tlrc
                        color: if(lyricItemRoot.current === index) return lyricItemRoot.textColor
                        else return "#70FFFFFF"
                        Behavior on color {
                            ColorAnimation {
                                duration: 300
                                easing.type: Easing.Linear
                            }
                        }
                        onContentWidthChanged: function(contentWidth) {
                            if(contentWidth > parent.childMaxWidth) {
                                parent.childMaxWidth = contentWidth
                            }
                        }
                    }
                }

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if(mediaPlayer) {
                        mediaPlayer.position = tim
                    } else {
                        console.log("无播放源")
                    }
                    lyricItemRoot.currentIndex = index
                    lyricItemRoot.current = index
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

}
