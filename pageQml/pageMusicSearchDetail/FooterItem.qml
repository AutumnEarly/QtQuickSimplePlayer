// FooterItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "./pageMusicSearchDetail.js" as PageSearchJS

/*
    搜索页 尾部部分
*/

Item { // 尾部部分
    id: footer
    property alias switchPageBar: switchPageBar

    visible: content.height>0
    width: parent.width
    height: 120
    anchors.top: content.bottom
    anchors.topMargin: 20
    QCSwitchPageBar {
        id: switchPageBar
        width: parent.width
        height: 40
        count: musicSearchPage.pageCount
        maxItems: 5
        preBtnSource: "qrc:/Images/dropDown.svg"
        nextBtnSource: "qrc:/Images/dropDown.svg"
        color: "#1F" + thisTheme.iconColor
        fontColor: "#"+ thisTheme.fontColor
        borderColor: "#7F" + thisTheme.iconColor
        onCurretIndexChanged: {
            musicSearchPage.thisPage = curretIndex
            musicSearchPageFlickable.contentY = 0
            PageSearchJS.switchPage(musicSearchPage.thisPage)
        }
    }
}

