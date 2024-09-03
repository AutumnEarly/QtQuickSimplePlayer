// FolderShowItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageLocalFolderDetail.js" as PageLocalFolderJS
import "../../singletonComponent"

/*
    歌单 显示方式：文件夹
*/
Item {
    width: parent.width
    height: parent.height

    Rectangle { // 选择背景
       y: selectFolder.y - 5
       width: selectFolder.width
       height: selectFolder.count <= 0 ? 0 : selectFolder.height + 10
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }
    Rectangle { // 单曲背景
       x: selectFolder.width + 20
       y: localMusicListVeiw.y - 10
       width: localMusicListVeiw.width
       height: localMusicListVeiw.count <= 0 ? 0: localMusicListVeiw.height + 20
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }
    Column {
        width: parent.width
        height: parent.height
        spacing: 20
        Row {
            width: parent.width
            height: parent.height
            spacing: 20
            ListView {
                id: selectFolder
                property int current: 0
                width: 200
                height: contentHeight > parent.height ? parent.height : contentHeight
                clip: true
                model: foldersData.length
                QCScrollBar.horizontal: QCScrollBar {
                    handleHeight: 5
                    handleNormalColor: "#1F" + thisTheme.iconColor
                }
                QCScrollBar.vertical: QCScrollBar {
                    handleHeight: 5
                    handleNormalColor: "#1F" + thisTheme.iconColor
                }
                delegate: Rectangle {

                    width: children[0].width > selectFolder.width ? children[0].width: selectFolder.width
                    height: children[0].height
                    color: if(selectFolder.current === index) return "#2F" + thisTheme.iconColor
                    else return "#" + thisTheme.backgroundColor_2
                    MouseArea {
                        width: children[0].width + 20
                        height: children[0].height + 20
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        anchors.centerIn: parent
                        onClicked: {
                            selectFolder.current = index
                            localFolderPage.contentData = localFolderPage.foldersData[index].data
                        }

                        Text {
                            id: urlText
                            width: contentWidth
                            height: contentHeight
                            font.pointSize: 10
                            anchors.verticalCenter: parent.verticalCenter
                            text: parseUrl(localFolderPage.foldersData[index].url.slice(0))
                            color: "#" + thisTheme.fontColor
                            onContentWidthChanged: function (contentWidth) {
                                if(contentWidth > selectFolder.width && selectFolder.contentWidth < contentWidth) {
                                    selectFolder.contentWidth = contentWidth
                                }
                            }
                            function parseUrl(url) {
                                url = url.slice(url.lastIndexOf("/")+1)
                                return url
                            }
                        }
                    }


                }

            }

            ListView {
                id: localMusicListVeiw
                width: parent.width - selectFolder.width - parent.spacing
                height: parent.height
                model: contentData
                clip: true
                QCScrollBar.vertical: QCScrollBar {
                    handleHeight: 8
                    handleNormalColor: "#1F" + thisTheme.iconColor
                }
                delegate: Rectangle {
                    property bool isHoverd: false
                    property int localCurrent: -1
                    width: localMusicListVeiw.width - 30
                    height: 80
                    radius: 12
                    color: if(localMusicListVeiw.currentIndex === index) return  "#3F" + thisTheme.iconColor
                    else if(isHoverd) return  "#2F" + thisTheme.iconColor
                    else return Qt.rgba(0,0,0,0)
                    onParentChanged: {
                        if(parent != null) {
                            anchors.horizontalCenter = parent.horizontalCenter
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onDoubleClicked: function (mouse) {
                            if( mouse.button === Qt.LeftButton ) {
                                PageLocalFolderJS.addPlayOneMusic(index , localCurrent)
                            }
                        }

                        onClicked: function (mouse){
                            if( mouse.button === Qt.LeftButton ) {
                                localMusicListVeiw.currentIndex = index
                            }
                            if( mouse.button === Qt.RightButton ) {
                                PageLocalFolderJS.openRightMenu(parent,mouseX,mouseY,index)
                            }

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
                                width: 40
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                Text {
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.pointSize: fontSize
                                    font.weight: 2
                                    elide: Text.ElideRight
                                    text: index+1
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
                            }

                            Text {
                                width: parent.width * .4
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
                                width: parent.width *.25 - 40

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
                                                if(getArtistInfo.id === "") return
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
                                width: parent.width *.25 - 50
                                height: children[0].height
                                anchors.verticalCenter: parent.verticalCenter
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: {
                                    let lb = leftBar
                                    let rc = rightContent
                                    let getAlbumInfo = contentData[artistsList.thisIndex].album
                                    if(getAlbumInfo.id === "") return
    s
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

                Component.onCompleted: {
                    currentIndex = -1
                }
            }

        }


    }

}
