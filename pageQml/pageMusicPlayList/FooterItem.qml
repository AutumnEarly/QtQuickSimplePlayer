// FooterItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayList.js" as PagePlayListJS
/*
    歌单 头部部分
*/

Item {
    width: musicPlayListPageListView.width
    height: 150
    visible: playListData.length
    anchors.top: content.bottom
    Text {
        anchors.centerIn: parent
        font.pointSize: 12
        text: "当前已经到底咯！"
        color: "#" + thisTheme.fontColor
    }
    QCSwitchPageBar {
        id: switchPageBar
        width: parent.width
        height: 40
        count: Math.ceil(playListAllCount / limit)
        maxItems: 5
        preBtnSource: "qrc:/Images/dropDown.svg"
        nextBtnSource: "qrc:/Images/dropDown.svg"
        color: "#1F" + thisTheme.iconColor
        fontColor: "#"+ thisTheme.fontColor
        borderColor: "#7F" + thisTheme.iconColor
        onCurretIndexChanged: {
            content.playListItem.model = 0
            musicPlayListPageListView.contentY = content.playListItem.y
            let getPlayListInfo = {
                cat: musicPlayListPage.activeCatName,
                limit: musicPlayListPage.limit,
                offset: switchPageBar.curretIndex
            }
            PagePlayListJS.setPlayListData(getPlayListInfo)
        }
    }
}
