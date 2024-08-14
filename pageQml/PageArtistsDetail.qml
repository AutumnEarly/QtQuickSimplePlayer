//PageArtistsDetail.qml
import QtQuick
import "../qcComponent"
import "../theme"
import "./pageArtistsDetail"
import "./pageArtistsDetail/pageArtistsDetail.js" as PageArtistJS
/*
    歌手详情页
*/

Item {
    id: artistsPage
    property QCTheme thisTheme: ThemeManager.theme
    property var artistInfo: null
    property var albumsData: []
    property var albumsMusicData: []
    property var hotOneMusicData: []
    property var getArtistInfo: null
    property var headerData: [
        {headerText: "热门单曲"},
        {headerText: "专辑"},
    ]
    property int contentCurrent: artistsPageListView.currentIndex
    property int headerCurrent: 0
    property int fontSize: 12
    property int mode: 0

    width: parent.width
    height: parent.height

    onGetArtistInfoChanged: {
        PageArtistJS.selectMode(0)
    }

    MouseArea { // 滚动
        anchors.fill: parent
        hoverEnabled: true
        onClicked: function (mouse){
            forceActiveFocus()
        }
        onWheel: function (wheel) {

//            artistsPageListView.isWheeling = true
            var step = artistsPageListView.contentY
            var contentHeight = artistsPageListView.contentHeight
            var wheelStep = artistsPageListView.wheelStep
            let maxContentHeight = artistsPageListView.height - artistsPageListView.headerItem.height
            if(wheel.angleDelta.y >= 0) {
                if(artistsPageListView.contentY - wheelStep < -artistsPageListView.headerItem.height) {
                    step = -artistsPageListView.headerItem.height
                } else {
                    step = artistsPageListView.contentY - wheelStep
                }
                artistsPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(artistsPageListView.contentY + wheelStep + artistsPageListView.height > contentHeight - maxContentHeight) {
                    step = contentHeight - artistsPageListView.height - maxContentHeight
                } else {
                    step = artistsPageListView.contentY + wheelStep
                }
                artistsPageListView.scrollDirection = 0
            }
            if(artistsPageListAni.to !== step) {
                artistsPageListAni.to = step
                artistsPageListAni.start()
            }
        }
    }
    PropertyAnimation { // 滚动动画
        id: artistsPageListAni
        target: artistsPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            artistsPageListView.isWheeling = false
        }
    }

    ListView {
        id: artistsPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: parent.width
        height: parent.height
        clip: true
        currentIndex: -1
        interactive: false
        header: HeaderItem {}

        footer: Item {
            width: parent.width
            height: 20
        }
        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#1F" + thisTheme.iconColor
        }
    }

    Rectangle { // 单曲背景
       visible: mode === 0
       parent: artistsPageListView.contentItem
       y: -15
       width: artistsPageListView.width -50
       height: artistsPageListView.count <= 0 ? 0: artistsPageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }

    OneMusicMenu {
        id: oneMusicMenu
    }

    function selectMode(mode = 0) {

        PageArtistJS.selectMode(mode)
    }
    Component { // 热门单曲委托项
        id: hotOneMusicDelegate
        HotOneMusicDelegate {}
    }
    Component { // 专辑委托项
        id: albumsDelegate
        AlbumsDelegate {}
    }
}
