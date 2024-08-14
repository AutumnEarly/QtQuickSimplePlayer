// RightMenu.qml
import QtQuick 2.15
import QtQuick.Controls
import "../menu"

/*
    主题设置右键菜单
*/
QCMenu {

    width: 200
    topPadding: 10
    bottomPadding: 10
    background: Rectangle {
        radius: 6
        color: "#"+ themeConfigLabel.thisTheme.backgroundColor_2
    }

    QCMenuItem {
        property bool isHoverd: false
        width: parent.widthd
        text: "修改主题"
        textColor: "#"+ themeConfigLabel.thisTheme.fontColor
        background: Rectangle {
           color: parent.highlighted ? "#1F"+ themeConfigLabel.thisTheme.iconColor : "#00000000"
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                settingThemePopup.open()
            }
        }
    }
}
