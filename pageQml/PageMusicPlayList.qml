import QtQuick
import Qt5Compat.GraphicalEffects
import "../qcComponent"
import "../theme"
import "./pageMusicPlayList"
import "./pageMusicPlayList/pageMusicPlayList.js" as PagePlayListJS

Item {
    id: musicPlayListPage
    width: parent.width
    height: parent.height
    property QCTheme thisTheme: ThemeManager.theme
    property var headerData: [
        {name:"电子"},
        {name:"游戏"},
        {name:"ACG"},
        {name:"欧美"},
        {name:"华语"},
        {name:"古风"},
        {name:"流行"},
    ]

    property var loadItem: []
    property var playListCategories: null // 歌单类型
    property var boutiquePlayListData: []
    property var playListData: []

    property string activeCatName: "游戏"

    property real boutiquePlayListItemWidth: 160
    property real boutiquePlayListItemHeight: boutiquePlayListItemWidth * 1.4
    property real minBoutiquePlayListItemWidth: 160

    property int boutiquePlayListAllCount: 0
    property int boutiquePlayListCount: 0
    property int playListAllCount: 0
    property int playListCount: 0

    property int fontSize: 12
    property int limit: 100
    onActiveCatNameChanged: {
//        musicPlayListPageListView.contentY = content.y
    }

    MouseArea { // 视图滚动
        anchors.fill: parent
        onWheel: function (wheel) {

//            musicPlayListPage.isWheeling = true
            var step = musicPlayListPageListView.contentY
            var contentHeight = musicPlayListPageListView.contentHeight
            var wheelStep = musicPlayListPageListView.wheelStep
            let maxContentY = contentHeight - musicPlayListPageListView.height + musicPlayListPageListView.bottomMargin
            if(wheel.angleDelta.y >= 0) {
                if(musicPlayListPageListView.contentY - wheelStep <= -musicPlayListPageListView.topMargin) {
                    step = -musicPlayListPageListView.topMargin
                } else {
                    step = musicPlayListPageListView.contentY - wheelStep
                }
                musicPlayListPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(musicPlayListPageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY
                } else {
                    step = musicPlayListPageListView.contentY + wheelStep
                }
                musicPlayListPageListView.scrollDirection = 0
            }
            musicPlayListPageAni.to = step
            musicPlayListPageAni.start()
        }
    }
    PropertyAnimation {
        id: musicPlayListPageAni
        target: musicPlayListPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            musicPlayListPage.isWheeling = false
        }
    }

    Flickable {
        id: musicPlayListPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        leftMargin: 20
        rightMargin: 20
        topMargin: 40
        bottomMargin: 40
        width: parent.width
        height: parent.height
        clip: true
        interactive: false
        contentHeight: header.height + content.height + footer.height
        Component.onCompleted: {
            let getBoutiquePlayListInfo = {
                cat: activeCatName,
                limit: musicPlayListPage.limit,
                offset: 0
            }
            let getPlayListInfo = {
                cat: activeCatName,
                limit: musicPlayListPage.limit,
                offset: 0
            }
            PagePlayListJS.setBoutiquePlayListData(getBoutiquePlayListInfo)
            PagePlayListJS.setPlayListData(getPlayListInfo)
        }

//        onContentYChanged: {
//            delayLoaderItemTimer.start()
//        }
        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#1F" + thisTheme.iconColor
        }

        HeaderItem {
            id: header
        }


        ContentItem {
            id: content
        }

        FooterItem {
            id: footer
        }
    }



}
