// PageMusicSearchDetail.qml
import QtQuick
import QtQuick.Controls
import "../qcComponent"
import "../theme"
import "./pageMusicSearchDetail"
import "./pageMusicSearchDetail/pageMusicSearchDetail.js" as PageSearchJS
/*
    搜索换页面
*/
Item {
    id: musicSearchPage
    property QCTheme thisTheme: ThemeManager.theme
    property var headerData: [{headerText: "单曲",type:"1"},
        {headerText: "专辑",type:"10"},
        {headerText: "歌单",type:"1000"},
    ]
    property var loadItem: []
    property var contentData: []
    property var contentCacheBuffer: []
    property ListModel contentModel: ListModel{}
    property string searchText: ""
    property int fontSize: 12
    property int contentCurrent: -1
    property int headerCurrent: 0
    property int contentItemHeight: 80
    property int allCount: 0 // 总共有多少个
    property int count: 0 // 当前加载有多少个
    property int limit: 50 //单次获取数量
    property int thisPage: 0 //当前页
    property int pageCount: 0 // 总共页数
    property bool isFind: false

    property alias contentRepeater: content.contentRepeater
    property alias switchPageBar: footer.switchPageBar

    width: parent.width
    height: parent.height

    signal searchRelay()

    function updateAll() {
        PageSearchJS.updateAll()
    }

    MouseArea {// 用作获得活动焦点以及滚动
        anchors.fill: parent
        onWheel: function (wheel) {
            musicSearchPageFlickable.isWheeling = true
            var step = musicSearchPageFlickable.contentY
            if(wheel.angleDelta.y >= 0) {
                if(musicSearchPageFlickable.contentY - musicSearchPageFlickable.wheelStep < 0) {
                    step = 0
                } else {
                    step = musicSearchPageFlickable.contentY - musicSearchPageFlickable.wheelStep
                }
            }  else if(wheel.angleDelta.y < 0) {
                if(musicSearchPageFlickable.contentY + musicSearchPageFlickable.wheelStep +
                        musicSearchPageFlickable.height >= musicSearchPageFlickable.contentHeight) {
                    step = musicSearchPageFlickable.contentHeight - musicSearchPageFlickable.height
                } else {
                    step = musicSearchPageFlickable.contentY + musicSearchPageFlickable.wheelStep
                }
            }
            if(musicSearchPageFlickableAni.to !== step) {
                musicSearchPageFlickableAni.to = step
                musicSearchPageFlickableAni.start()
            }
        }
        onClicked: function (mouse) {
            forceActiveFocus()
            console.log("鼠标穿透")
        }
    }

    PropertyAnimation { // 滚动动画
        id: musicSearchPageFlickableAni
        target: musicSearchPageFlickable
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
            musicSearchPageFlickable.isWheeling = false
//            musicSearchPageFlickable.contentYChanged(musicSearchPageFlickable.contentY)
        }
    }

    Flickable { // 主页面
        id: musicSearchPageFlickable
        property int wheelStep: 300
        property bool isWheeling: false

        anchors.fill: parent
        contentWidth: width
        contentHeight: header.height + content.height + footer.height +40
        clip: true
        interactive: false

        onContentYChanged: function (contentY) {
            PageSearchJS.setVisible(musicSearchPageFlickable.contentY)
        }

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

    Component { // 头部选择栏委托项
        id: headerDelegate
        Rectangle {
            property bool isHoverd: false
            width: children[0].contentWidth + 35
            height: children[0].contentHeight + 25
            radius: width/2
            color: if(headerCurrent === index) return "#2F" + thisTheme.iconColor
            else if(isHoverd) return "#1F" + thisTheme.iconColor
            else return "#00000000"

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type:  Easing.InOutQuad
                }
            }

            Text {
                font.pointSize: fontSize
                font.bold: headerCurrent === index
                anchors.centerIn: parent
                text: headerText
                color: "#"+ thisTheme.fontColor
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                propagateComposedEvents: true
                onClicked: function (mouse) {
                    mouse.accepted = false
                    headerCurrent = index
                    PageSearchJS.initPageCountInfo()
                    contentCacheBuffer = []
                    contentRepeater.model = null
                    PageSearchJS.search(type)
                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }
            }
        }
    }
    Component { // 单曲样式委托项
        id: songsDelegate
        OneMusicDelegate{}
    }
    Component { // 歌单样式委托项
        id: playListDelegate
        PlayListDelegate{}
    }
    Component { // 专辑样式委托项
        id: albumDelegate
        AlbumDelegate{}
    }

}

