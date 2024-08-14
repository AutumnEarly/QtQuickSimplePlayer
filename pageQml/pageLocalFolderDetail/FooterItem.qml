// FooterItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageLocalFolderDetail.js" as PageLocalFolderJS

/*
    歌单 头部部分
*/

Item {
    width: localFolderPageListView.width
    height: 150
    anchors.top: content.bottom
    Text {
        anchors.centerIn: parent
        font.pointSize: 12
        text: "当前已经到底咯！"
        color: "#" + thisTheme.fontColor
    }
}
