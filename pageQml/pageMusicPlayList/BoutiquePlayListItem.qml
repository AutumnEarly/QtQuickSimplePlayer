// boutiquePlayListItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayList.js" as PagePlayListJS

/*
    歌单 精品歌单
*/

Item {
    id: boutiquePlayListItem
    property var loadItem: [] // 当前加载的组件下标
    property var contentData: musicPlayListPage.boutiquePlayListData
    property real contentItemWidth: 160 // 加载的组件宽度
    property real contentItemHeight: contentItemWidth * 1.4 // 加载的组件高度
    property real minContentItemWidth: 160  // 加载的组件最小宽度
    property real startY: y
    property real spacing: 20
    property int columns: 4
    property int rows: 4

    property alias model: contentRepeater.model
    width: parent.width
    height: children[0].height
    clip: true
    onContentDataChanged: {
        delayLoaderItemTimer.start()
    }
    onWidthChanged: {
        delaySizeChangeTimer.start()
    }
    Connections {
        target: musicPlayListPage
        function onActiveCatNameChanged() {
            let getBoutiquePlayListInfo = {
                cat: activeCatName,
                limit: musicPlayListPage.limit,
                offset: 0
            }

            PagePlayListJS.setBoutiquePlayListData(getBoutiquePlayListInfo)
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
            property bool isDropDown: false
            width: parent.width
            height: PagePlayListJS.getAllHeight(children,0)
            Row {
                width: children[0].width + 30
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5
                Text {
                    width: contentWidth
                    height: contentHeight
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 14
                    text: "精品歌单"
                    color: "#7F" + thisTheme.fontColor
                }
                QCToolTipButton {
                    width: 30
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    cursorShape: Qt.PointingHandCursor
                    rotation: titleItem.isDropDown ? 0 : -90
                    iconSource: "qrc:/Images/dropDown.svg"
                    hovredColor: "#2F" + thisTheme.iconColor
                    iconColor: "#FF" + thisTheme.fontColor
                    onClicked: function (mouse) {
                        titleItem.isDropDown = !titleItem.isDropDown
                    }
                    Behavior on rotation {
                        RotationAnimation {
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }


        }
        Item {
            id: contentItem
            width: parent.width
            height: titleItem.isDropDown ? 0 : spacing * (rows) +contentItemHeight *(rows)
            opacity: titleItem.isDropDown ? 0 : 1

            Behavior on opacity {
                NumberAnimation {
                    property: "opacity"
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on height {
                NumberAnimation {
                    property: "height"
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            Repeater {
                id: contentRepeater
                width: parent.width
                model: 0
                delegate: Item {
                    property int thisRows: Math.floor(index / columns)
                    property int thisColumns: Math.abs((columns * thisRows) - index)
                    y: if(thisRows > 0) return thisRows * contentItemHeight + thisRows*spacing
                    else return 0
                    x: if(thisColumns > 0) return thisColumns * contentItemWidth + (thisColumns)*spacing
                    else return 0
                    visible: false
                    width: contentItemWidth
                    height: contentItemHeight

                    Column {
                        width: parent.width
                        height: parent.height
                        spacing: 10
                        padding: 0
                        RoundImage {
                            id: albumCoverImg
                            property bool isHoverd: false
                            width: contentItemWidth
                            height: width
                            y: isHoverd ? -15 : 0
                            source: contentData ? contentData[index].coverImg + "?thumbnail=" + 220 + "y" + 220
                                                      : ""
                            sourceSize: Qt.size(220,220)

                            Behavior on y {

                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
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
                                onEntered: {
                                    parent.isHoverd = true
                                }
                                onExited: {
                                    parent.isHoverd = false
                                }
                            }
                        }
                        Text {
                            width: parent.width
                            height: parent.height - albumCoverImg.height - parent.spacing*2 - createDate.height
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            font.pointSize: 11
                            text: contentData[index].name
                            color: "#" + thisTheme.fontColor
                        }
                        Text {
                            id: createDate
                            width: parent.width
                            height: contentHeight
                            elide: Text.ElideRight
                            font.pointSize: 11
                            text:Qt.formatDateTime(new Date(contentData[index].createTime),"yyyy-MM-dd")
                            color: "#AF" + thisTheme.fontColor
                        }
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
//        contentItem.height = spacing * (rows) +contentItemHeight *(rows)
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
        let stY = boutiquePlayListItem.startY
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
