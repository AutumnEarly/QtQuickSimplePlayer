// OneMusicDelegate.qml
import QtQuick 2.15
import "../../qcComponent"
import  "../../singletonComponent"

/*
    搜索页 单曲委托项
*/

Rectangle {
    property bool isHoverd: false
    visible: false
    x:0
    y: index * contentItemHeight+15
    width: content.width - 20
    height: contentItemHeight
    radius: 12
    color: if(contentCurrent === index) return  "#3F" + thisTheme.iconColor
    else if(isHoverd) return  "#2F" + thisTheme.iconColor
    else return Qt.rgba(0,0,0,0)
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onDoubleClicked: {
            var musicInfo = [{
                id: contentData[index].id,name: contentData[index].name,artists: contentData[index].artists,album: contentData[index].album,
                url: "", coverImg: contentData[index].coverImg,allTime: contentData[index].allTime
            }]
            var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === contentData[index].id)
            if(downloadBtn.current >= 0) {
                musicInfo[0].url = p_musicDownload.data[downloadBtn.current].url
            }
            console.log("PageMusicSearchDetail.qml: " + findIndex)
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
            musicSearchPage.contentCurrent = index
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
                width: 70
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    horizontalAlignment: Text.AlignHCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: fontSize
                    font.weight: 2
                    elide: Text.ElideRight
                    text: index+1+ musicSearchPage.thisPage * musicSearchPage.limit
                    color: "#"+ thisTheme.fontColor
                }
                QCToolTipButton {
                    id: favoriteBtn
                    property bool isFavorite: false
                    width: 30
                    height: width
                    cursorShape: Qt.PointingHandCursor
                    iconSource: if(isFavorite) return "qrc:/Images/myFavorite2.svg"
                    else return "qrc:/Images/myFavorite.svg"
                    iconColor: "#"+ thisTheme.fontColor
                    hovredColor: "#00000000"
                    color: "#00000000"
                    onClicked: {
                        if(isFavorite) {
                            isFavorite = false
                            FavoriteManager.remove(contentData[index].id)
                            iconSource = "qrc:/Images/myFavorite.svg"
                        } else {
                            isFavorite = true
                            FavoriteManager.append(contentData[index])
                            iconSource = "qrc:/Images/myFavorite2.svg"
                        }
                    }
                    Component.onCompleted: {
                        isFavorite = FavoriteManager.favoriteIndexOf(contentData[index].id) < 0 ? false : true
                    }
                }

                QCToolTipButton {
                    id: downloadBtn
                    property int current: -1
                    width: 30
                    height: width
                    cursorShape: Qt.PointingHandCursor
                    iconSource: if(downloadBtn.current >= 0) return "qrc:/Images/download_OK.svg"
                    else return "qrc:/Images/download.svg"
                    iconColor: "#"+ thisTheme.fontColor
                    hovredColor: "#00000000"
                    color: "#00000000"
                    onClicked: {
                        var musicUrlcallBack = res=> {
                            var url = res.data.url
                            if(!url) {
                                console.log("下载失败！")
                                return
                            }
                            var ar = contentData[index].artists.map(ar => ar.name).join(",")
                            console.log("下载地址: " + url)
                            p_musicDownload.addTask(url,ar + " - "+contentData[index].name,contentData[index].id)
                            p_musicDownload.startDownload(contentData[index].id,contentData[index])
                        }

                        p_musicRes.getMusicUrl({id:contentData[index].id,callBack:musicUrlcallBack})
                    }
                    Component.onCompleted: {
                       downloadBtn.current = p_musicDownload.loaclIndexOf(contentData[index].id)
                    }
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
                width: parent.width *.3 - 40

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
                                rightContent.push({callBack:func,name:lb.thisBtnText ,data: {}})
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
                    rightContent.push({callBack:func,name:lb.thisBtnText ,data: {}})
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

    onParentChanged: {
        if(parent != null) {
            anchors.horizontalCenter = parent.horizontalCenter
        }
    }

}

