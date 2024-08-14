// AlbumsDelegate.qml
import QtQuick
import QtQuick.Controls
import "../../qcComponent"
import "./pageArtistsDetail.js" as PageArtistJS

/*
    歌手详情页 专辑委托项
*/

Item {
    property var loadItem: [] // 当前加载的组件下标
    property real contentItemWidth: 160 // 加载的组件宽度
    property real contentItemHeight: contentItemWidth * 1.4 // 加载的组件高度
    property real minContentItemWidth: 160  // 加载的组件最小宽度
    property real spacing: 20
    property int columns: 4
    property int rows: 4

    width: artistsPageListView.width - 60
    height: contentItemHeight * rows + rows * spacing
    onParentChanged: {
        if(parent != null) {
            anchors.horizontalCenter = parent.horizontalCenter
        }
    }
    onWidthChanged: {
        setContentItemSize()
    }
    Connections {
        target: artistsPageListView
        function onContentYChanged() {
            contentItemLoaderTimer.start()
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
                    source: albumsData ? albumsData[index].picUrl + "?thumbnail=" + 250 + "y" + 250
                                              : ""
                    sourceSize: Qt.size(250,250)

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
                            let getAlbumInfo = albumsData[index]
                            var func = () => {
                                lb.thisBtnText = ""
                                rc.thisQml = "pageQml/PageMusicAlbumDetail.qml"
                                rc.item.getAlbumInfo = getAlbumInfo
                            }
                            func()
                            rightContent.push({callBack:func,name:"album: "+ getAlbumInfo.name ,data: {}})
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
                    text: albumsData[index].name
                    color: "#" + thisTheme.fontColor
                }
                Text {
                    id: createDate
                    width: parent.width
                    height: contentHeight
                    elide: Text.ElideRight
                    font.pointSize: 11
                    text: Qt.formatDateTime(new Date(albumsData[index].publishTime),"yyyy-MM-dd")
                    color: "#AF" + thisTheme.fontColor
                }
            }


        }

        onCountChanged: {
            setContentItemSize()
        }
        Component.onCompleted: {
            contentItemLoaderTimer.start()
        }
    }

    Timer { // 加载组件函数消抖
        id: contentItemLoaderTimer
        interval: 200
        onTriggered: {
            setContentItemLoader(artistsPageListView.contentY,albumsData)
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
        rows = Math.ceil(albumsData.length / columns)
//                height = spacing * (rows) +contentItemHeight *(rows)
    }
    /*
        加载组件(显示组件)或隐藏组件
    */
    function setContentItemLoader(contentY , arr = []) {
        if(arr.length <= 0) return
        let step = artistsPageListView.wheelStep
        let i = 0
        let rows = 0
        let t = loadItem.slice(0,loadItem.length)
        let stY = artistsPageListView.headerItem.height
        loadItem = []
        let startRows = contentY / contentItemHeight
        for(i = 0; i < arr.length;i++) {
            rows = Math.floor(i / columns)
            var startY = (stY + rows * contentItemHeight + (rows-1)* spacing)
            var endY = (artistsPageListView.contentY +artistsPageListView.height)
            if((startY+contentItemHeight+step) >= contentY) {
                if(startY < endY+step) {
                    loadItem.push(i)
                } else break
            }
        }
        if(loadItem[loadItem.length - 1] > contentRepeater.count ) { // 如果组件未加载那么加载
            contentRepeater.model = loadItem[loadItem.length - 1]+1
        }
        let scrollDirection = artistsPageListView.scrollDirection
        if(scrollDirection === 0) { // 设置显示方向
            for(i = 0 ; i < loadItem.length;i ++) { // 显示视图内组件
                contentRepeater.itemAt(loadItem[i]).visible = true
            }
        } else {
            for(i = loadItem.length - 1; i >= 0;i --) { // 显示视图内组件
                contentRepeater.itemAt(loadItem[i]).visible = true
            }
        }

        for(i = 0; i < t.length;i++) {
            if(loadItem.indexOf(t[i]) === -1) { // 隐藏视图内组件
                contentRepeater.itemAt(t[i]).visible = false
            }
        }

//                console.log("loadItems: " + JSON.stringify(loadItem))
    }

}
