import QtQuick 2.12
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../theme"
import "../singletonComponent"

Popup {
    id: control
    property var musicInfo: null
    width: 500
    height: 500
    modal: true
    padding: 0
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose

    Overlay.modal: Rectangle {
        GaussianBlur {
            anchors.fill: parent
            radius: 8
            source: control.parent
        }
    }
    background: Item {

        Rectangle {
            id: popupBackground
            anchors.fill: parent
            radius: 8
            color: "#" + ThemeManager.theme.backgroundColor
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#1F" + ThemeManager.theme.iconColor
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

    contentItem: Column {
        Item {
            id: header
            width: parent.width
            height: 150
            anchors.horizontalCenter: parent.horizontalCenter
            Column {
                width: parent.width
                height: titleText.height + 80
                padding: 0
                topPadding: 10
                leftPadding: 10
                rightPadding: 10
                Item { // 标 题
                    id: titleText
                    width: parent.width - parent.leftPadding - parent.rightPadding
                    height: 60
                    Text {
                        height: contentHeight
                        anchors.centerIn: parent
                        font.pointSize: 14
                        text: "选择歌单"
                        color: "#"+ ThemeManager.theme.fontColor
                    }
                }

                Rectangle {
                    width: control.width
                    height: 80
                    radius: 6
                    color: "#00000000"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            let cmp = Qt.createComponent("QCCreatePlayListPopup.qml")
                            if(cmp.status === Component.Ready) {
                                cmp = cmp.createObject(windowPage)
                                cmp.open()
                            }
                        }
                        Row {
                            width: parent.width
                            height: parent.height
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 5
                            Rectangle {
                                id: img
                                width: parent.height - 10
                                height: width
                                color: "#6f6f6f"
                                Rectangle {
                                    width: 2
                                    height: parent.height *.6
                                    x: (parent.width - width) / 2
                                    y: (parent.height - height) / 2
                                }
                                Rectangle {
                                    width: parent.height *.6
                                    height: 2
                                    x: (parent.width - width) / 2
                                    y: (parent.height - height) / 2

                                }
                            }
                            Column {
                                width: parent.width - img.width
                                anchors.verticalCenter: img.verticalCenter
                                Text {
                                    font.pointSize: 10
                                    text: "新建歌单"
                                    color: "#"+ ThemeManager.theme.fontColor
                                }
                            }
                        }

                    }
                }

            }


            Rectangle { // 退出按钮
                property bool isHoverd: false
                width: 35
                height: width
                radius: 100
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 5
                color: if(isHoverd) return "#1F"+ ThemeManager.theme.iconColor
                       else return "#00000000"
                Rectangle {
                    width: parent.width / 2
                    height: 3
                    border.color: "#"+ ThemeManager.theme.iconColor
                    anchors.centerIn: parent
                    rotation: 45
                    color: "#"+ ThemeManager.theme.iconColor
                }
                Rectangle {
                    width: parent.width / 2
                    height: 3
                    border.color: "#"+ ThemeManager.theme.iconColor
                    anchors.centerIn: parent
                    rotation: -45
                    color: "#"+ ThemeManager.theme.iconColor
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {

                        control.close()
                        control.destroy()
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
        ListView {
            width: parent.width
            height: parent.height - header.height
            clip: true
            model: MyPlayListManager.data
            delegate: listviewDelegate
            QCScrollBar.vertical: QCScrollBar {
                handleNormalColor: "#1F" + ThemeManager.theme.iconColor
            }
        }
    }

    Component {
        id: listviewDelegate
        Rectangle {
            property bool isHoverd: false
            width: control.width
            height: 80
            color: if(isHoverd) return "#1F"+ ThemeManager.theme.iconColor
            else return "#00000000"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    MyPlayListManager.addMusic(index,control.musicInfo)
                    control.close()
                    control.destroy()
                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }
                Row {
                    width: parent.width - 20
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 5
                    RoundImage {
                        id: img
                        width: parent.height - 10
                        height: width
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        source: MyPlayListManager.data[index].coverImgMode === "0" ?
                                MyPlayListManager.data[index].coverImg+ "?thumbnail=" + 80 + "y" + 80 :
                                MyPlayListManager.data[index].userCoverImg
                    }
                    Column {
                        width: parent.width - img.width
                        anchors.verticalCenter: img.verticalCenter
                        Text {
                            font.pointSize: 10
                            text: MyPlayListManager.data[index].name
                            color: "#"+ ThemeManager.theme.fontColor
                        }
                    }
                }

            }
        }

    }
}
