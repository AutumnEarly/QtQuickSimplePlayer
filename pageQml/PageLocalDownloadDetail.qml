//PageLocalDownloadDetail.qml
import QtQuick
import QtQuick.Dialogs
import "../qcComponent"
import "../theme"
import "./pageLocalDownloadDetail"
import "./pageLocalDownloadDetail/pageLocalDownloadDetail.js" as PageLocalDownloadJS

/*
    本地与下载详情页
*/

Item {
    id: musicLocalDownloadPage
    property QCTheme thisTheme: ThemeManager.theme
    property var musicPlayListInfo: null
    property var headerData: [{headerText: "本地音乐",qml:""},
//        {headerText: "正在下载",qml:""},
    ]
    property var contentData: p_musicDownload.data
    property real fontSize: 12
    property int headerCurrent: 0
    property int contentCurrent: musicLocalDownloadPageListView.currentIndex
    width: parent.width
    height: parent.height

    /*
        获取Column组件的高度
    */
    function getAllHeight(children,spacing) {
        var h = 0
        for(var i = 0;i < children.length;i++) {
            if(children[i] instanceof Text) {
                h += children[i].contentHeight
            } else {
                h += children[i].height
            }
        }
        h += (children.length-1) *spacing
    //        console.log("height: " + h)
        return h
    }

    FileDialog {
        id: fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC Music Files(*.flac)"]
        acceptLabel: "确定"
        rejectLabel: "取消"
    }

    MouseArea { // 视图滚动
        anchors.fill: parent
        onWheel: function (wheel) {

//            musicLocalDownloadPageListView.isWheeling = true
            var step = musicLocalDownloadPageListView.contentY
            var contentHeight = musicLocalDownloadPageListView.contentHeight
            var wheelStep = musicLocalDownloadPageListView.wheelStep
            let maxContentY = contentHeight - musicLocalDownloadPageListView.headerItem.height - musicLocalDownloadPageListView.height
            if(wheel.angleDelta.y >= 0) {
                if(musicLocalDownloadPageListView.contentY - wheelStep < -musicLocalDownloadPageListView.headerItem.height) {
                    step = -musicLocalDownloadPageListView.headerItem.height
                } else {
                    step = musicLocalDownloadPageListView.contentY - wheelStep
                }
                musicLocalDownloadPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(musicLocalDownloadPageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY
                } else {
                    step = musicLocalDownloadPageListView.contentY + wheelStep
                }
                musicLocalDownloadPageListView.scrollDirection = 0
            }
            musicLocalDownloadPageAni.to = step
            musicLocalDownloadPageAni.start()
        }
    }
    PropertyAnimation {
        id: musicLocalDownloadPageAni
        target: musicLocalDownloadPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            musicLocalDownloadPageListView.isWheeling = false
        }
    }
    ListView {
        id: musicLocalDownloadPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: parent.width
        height: parent.height
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
       parent: musicLocalDownloadPageListView.contentItem
       y: -15
       width: musicLocalDownloadPageListView.width-50
       height: musicLocalDownloadPageListView.count <= 0 ? 0: musicLocalDownloadPageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }

    Text {
        parent: musicLocalDownloadPageListView
        visible: musicLocalDownloadPageListView.model.length  <= 0
        anchors.horizontalCenter: parent.horizontalCenter
        y: musicLocalDownloadPageListView.headerItem ?
           musicLocalDownloadPageListView.headerItem.height + 15 : 0

        font.pointSize: fontSize + 2
        elide: Text.ElideRight
        color:  "#" +musicLocalDownloadPage.thisTheme.fontColor
        text: "当前暂无下载的音乐!"
    }
}
