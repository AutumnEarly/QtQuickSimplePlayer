import QtQuick 2.12
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../theme"
import "../singletonComponent"

Popup {
    id: control

    signal confirm()
    signal cancel()

    width: 400
    height: 180
    modal: true
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

    contentItem: Item {
        Column {
            width: parent.width
            height: parent.height
            spacing: 20
            padding: 15
            Item { // 标题
                width: parent.width - parent.padding*2
                height: children[0].height
                Text {
                    height: contentHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 14
                    text: "新建歌单"
                }
            }
            Rectangle {  // 输入歌单标题
                width: parent.width - parent.padding *2
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 8
                color: "#" + ThemeManager.theme.backgroundColor
                TextField { // 输入框
                    id: nameTextField
                    property Popup popup: Popup {
                        width: 0
                        height: 0
                        closePolicy: Popup.CloseOnPressOutsideParent
                    }
                    focus: popup.visible
                    width: parent.width - 10
                    height: contentHeight+5
                    anchors.centerIn: parent
                    placeholderText: "请输入歌单标题"
                    text: ""
    //                                    validator: RegularExpressionValidator {regularExpression: /{0,12}/ }
                    font.pointSize: 12
                    color: "#"+ ThemeManager.theme.fontColor
                    background: Rectangle {
                        color: "#00000000"
                        border.width: 0
                    }
                    onPressed: {
                        popup.open()
                    }
                }

            }

            Row { // 确定取消
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15
                Rectangle {
                    width: 80
                    height: 40
                    radius: 10
                    color: "#"+ThemeManager.theme.iconColor_2
                    Text {
                        text: "添加"
                        font.pointSize: 12
                        anchors.centerIn: parent
                        color: "#"+ThemeManager.theme.fontColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            MyPlayListManager.addPlayList({name: nameTextField.text})
                            control.close()
                            control.destroy()
                            control.confirm()
                        }
                    }
                }
                Rectangle {
                    width: 80
                    height: 40
                    radius: 10
                    color: "#"+ThemeManager.theme.iconColor_2
                    Text {
                        text: "取消"
                        font.pointSize: 12
                        anchors.centerIn: parent
                        color: "#"+ThemeManager.theme.fontColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            control.close()
                            control.destroy()
                            control.cancel()
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
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
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
                    control.cancel()
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
