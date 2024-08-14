import QtQuick 2.15
import QtQuick.Controls
/*
    单个主题数据
*/
QtObject {
    id: control
    property string name: "粉色" // 主题名
    property string fontColor: "572C27" // 文本颜色
    property string backgroundColor: "FAF2F1" // 背景颜色
    property string iconColor: "FF5966" // 图标颜色
    property string iconColor_2: "FFFFFF" // 次选图标颜色
    property string backgroundColor_2: "FFFFFF" // 次选背景颜色
    property string type: "system"
//    property Item backgroundPage: Rectangle { color: "#"+ control.backgroundColor}
}
