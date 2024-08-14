//PageFindMusic.qml
import QtQuick
import QtQuick.Controls
import "../qcComponent"
import "../theme"

/*
    发现音乐页
*/

Item {
    id: findMusicPage
    property QCTheme thisTheme: ThemeManager.theme
    property var headerData: [
        {headerText: "最新音乐",qml:"pageFindMusicContent/FindMusicNewMusicContent.qml"},
    ]
    property double fontSize: 12
    anchors.fill: parent

    Flickable {
        id: findMusicFlickable

        property double headerHeight: 40
        property int wheelStep: 300
        property bool isWheeling: false
        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: findMusicHeader.height + findMusicContent.height + 30
        interactive: false
        clip: true
        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#1F" + thisTheme.iconColor
        }

        onContentYChanged: {
            contentItemLoaderTimer.start()
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: function (mouse){
                forceActiveFocus()
            }
            onWheel: function (wheel) {

                findMusicFlickable.isWheeling = true
                var step = findMusicFlickable.contentY
                if(wheel.angleDelta.y >= 0) {
                    if(findMusicFlickable.contentY - findMusicFlickable.wheelStep < 0) {
                        step = 0
                    } else {
                        step = findMusicFlickable.contentY - findMusicFlickable.wheelStep
                    }
                }  else if(wheel.angleDelta.y < 0) {
                    if(findMusicFlickable.contentY + findMusicFlickable.wheelStep + findMusicFlickable.height >= findMusicFlickable.contentHeight) {
                        step = findMusicFlickable.contentHeight - findMusicFlickable.height
                    } else {
                        step = findMusicFlickable.contentY + findMusicFlickable.wheelStep
                    }
                }
                if(findMusicFilckAni.to !== step) {
                    findMusicFilckAni.to = step
                    findMusicFilckAni.start()
                }
            }
        }
        PropertyAnimation {
            id: findMusicFilckAni
            target: findMusicFlickable
            property: "contentY"
            duration: 300
            easing.type: Easing.InOutQuad
            onStopped: {
                findMusicFlickable.isWheeling = false
            }
        }


        Rectangle {
            id: findMusicHeader

            property var rootFlickable: findMusicFlickable
            property int current: 0
            property int topBottomPadding: 25
            property int leftRightPadding: 35
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            radius: width/2
            color: "#0F" + thisTheme.iconColor
            Row {
                Repeater {
                    id: findMusicRepeater
                    width: count * 40
                    height: findMusicFlickable.headerHeight
                    model: ListModel {
                    }
                    delegate: repeaterDelegate
                    onCountChanged: {
                        var w = 0
                        var h = 0
                        for(var i = 0; i < count;i++) {
                            w += itemAt(i).width
                            if(h < itemAt(i).height) {
                                h = itemAt(i).height
                            }
                        }
                        findMusicHeader.width = w
                        findMusicHeader.height = h
                    }
                    Component.onCompleted: {
                        model.append(findMusicPage.headerData)
                    }
                }
            }
        }
        Loader {
            id: findMusicContent
            anchors.top: findMusicHeader.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: item != null ? item.height : 0
            source: findMusicPage.headerData[findMusicHeader.current].qml
            onStatusChanged: {
                if(status === Loader.Ready) {
                    console.log("当前加载内容: " + item)
                }
            }
        }

        Component {
            id: repeaterDelegate
            Rectangle {
                property bool isHoverd: false
                width: children[0].contentWidth + findMusicHeader.leftRightPadding
                height: children[0].contentHeight + findMusicHeader.topBottomPadding
                radius: width/2
                color: if(findMusicHeader.current === index) return "#1F" + thisTheme.iconColor
                else if(isHoverd) return "#0F" + thisTheme.iconColor
                else return "#00000000"

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        easing.type:  Easing.InOutQuad
                    }
                }

                Text {
                    font.pointSize: findMusicPage.fontSize
                    font.bold: findMusicHeader.current === index
                    anchors.centerIn: parent
                    text: headerText
                    color: "#" + thisTheme.fontColor
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: function (mouse){
                        forceActiveFocus()
                        findMusicHeader.current = index
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

    Timer { // 加载组件函数消抖
        id: contentItemLoaderTimer
        interval: 250
        onTriggered: {
            findMusicContent.item.setContentItemLoader(findMusicFlickable.contentY)
        }
    }
}

