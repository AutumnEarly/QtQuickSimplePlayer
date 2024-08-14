// QCScrollBar.qml
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

T.ScrollBar {
    id: control

    property color handleNormalColor: "darkCyan"  //按钮颜色
    property color handleHoverColor: Qt.lighter(handleNormalColor,1.1)
    property color handlePressColor: Qt.darker(handleNormalColor,1.1)

    property real handleWidth: 10
    property real handleHeight: 10
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 1 //背景整体size和handle的间隔
    visible: control.policy !== T.ScrollBar.AlwaysOff

    contentItem: Rectangle {
        implicitWidth: control.interactive ? handleWidth : 2
        implicitHeight: control.interactive ? handleHeight : 2

        radius: width / 2
        color: if(control.pressed) return handlePressColor
               else if(control.hovered) return handleHoverColor
               else return handleNormalColor
        // 超出显示范围显示滚动条
        opacity:(control.policy === T.ScrollBar.AlwaysOn || control.size < 1.0)?1.0:0.0

    }
    //一般不需要背景
    /*background: Rectangle{
        implicitWidth: control.interactive ? handleHeight : 2
        implicitHeight: control.interactive ? handleHeight : 2
        color: "skyblue"
        //opacity: 0.3
    }*/
}
