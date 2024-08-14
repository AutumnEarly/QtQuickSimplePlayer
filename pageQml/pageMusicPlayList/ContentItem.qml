// ContentItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayList.js" as PagePlayListJS
import  "../../singletonComponent"

/*
    歌单 主体部分
*/

Item {
    id: content
    property alias playListItem: playListItem
    property alias boutiquePlayListItem: boutiquePlayListItem
    property real columns: 3
    property real spacing: 20
    property real rows: 0
    property real startY: y
    anchors.top: header.bottom
    anchors.topMargin: 30
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width - (musicPlayListPageListView.leftMargin + musicPlayListPageListView.rightMargin)
    height: children[0].height

    Column {
        width: parent.width
        height: PagePlayListJS.getAllHeight(children,spacing)
        spacing: 15
        BoutiquePlayListItem {
            id: boutiquePlayListItem
            startY: y
        }

        PlayListsItem {
            id: playListItem
            startY: y
        }
    }



}

