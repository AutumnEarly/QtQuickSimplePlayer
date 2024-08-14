import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import Qt.labs.folderlistmodel
import "../qcComponent"
import "../theme"
import "./pageLocalFolderDetail"
import "./pageLocalFolderDetail/pageLocalFolderDetail.js" as PageLocalFolderJS

/*
    本地详情页
*/

Item {
    id: localFolderPage
    property QCTheme thisTheme: ThemeManager.theme
    property var foldersData: []
    property var contentData: foldersData.length ? foldersData[0].data : []
    property var headerData: [
        {"name":"全部", "mode":0},
        {"name":"文件夹","mode":1},
    ]
    property string foldersDataSavePath: "userInfo/foldersInfo.json"
    property real fontSize: 12
    property alias loaderItem: content.loaderItem
    property int mode: 0
    width: parent.width
    height: parent.height

    signal dataValueChanged()

    onDataValueChanged: {
        QCTool.writeFile(foldersDataSavePath,JSON.stringify(foldersData))
    }

    Component.onCompleted: {
        let t = QCTool.readFile(foldersDataSavePath)
        try {
            t = JSON.parse(t)
        } catch(err) {
            t = []
            console.log("PageLocalFolderDetail.qml: " + err)
        }
        foldersData = t
        PageLocalFolderJS.selectMode(mode)
    }


    MouseArea { // 视图滚动
        anchors.fill: parent
        onWheel: function (wheel) {

//            localFolderPage.isWheeling = true
            var step = localFolderPageListView.contentY
            var contentHeight = localFolderPageListView.contentHeight
            var wheelStep = localFolderPageListView.wheelStep
            let maxContentY = contentHeight - localFolderPageListView.height + localFolderPageListView.bottomMargin
            if(wheel.angleDelta.y >= 0) {
                if(localFolderPageListView.contentY - wheelStep <= -localFolderPageListView.topMargin) {
                    step = -localFolderPageListView.topMargin
                } else {
                    step = localFolderPageListView.contentY - wheelStep
                }
                localFolderPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(localFolderPageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY
                } else {
                    step = localFolderPageListView.contentY + wheelStep
                }
                localFolderPageListView.scrollDirection = 0
            }
            localFolderPageAni.to = step
            localFolderPageAni.start()
        }
    }
    PropertyAnimation {
        id: localFolderPageAni
        target: localFolderPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            localFolderPage.isWheeling = false
        }
    }

    FolderListModel {
        id: folderListModel
        nameFilters: ["*.mp3"]
        folder: folderDialog.folder
        onFolderChanged: {
            PageLocalFolderJS.addFolder(folder.toString())
        }
    }

    FolderDialog {
        id: folderDialog
    }

    Flickable {
        id: localFolderPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        property int currentIndex: -1
        leftMargin: 20
        rightMargin: 20
        topMargin: 20
        bottomMargin: 40
        width: parent.width
        height: parent.height
        clip: true
        interactive: false
        contentHeight: height
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
