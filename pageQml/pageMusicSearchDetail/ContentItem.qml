// ContentItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "./pageMusicSearchDetail.js" as PageSearchJS

/*
    搜索页 主体部分
*/

Rectangle { // 主体部分
    id: content
    property double startY: parent.startY + y
    property alias contentRepeater: contentRepeater
    width: musicSearchPageFlickable.width - 80
    height: contentRepeater.count * 80 + 30
    anchors.top: header.bottom
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter
    radius: 10
    color: "#" + thisTheme.backgroundColor_2
    Repeater {
        id: contentRepeater
        delegate: songsDelegate
        onCountChanged: {

        }
    }

}

