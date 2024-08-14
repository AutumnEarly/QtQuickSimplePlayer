// PageMusicFavoriteDetail.qml
import QtQuick
import "../qcComponent"
import "../theme"
import "./pageMusicFavoriteDetail"
import  "../singletonComponent"

/*
    我的喜欢音乐详情页
*/

Item {
    id: musicFavoritePage
    property QCTheme thisTheme: ThemeManager.theme
    property var contentData: FavoriteManager.data
    property int fontSize: 12
    property int contentCurrent: musicFavoritePageListView.currentIndex

    width: parent.width
    height: parent.height



    MouseArea {
        anchors.fill: parent
        onWheel: function (wheel) {

//            musicFavoritePageListView.isWheeling = true
            var step = musicFavoritePageListView.contentY
            var contentHeight = musicFavoritePageListView.contentHeight
            var wheelStep = musicFavoritePageListView.wheelStep
            let maxContentY = contentHeight - musicFavoritePageListView.headerItem.height - musicFavoritePageListView.height
            if(wheel.angleDelta.y >= 0) {
                if(musicFavoritePageListView.contentY - wheelStep <= -musicFavoritePageListView.headerItem.height) {
                    step = -musicFavoritePageListView.headerItem.height
                } else {
                    step = musicFavoritePageListView.contentY - wheelStep
                }
                musicFavoritePageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(musicFavoritePageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY

                } else {
                    step = musicFavoritePageListView.contentY + wheelStep
                }
                musicFavoritePageListView.scrollDirection = 0
            }
            musicFavoritePageAni.to = step
            musicFavoritePageAni.start()
        }
    }
    PropertyAnimation {
        id: musicFavoritePageAni
        target: musicFavoritePageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            musicFavoritePageListView.isWheeling = false
        }
    }

    ListView {
        id: musicFavoritePageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: musicFavoritePage.width
        height: musicFavoritePage.height
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
       parent: musicFavoritePageListView.contentItem
       y: -15
       width: musicFavoritePageListView.width-50
       height: musicFavoritePageListView.count <= 0 ? 0: musicFavoritePageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }

    Text {
        parent: musicFavoritePageListView
        visible: musicFavoritePageListView.model.length  <= 0
        anchors.horizontalCenter: parent.horizontalCenter
        y: musicFavoritePageListView.headerItem ?
           musicFavoritePageListView.headerItem.height + 15 : 0

        font.pointSize: fontSize + 2
        elide: Text.ElideRight
        color:  "#" +musicFavoritePage.thisTheme.fontColor
        text: "去添加你喜欢的音乐吧!"
    }


}
