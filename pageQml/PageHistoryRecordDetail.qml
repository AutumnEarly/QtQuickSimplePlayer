//PageHistoryRecordDetail.qml
import QtQuick
import QtQuick.Dialogs
import "../qcComponent"
import "../theme"
import "../singletonComponent"
import "./pageHistoryRecordDetail"
import "./pageHistoryRecordDetail/pageHistoryRecordDetail.js" as PageHistoryRecordJS

/*
    最近播放详情页
*/

Item {
    id: historyRecordPage
    property QCTheme thisTheme: ThemeManager.theme
    property var musicPlayListInfo: null
    property var headerData: [{headerText: "单曲",qml:""},
    ]
    property var contentData: HistoryRecordManager.getData()
    property int fontSize: 12
    property int headerCurrent: 0
    property int contentCurrent: historyRecordPageListView.currentIndex
    width: parent.width
    height: parent.height


    MouseArea { // 视图滚动
        anchors.fill: parent
        onWheel: function (wheel) {

//            historyRecordPageListView.isWheeling = true
            var step = historyRecordPageListView.contentY
            var contentHeight = historyRecordPageListView.contentHeight
            var wheelStep = historyRecordPageListView.wheelStep
            let maxContentY = contentHeight - historyRecordPageListView.headerItem.height - historyRecordPageListView.height
            if(wheel.angleDelta.y >= 0) {
                if(historyRecordPageListView.contentY - wheelStep <= -historyRecordPageListView.headerItem.height) {
                    step = -historyRecordPageListView.headerItem.height
                } else {
                    step = historyRecordPageListView.contentY - wheelStep
                }
                historyRecordPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(historyRecordPageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY
                } else {
                    step = historyRecordPageListView.contentY + wheelStep
                }
                historyRecordPageListView.scrollDirection = 0
            }
            historyRecordPageAni.to = step
            historyRecordPageAni.start()
        }
    }
    PropertyAnimation {
        id: historyRecordPageAni
        target: historyRecordPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            historyRecordPageListView.isWheeling = false
        }
    }
    ListView {
        id: historyRecordPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: historyRecordPage.width
        height: historyRecordPage.height
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
       parent: historyRecordPageListView.contentItem
       y: -15
       width: historyRecordPageListView.width-50
       height: historyRecordPageListView.count <= 0 ? 0: historyRecordPageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }
    Text {
        parent: historyRecordPageListView
        visible: historyRecordPageListView.model.length  <= 0
        anchors.horizontalCenter: parent.horizontalCenter
        y: historyRecordPageListView.headerItem ?
           historyRecordPageListView.headerItem.height + 15 : 0

        font.pointSize: fontSize + 2
        elide: Text.ElideRight
        color:  "#" +historyRecordPage.thisTheme.fontColor
        text: "当前暂无历史记录!"
    }

}
