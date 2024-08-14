// PageMusicAlbumDetail.qml
import QtQuick
import "../qcComponent"
import "../theme"
import "./pageMusicAlbumDetail"
import "./pageMusicAlbumDetail/pageMusicAlbumDetail.js" as PageMusicAlbumJS

/*
    专辑详情页
*/

Item {
    id: musicAlbumPage
    property QCTheme thisTheme: ThemeManager.theme
    property var albumInfo: null
    property var getAlbumInfo: null
    property var contentData: []
    property int fontSize: 12
    property int contentCurrent: musicAlbumPageListView.currentIndex
    width: parent.width
    height: parent.height

    onGetAlbumInfoChanged: {
        PageMusicAlbumJS.getAlbumInfoData(getAlbumInfo)
    }

    MouseArea {
        anchors.fill: parent
        onWheel: function (wheel) {

//            musicAlbumPageListView.isWheeling = true
            var step = musicAlbumPageListView.contentY
            var contentHeight = musicAlbumPageListView.contentHeight
            var wheelStep = musicAlbumPageListView.wheelStep
            let maxContentY = contentHeight - musicAlbumPageListView.height - musicAlbumPageListView.headerItem.height
            if(wheel.angleDelta.y >= 0) {
                if(musicAlbumPageListView.contentY - wheelStep < -musicAlbumPageListView.headerItem.height) {
                    step = -musicAlbumPageListView.headerItem.height
                } else {
                    step = musicAlbumPageListView.contentY - wheelStep
                }
                musicAlbumPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(musicAlbumPageListView.contentY + wheelStep + musicAlbumPageListView.height >= maxContentY) {
                    step = maxContentY
                } else {
                    step = musicAlbumPageListView.contentY + wheelStep
                }
                musicAlbumPageListView.scrollDirection = 0
            }
            if(musicAlbumPageAni.to !== step) {
                musicAlbumPageAni.to = step
                musicAlbumPageAni.start()
            }
        }
    }
    PropertyAnimation {
        id: musicAlbumPageAni
        target: musicAlbumPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            musicAlbumPageListView.isWheeling = false
        }
    }

    ListView {
        id: musicAlbumPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: musicAlbumPage.width
        height: musicAlbumPage.height
        clip: true
        currentIndex: -1
        interactive: false
        header: HeaderItem {}
        footer: FooterItem {}
        model: contentData
        delegate: listViewDelegate

        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#1F" + thisTheme.iconColor
        }
    }

    OneMusicMenu {
        id: oneMusicMenu
    }

    Component {
        id: listViewDelegate
        OneMusicDelegate {}
    }
    Rectangle {
       parent: musicAlbumPageListView.contentItem
       y: -15
       width: musicAlbumPageListView.width-50
       height: musicAlbumPageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
   }
}
