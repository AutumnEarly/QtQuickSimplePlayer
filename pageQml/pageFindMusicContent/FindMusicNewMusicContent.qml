import QtQuick
import QtQuick.Controls
import "../../qcComponent"
import "../../theme"

Item {
    id: newMusicContent
    property QCTheme thisTheme: ThemeManager.theme
    property var headerData: [{name:"全部",type:"0"},
    {name:"华语",type:"7"},
    {name:"欧美",type:"96"},
    {name:"韩国",type:"8"},
    {name:"日本",type:"16"},]
    property var contentData: []
    property var loadItem: []
    property double fontSize: 11
    property double startY: parent.y
    property int contentItemHeight: 80
    property int current: -1
    property int headerCurrent: 0
    width: parent.width
    height: header.height + content.height + 80

    onHeaderCurrentChanged: {
        setContentModel()
    }

    Row {
        id: header
        width: newMusicContent.width * 0.9
        height: 15
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Repeater {
            model: ListModel{}
            delegate: headerDelegate
            Component.onCompleted:  {
                model.append(headerData)
            }
        }
    }
    Component {
        id: headerDelegate
        Text {
            property bool isHoverd: false
            font.weight: 1
            font.bold: newMusicContent.headerCurrent === index || isHoverd
            font.pointSize: newMusicContent.fontSize
            text: name
            color: "#c3c3c3"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    newMusicContent.headerCurrent = index
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

    Rectangle {
        id: content
        property double startY: parent.startY + y
        width: newMusicContent.width * .9
        anchors.top: header.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        clip: false
        radius: 10
        Item {
            width: parent.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            Repeater {
                id: contentRepeater
                delegate: contentDelegate
                onCountChanged: {
                    setContentItemLoader(findMusicFlickable.contentY)
                }
            }
        }
        Component.onCompleted: {
            setContentModel()
        }
    }

    Component {
        id: contentDelegate
        Rectangle {
            property bool isHoverd: false
            width: content.width - 20
            height: newMusicContent.contentItemHeight
            visible: false
            radius: 10
            y: index * newMusicContent.contentItemHeight + 10
            color: if(newMusicContent.current === index) return "#2F" + thisTheme.iconColor
            else if(isHoverd) return "#1F" + thisTheme.iconColor
            else return "#00000000"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onDoubleClicked: {
                    var musicInfo = [{
                        id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
                        url: "", coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
                    }]
                    var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === contentData[index].id)
                    if(findIndex === -1) {
                        p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,contentData[index])
                        p_music_Player.thisPlayListInfoChanged()
                        p_music_Player.thisPlayingCurrent += 1
                    } else {
                        p_music_Player.thisPlayingCurrent = findIndex
                    }


                    p_music_Player.playMusic(contentData[index].id,musicInfo[0])

                }

                onClicked: {
                    newMusicContent.current = index
                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }
                Row {
                    width: parent.width - 20
                    height: parent.height - 20
                    anchors.centerIn: parent
                    spacing: 10

                    Row {
                        width: 90
                        height: 60
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10
                        Text {
                            horizontalAlignment: Text.AlignHCenter
                            anchors.verticalCenter: parent.verticalCenter
                            font.pointSize: fontSize
                            font.weight: 2
                            elide: Text.ElideRight
                            text: index+1
                            color: "#"+ thisTheme.fontColor
                        }
                        RoundImage {
                            id: coverImg
                            width: 60
                            height: width
                            anchors.verticalCenter: parent.verticalCenter
                            source:  contentData[index].coverImg + "?thumbnail=" + 70 + "y" + 70
                            sourceSize: Qt.size(70,70)
                        }

                    }

                    Text {
                        width: parent.width * .3
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: fontSize
                        font.weight: 2
                        elide: Text.ElideRight
                        text: contentData[index].name
                        color: "#"+ thisTheme.fontColor
                    }
                    Row {
                        id: artistsList
                        property int thisIndex: index
                        width: parent.width *.3 - 50

                        clip: true
                        spacing: 0
                        anchors.verticalCenter: parent.verticalCenter
                        Repeater {
                            id: artistsRepeater
                            model: contentData[artistsList.thisIndex].artists.length
                            delegate: Text {
                                id: artistsText
                                property int currentIndex: index
                                property bool isHoverd: false
                                height: contentHeight
                                anchors.verticalCenter: parent.verticalCenter
                                font.weight: 2
                                font.pointSize: fontSize - 1
                                text: if(index === contentData[artistsList.thisIndex].artists.length - 1) return contentData[artistsList.thisIndex].artists[index].name
                                else return contentData[artistsList.thisIndex].artists[index].name + " / "
                                color: isHoverd ? "#"+ thisTheme.fontColor : "#AF"+ thisTheme.fontColor

                                Connections {
                                    target: artistsList
                                    function onWidthChanged() {
                                        artistsText.surplusWidth()
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        let lb = leftBar
                                        let rc = rightContent
                                        let getArtistInfo = contentData[artistsList.thisIndex].artists[index]
                                        var func = () => {
                                            lb.thisBtnText = ""
                                            rc.thisQml = "pageQml/PageArtistsDetail.qml"
                                            rc.item.getArtistInfo = getArtistInfo
                                        }
                                        func()
                                        rightContent.push({callBack:func,name:"artist: "+ getArtistInfo.name ,data: {}})
                                    }

                                    onEntered: {
                                        parent.isHoverd = true
                                    }
                                    onExited: {
                                        parent.isHoverd = false
                                    }
                                }

                                function surplusWidth() {

                                    let ch = null
                                    let allWidth = 0
                                    for(let i = 0; i <= artistsText.currentIndex;i++) {
                                        allWidth += artistsRepeater.itemAt(i).contentWidth
                                    }
                                    let surplusW = artistsList.width - allWidth
                                    if(surplusW >= 0) {
                                        elide = Text.ElideNone
                                        width = contentWidth
                                    } else {

                                        if(width - Math.abs(surplusW) < width) {
                                            elide = Text.ElideRight
                                            width = width - Math.abs(surplusW)
                                        } else {
                                            width = 0
                                        }

                                    }
                                }
                            }
                            Component.onCompleted: {
                                artistsList.height = itemAt(0).height
                            }

                        }

                    }

                    MouseArea {
                        property bool isHoverd: false
                        width: parent.width *.3 - 80
                        height: children[0].height
                        anchors.verticalCenter: parent.verticalCenter
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            let lb = leftBar
                            let rc = rightContent
                            let getAlbumInfo = contentData[artistsList.thisIndex].album
                            var func = () => {
                                lb.thisBtnText = ""
                                rc.thisQml = "pageQml/PageMusicAlbumDetail.qml"
                                rc.item.getAlbumInfo = getAlbumInfo
                            }
                            func()
                            rightContent.push({callBack:func,name:"album: "+ getAlbumInfo.name ,data: {}})
                        }

                        onEntered: {
                            isHoverd = true
                        }
                        onExited: {
                            isHoverd = false
                        }
                        Text {
                            width: parent.width
                            height: contentHeight
                            horizontalAlignment: Text.AlignLeft
                            anchors.verticalCenter: parent.verticalCenter
                            font.pointSize: fontSize - 1
                            font.weight: 2
                            elide: Text.ElideRight
                            text: contentData[index].album.name
                            color: parent.isHoverd ? "#"+ thisTheme.fontColor : "#AF"+ thisTheme.fontColor
                        }
                    }


                    Text {
                        width: parent.width *.1
                        horizontalAlignment: Text.AlignLeft
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: fontSize - 2
                        font.weight: 2
                        elide: Text.ElideRight
                        text: contentData[index].allTime
                        color: "#"+ thisTheme.fontColor
                    }
                }

            }


        }
    }


    function setContentModel() {
        content.height = 0

        var musicDetailCallBack = res => {
            contentData = res.data
            content.height = contentData.length * 80 + 20
            setContentItemLoader(findMusicFlickable.contentY)
        }
        var newMusiccallBack = res => {
            var ids = res.data.map(obj => {return obj.id})
            ids = ids.join(',')
            p_musicRes.getMusicDetail({ids:ids,callBack:musicDetailCallBack})
        }
        p_musicRes.getNewMusic({type: headerData[headerCurrent].type,callBack:newMusiccallBack})
    }

    function setContentItemLoader(contentY) {
        if(contentData.length <= 0) return
        var step = findMusicFlickable.wheelStep
        var i = 0
        var t = loadItem.slice(0,loadItem.length)
        loadItem = []
        for(i = 0; i < contentData.length;i++) {
            var startY = (content.startY + i * contentItemHeight)
            var endY = (findMusicFlickable.contentY +findMusicFlickable.height)
            if(startY+step >= contentY) {
                if(startY < endY+step) {
                    loadItem.push(i)
                } else break
            }
        }

        if(loadItem[loadItem.length - 1] > contentRepeater.count ) { // 如果组件未加载那么加载
            contentRepeater.model = loadItem[loadItem.length - 1]+1
        }

        for(i = 0; i < loadItem.length;i++) {
            contentRepeater.itemAt(loadItem[i]).visible = true
        }
        for(i = 0; i < t.length;i++) {
            if(loadItem.indexOf(t[i]) === -1) {
                contentRepeater.itemAt(t[i]).visible = false
            }
        }

//        console.log("loadItems: " + JSON.stringify(loadItem))
//        console.log("lastItems: " + JSON.stringify(t))
    }
}
