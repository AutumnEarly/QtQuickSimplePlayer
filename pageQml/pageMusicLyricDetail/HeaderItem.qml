// HeaderItem.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qc.window
import "../../qcComponent"

/*
    歌词详情页 头部部分
*/

MouseArea {
    id: header
    property var click_pos: Qt.point(0,0)
    width: parent.width
    height: 60
    onPositionChanged: function (mouse) {
        if(!pressed || window.mouse_pos !== FramelessWindow.NORMAL) return

        if(!window.startSystemMove()) { // 启用系统自带的拖拽功能
            var offset = Qt.point(mouseX - click_pos.x,mouseY - click_pos.y)
            window.x += offset.x
            window.y += offset.y
        }
    }
    onPressedChanged: function (mouse) {
        click_pos = Qt.point(mouseX,mouseY)
    }
    onDoubleClicked: {
        if(window.visibility === Window.Maximized) {
            window.showNormal()
        } else {
            window.showMaximized()
        }
    }
    onClicked: {
        forceActiveFocus()
    }
    Item {
        width: parent.width - 20
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        Row {
            height: 35
            anchors.verticalCenter: parent.verticalCenter
            QCToolTipButton {
                width: 35
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/dropDown.svg"
                hovredColor: "#7FFFFFFF"
                iconColor: "#FFFFFF"
                onClicked: function (mouse) {
                    musicLyricPage.parent.hidePage()
                    forceActiveFocus()
                }
            }
            Row { // 全屏最小退出按钮
                width: 35 *3 + 5*3
                height: 35
                spacing: 5
                Rectangle {
                    id: minWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: width/2
                    color: if(isHoverd) return "#7FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: 2
                        anchors.centerIn: parent
                        color: "WHITE"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            forceActiveFocus()
                            window.showMinimized()
                        }
                        onEntered: {
                            parent.isHoverd = true
                        }
                        onExited: {
                            parent.isHoverd = false
                        }
                    }
                }
                Rectangle {
                    id: minMaxWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#7FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: width
                        anchors.centerIn: parent
                        radius: 100
                        color: "#00000000"
                        border.width: 2
                        border.color: "WHITE"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function (mouse) {

                            forceActiveFocus()
                            if(window.visibility === Window.Maximized) {
                                window.showNormal()
                                musicLyricPage.y = 0
                            } else {
                                window.showMaximized()
                                musicLyricPage.y = 0
                            }
                        }
                        onEntered: {
                            parent.isHoverd = true
                        }
                        onExited: {
                            parent.isHoverd = false
                        }
                    }
                }
                Rectangle {
                    id: quitWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#7FFFFFFF"
                           else return "#00000000"
                    Rectangle {
                        width: parent.width-15
                        height: 2
                        radius: width/2
                        border.color: "WHITE"
                        anchors.centerIn: parent
                        rotation: 45
                        color: "WHITE"
                    }
                    Rectangle {
                        width: parent.width-15
                        radius: width/2
                        height: 2
                        border.color: "WHITE"
                        anchors.centerIn: parent
                        rotation: -45
                        color: "WHITE"
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursors
                        onClicked: {
                            forceActiveFocus()
                            Qt.quit()
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

    }
}

