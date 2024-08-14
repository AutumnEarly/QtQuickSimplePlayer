// QCThemeConfigLabel.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../theme"
import "./themeConfig"

/*
    主题设置弹出框
*/

Item {
    id: themeConfigLabel
    property QCTheme thisTheme: ThemeManager.theme
    property real itemWidth: 170

    width: 600
    height: 0
    visible: false
    opacity: 0
//    padding: 0
//    closePolicy: Popup.NoAutoClose

    function open() {
        openAni.restart()
    }
    function close() {
        closeAni.restart()
    }

    MouseArea { // 背景
        anchors.fill: parent
        hoverEnabled: true
        onWheel: function (mouse) {}
        Rectangle {
            id: popupBackground
            anchors.fill: parent
            radius: 8
            color: "#" +thisTheme.backgroundColor
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#1F" +thisTheme.iconColor
            }
        }
        DropShadow {
            z: -1
            width: popupBackground.width
            height: popupBackground.height
            horizontalOffset: 1
            verticalOffset: 3
            radius: 8.0
            color: "#2F000000"
            source: popupBackground
        }
    }

    ListView {
        id: listView
        width: themeConfigLabel.width
        height: themeConfigLabel.height
        spacing: 20
        clip: true
        anchors.centerIn: parent
        header: listViewHeader
        delegate: listViewDelegate
        model: ThemeManager.themeData.keyValue.length

        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#2F" + thisTheme.iconColor
        }
        footer: listViewFooter
    }


    ParallelAnimation {
        id: openAni
        NumberAnimation {
            target: themeConfigLabel
            property: "opacity"
            duration: 300
            easing.type: Easing.InOutQuad
            to: 1
        }
        NumberAnimation {
            target: themeConfigLabel
            property: "height"
            duration: 300
            easing.type: Easing.InOutQuad
            to: 400
        }
        onStarted: {
            themeConfigLabel.visible = true
        }
    }

    ParallelAnimation {
        id: closeAni
        NumberAnimation {
            target: themeConfigLabel
            property: "opacity"
            duration: 300
            easing.type: Easing.InOutQuad
            to: 0
        }
        NumberAnimation {
            target: themeConfigLabel
            property: "height"
            duration: 300
            easing.type: Easing.InOutQuad
            to: 0
        }
        onStopped: {
            themeConfigLabel.visible = false
        }
    }


    Component { // 头部部分
        id: listViewHeader
        Item {
           width: themeConfigLabel.width - 30
           height: titleText.contentHeight + 35
           anchors.horizontalCenter: parent.horizontalCenter
           Text {
               id: titleText
               text: "主题设置"
               font.pointSize: 23
               anchors.top: parent.top
               anchors.topMargin: 15
               color: "#"+ thisTheme.fontColor
           }
       }
    }
    Component { // 尾部部分
        id: listViewFooter
        Item {
            width: themeConfigLabel.width - 30
            height: titleText.contentHeight + 35
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: titleText
                property bool isHoverd: false
                text: "添加自定义主题"
                font.pointSize: 12
                anchors.top: parent.top
                anchors.topMargin: 15
                scale: isHoverd ? 1.1 : 1
                color: isHoverd ? "#"+ themeConfigLabel.thisTheme.iconColor
                                : "#"+ themeConfigLabel.thisTheme.fontColor
                MouseArea {

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                       addThemePopup.open()
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

    Component { // 相同类型的主题(集合)
        id: listViewDelegate
        Column {
            id: listViewItem
            property var key: ThemeManager.themeData.keyValue[index]
            width: themeConfigLabel.width - 30
            height: getAllHeight(children,spacing)
            spacing: 8
            onParentChanged: {
                if(parent != null) {
                    anchors.horizontalCenter = parent.horizontalCenter
                }
            }

            Text {
                id: titleText
                width: parent.width
                text: ThemeManager.themeData[listViewItem.key].name
                wrapMode: Text.Wrap
                font.pointSize: 15
                color: "#"+ thisTheme.fontColor
            }
            Text {
                id: briefIntroductionText
                width: parent.width
                text: ThemeManager.themeData[listViewItem.key].briefIntroduction
                wrapMode: Text.Wrap
                font.pointSize: 12
                color: "#"+ thisTheme.fontColor
            }
            Grid {
                property var key: ThemeManager.themeData.keyValue[index]
                width: parent.width
                spacing: (width - (itemWidth*columns)) / (columns-1)
                columns: 3
                Repeater {
                    model: ThemeManager.themeData[parent.key].data.length
                    delegate: miniPageDelegate
                }
            }
        }
    }
    Component { // 相同类型的主题(单个)
        id: miniPageDelegate
        Item {
            id: miniPage
            property var key: parent.key
            property bool isHoverd: false
            property QCTheme thisTheme: ThemeManager.themeData[parent.key].data[index]
            width: themeConfigLabel.itemWidth
            height: children[0].height
            scale: isHoverd ? 1.1 : 1
            Behavior on scale {

               NumberAnimation {
                   target: miniPage
                   property: "scale"
                   duration: 200
                   easing.type: Easing.InOutQuad
               }
            }

            Column {
               width: parent.width
               height: themeConfigLabel.getAllHeight(children,spacing)
               spacing: 5
               QCMiniPage {
                   thisTheme: miniPage.thisTheme
                   width: themeConfigLabel.itemWidth
                   height: themeConfigLabel.itemWidth * .7
               }
               Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    Rectangle {
                      width: 15
                      height: width
                      anchors.verticalCenter: parent.verticalCenter
                      visible: ThemeManager.themeData[miniPage.key].data[index].name === themeConfigLabel.thisTheme.name &&
                               ThemeManager.themeData[miniPage.key].data[index].type === themeConfigLabel.thisTheme.type
                      radius: 100
                      color: "#"+ themeConfigLabel.thisTheme.iconColor
                    }
                    Text {
                       text: miniPage.thisTheme.name
                       font.pointSize: 12
                       anchors.verticalCenter: parent.verticalCenter
                       color: "#"+ themeConfigLabel.thisTheme.fontColor
                    }
                }

            }

            MouseArea {
               width: parent.width
               height: parent.height
               acceptedButtons: Qt.LeftButton | Qt.RightButton
               cursorShape: Qt.PointingHandCursor
               hoverEnabled: true
               onEntered: {
                   miniPage.isHoverd = true
               }
               onExited: {
                   miniPage.isHoverd = false
               }
               onClicked: function (mouse) {
                   if(mouse.button === Qt.LeftButton) {
                       ThemeManager.switchTheme(miniPage.thisTheme.name,miniPage.thisTheme.type)
                   }
                   if(mouse.button === Qt.RightButton && miniPage.thisTheme.type === "user") {
                       rightMenu.parent = this
                       rightMenu.x = mouseX
                       rightMenu.y = mouseY
                       rightMenu.open()
                       settingThemePopup.updataTheme = miniPage.thisTheme
                    }
               }
            }
        }
    }

    RightMenu {
        id: rightMenu
    }
    AddThemePopup {
        id: addThemePopup
        parent: windowPage
    }
    SettingThemePopup {
        id: settingThemePopup
        parent: windowPage
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
        return h
    }

}





