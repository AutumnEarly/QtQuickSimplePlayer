// PlayListsItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayList.js" as PagePlayListJS
import  "../../singletonComponent"

/*
    歌单 热门歌单
*/

Item {
    id: playListItem
    property var loadItem: [] // 当前加载的组件下标
    property var contentData: musicPlayListPage.playListData

    property var contentItemImgSize: Qt.size(minContentItemWidth,minContentItemWidth)
    property real contentItemWidth: 220 // 加载的组件宽度
    property real contentItemHeight: contentItemWidth * 1.28 // 加载的组件高度
    property real minContentItemWidth: 220  // 加载的组件最小宽度

    property real spacing: 20
    property real startY: y
    property int columns: 4
    property int rows: 4
    property alias model: contentRepeater.model

    width: parent.width
    height: children[0].height
    onContentDataChanged: {
        delayLoaderItemTimer.start()
    }
    onColumnsChanged: {
        contentItemImgSize = Qt.size(contentItemWidth,contentItemWidth)
    }
    onWidthChanged: {
        delaySizeChangeTimer.start()
    }
    Connections {
        target: musicPlayListPage
        function onActiveCatNameChanged() {
            let getPlayListInfo = {
                cat: musicPlayListPage.activeCatName,
                limit: musicPlayListPage.limit,
                offset: 0
            }
            PagePlayListJS.setPlayListData(getPlayListInfo)
        }
    }
    Connections {
        target: musicPlayListPageListView
        function onContentYChanged() {
            delayLoaderItemTimer.start()
        }
    }
    Column {
        width: parent.width
        height: PagePlayListJS.getAllHeight(children,spacing)
        spacing: 20

        Item {
            id: titleItem
            width: parent.width
            height: children[0].height
            Text {
                width: contentWidth
                height: contentHeight
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 14
                text: "热门歌单"
                color: "#7F" + thisTheme.fontColor
            }
        }
        Item {
            id: contentItem
            width: parent.width
            Repeater {
                id: contentRepeater
                width: parent.width
                delegate: QCPlayListLable {
                    property int thisRows: Math.floor(index / playListItem.columns)
                    property int thisColumns: Math.abs((playListItem.columns * thisRows) - index)
                    y: if(thisRows > 0) return thisRows * contentItemHeight + thisRows*playListItem.spacing
                    else return 0
                    x: if(thisColumns > 0) return thisColumns * contentItemWidth + (thisColumns)*playListItem.spacing
                    else return 0
                    visible: false
                    width: contentItemWidth
                    height: contentItemHeight
                    normalColor: "#" + thisTheme.backgroundColor_2
                    hoverdColor: "#2F" + thisTheme.iconColor
                    fontColor: thisTheme.fontColor
                    button.iconSource: "qrc:/Images/player.svg"
                    button.iconColor: "#" + thisTheme.iconColor_2
                    button.color: "#FF" + thisTheme.iconColor
                    button.hovredColor: "#FF" +thisTheme.iconColor
                    imgSource: contentData[index].coverImg + "?thumbnail=" + 240 + "y" + 240
                    imgSourceSize: contentItemImgSize
                    text: contentData[index].name
                    onClicked: {
                        let lb = leftBar
                        let rc = rightContent
                        let musicPlayListInfo = JSON.parse(JSON.stringify(contentData[index]))
                        musicPlayListInfo["type"] = "歌单"
                        var func = () => {
                            lb.thisBtnText = ""
                            rc.thisQml = "pageQml/PageMusicPlayListDetail.qml"
                            rc.item.musicPlayListInfo = musicPlayListInfo
                        }
                        func()
                        rightContent.push({callBack:func,name:"playList: "+ musicPlayListInfo.name ,data: {}})
                    }
                    onBtnClicked: {
                        console.log("按钮点击")
                    }
                }
                onCountChanged: {
                    delaySizeChangeTimer.start()
                }
            }

        }

    }



    Timer {
        id: delaySizeChangeTimer
        interval: 100
        onTriggered: {
            setContentItemLoader(musicPlayListPageListView.contentY,contentData)
            setContentItemSize()
        }
    }

    Timer {
        id: delayLoaderItemTimer
        interval: 100
        onTriggered: {
            setContentItemLoader(musicPlayListPageListView.contentY,contentData)
        }
    }


    /*
        让组件自适应视图 , 调整合适的大小
    */
    function setContentItemSize() {
        var w = width
        while(true) {
            if(w >= minContentItemWidth*(columns+1) + columns* spacing) {
                columns += 1
            } else if(w < minContentItemWidth*(columns) + (columns-1)* spacing){
                columns -= 1
            } else break
        }

        contentItemWidth = w/columns - ((columns-1) * spacing) / columns
        rows = Math.ceil(contentData.length / columns)
        contentItem.height = spacing * (rows) +contentItemHeight *(rows)
    }
    /*
        加载组件(显示组件)或隐藏组件
    */
    function setContentItemLoader(contentY , arr = []) {
        if(arr.length <= 0) return
        let step = musicPlayListPageListView.wheelStep
        let i = 0
        let rows = 0
        let t = loadItem.slice(0,loadItem.length)
        let stY = playListItem.startY
        loadItem = []
        let startRows = contentY / contentItemHeight
        for(i = 0; i < arr.length;i++) {
            rows = Math.floor(i / columns)
            var startY = (stY + rows * contentItemHeight + (rows-1)* spacing)
            var endY = (musicPlayListPageListView.contentY +musicPlayListPageListView.height)
            if((startY+contentItemHeight+step) >= contentY) {
                if(startY < endY+step) {
                    loadItem.push(i)
                } else break
            }
        }
        if(loadItem[loadItem.length - 1] >= contentRepeater.count ) { // 如果组件未加载那么加载
            contentRepeater.model = loadItem[loadItem.length - 1]+1
        }
        let scrollDirection = musicPlayListPageListView.scrollDirection
        if(scrollDirection === 0) { // 设置显示方向
            for(i = 0 ; i < loadItem.length;i ++) { // 显示视图内组件
                if(!contentRepeater.itemAt(loadItem[i])) continue

                contentRepeater.itemAt(loadItem[i]).visible = true
            }
        } else {
            for(i = loadItem.length - 1; i >= 0;i --) { // 显示视图内组件
                if(!contentRepeater.itemAt(loadItem[i])) continue

                contentRepeater.itemAt(loadItem[i]).visible = true
            }
        }

        for(i = 0; i < t.length;i++) {
            if(loadItem.indexOf(t[i]) === -1) { // 隐藏视图内组件
                if(!contentRepeater.itemAt(loadItem[i])) continue

                contentRepeater.itemAt(t[i]).visible = false
            }
        }

//        console.log("loadItems: " + JSON.stringify(loadItem))
    }
}


