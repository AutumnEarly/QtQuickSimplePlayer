// ContentItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageLocalFolderDetail.js" as PageLocalFolderJS
import  "../../singletonComponent"

/*
    歌单 主体部分
*/

Item {
    id: content
    property real columns: 3
    property real spacing: 20
    property real rows: 0
    property real startY: y
    property alias loaderItem: loaderItem
    anchors.top: header.bottom
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - (localFolderPageListView.leftMargin + localFolderPageListView.rightMargin)
    height: parent.height - header.height


    Loader {
        id: loaderItem
        width: parent.width
        height: parent.height
    }

}

