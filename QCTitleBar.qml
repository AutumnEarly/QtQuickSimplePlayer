import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qc.window
import "./qcComponent"
import "./theme"

Rectangle {
    id: titleBar
    property QCTheme thisTheme: ThemeManager.theme
    property int fontSize: 11
    width: parent.width
    height: 60
    color: "#"+ thisTheme.backgroundColor
    MouseArea {
        property var click_pos: Qt.point(0,0)
        anchors.fill: parent
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
        RowLayout {
            width: parent.width - 20
            height: parent.height - 10
            anchors.centerIn: parent

            Row { // 标题，搜索框
                width: 460
                height: parent.height
                spacing: 15

                Text {
                    font.pointSize: 12
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Music Player Demo"
                    color: "#"+ thisTheme.fontColor
                }
                Row {
                    width: 70
                    height: 35
                    QCToolTipButton {
                        property bool isActive: rightContent.pageCurrent > 0 ? true: false
                        enabled: isActive
                        width: 35
                        height: width
                        transformOrigin: Item.Center
                        rotation: 90
                        cursorShape: Qt.PointingHandCursor
                        iconSource: "qrc:/Images/dropDown.svg"
                        hovredColor: "#0F" + thisTheme.iconColor
                        iconColor: isActive ? "#" +thisTheme.iconColor : "#4F" +thisTheme.iconColor
                        toolTip.border.color: "BLACK"
                        onClicked: function (mouse){
                            forceActiveFocus()
                            rightContent.previousStep()
                        }
                    }
                    QCToolTipButton {
                        property bool isActive: rightContent.pageCurrent >= rightContent.pageStepCount-1 ? false: true
                        enabled: isActive
                        width: 35
                        height: width
                        transformOrigin: Item.Center
                        rotation: -90
                        cursorShape: Qt.PointingHandCursor
                        iconSource: "qrc:/Images/dropDown.svg"
                        hovredColor: "#0F" + thisTheme.iconColor
                        iconColor: isActive ? "#" +thisTheme.iconColor : "#4F" +thisTheme.iconColor
                        toolTip.border.color: "BLACK"
                        onClicked: function (mouse){
                            forceActiveFocus()
                            rightContent.nextStep()
                        }
                    }
                }
                QCTitleBarSearchBox { // 搜索框
                    width: 300
                }
            }
            Item {Layout.preferredWidth: 10; Layout.fillWidth: true}
            Row { // 全屏最小退出按钮
                width: 30 *5
                QCToolTipButton {
                    id: themeConfigBtn
                    width: 35
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    cursorShape: Qt.PointingHandCursor
                    iconSource: "qrc:/Images/theme.svg"
                    hovredColor: "#1F"+ thisTheme.iconColor
                    iconColor: "#"+ thisTheme.fontColor
                    onClicked: function (mouse){
                        if(p_ThemeManagerConfigLabel.visible) {
                            isHighlight = false
                            p_ThemeManagerConfigLabel.close()
                        } else {
                            isHighlight = true
                            p_ThemeManagerConfigLabel.open()
                        }
                    }
                }
                Rectangle {
                    id: minWindowBtn
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    color: if(isHoverd) return "#1F"+ thisTheme.iconColor
                           else return "#00000000"
                    Rectangle {
                        width: parent.width / 2
                        height: 3
                        anchors.centerIn: parent
                        color: "#"+ thisTheme.fontColor
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
                    color: if(isHoverd) return "#1F"+ thisTheme.iconColor
                           else return "#00000000"
                    Rectangle {
                        width: parent.width / 2
                        height: width
                        anchors.centerIn: parent
                        radius: 100
                        color: "#00000000"
                        border.width: 2
                        border.color: "#"+ thisTheme.fontColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: function (mouse) {
                            forceActiveFocus()
                            if(window.visibility === Window.Maximized) {
                                window.showNormal()
                            } else {
                                window.showMaximized()
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
                    color: if(isHoverd) return "#1F"+ thisTheme.iconColor
                           else return "#00000000"
                    Rectangle {
                        width: parent.width / 2
                        height: 3
                        border.color: "#"+ thisTheme.fontColor
                        anchors.centerIn: parent
                        rotation: 45
                        color: "#"+ thisTheme.fontColor
                    }
                    Rectangle {
                        width: parent.width / 2
                        height: 3
                        border.color: "#"+ thisTheme.fontColor
                        anchors.centerIn: parent
                        rotation: -45
                        color: "#"+ thisTheme.fontColor
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
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

