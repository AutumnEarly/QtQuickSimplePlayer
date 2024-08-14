// Content.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../qcComponent"
import  "../../singletonComponent"

/*
    歌词详情页 中间部分
*/

Item {
    id: content
    property alias coverItem: coverImg
    width: parent.width
    height: parent.height - header.height - footer.height
    anchors.top: header.bottom
    Row {
        width: parent.width - 20
        height: parent.height
        spacing: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        Item { // 左侧内容
            width: parent.width/2 - parent.padding
            height: parent.height
            Column {
                width: parent.width * .7
                anchors.centerIn: parent
                spacing: 25
                Item { // 封面
                    id: coverItem
                    property double maxSize: 400
                    width: parent.width*.7
                    height: width
                    RoundImage {
                        z: 44
                        id: coverImg
                        width: parent.width
                        height: width
                        source: p_music_Player.thisPlayMusicInfo.coverImg ?
                                    p_music_Player.thisPlayMusicInfo.coverImg + "?param="+ coverItem.maxSize+ "y" + coverItem.maxSize:
                                    p_music_Player.thisPlayMusicInfo.coverImg
                        sourceSize: Qt.size(width,height)
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    FastBlur {
                        z: coverImg.z-1
                        anchors.fill: coverImg
                        source: coverImg
                        radius: 60
                        transparentBorder: true
                    }

                }

                Column {
                    id: textInfo
                    property string textColor: "#CFFFFFFF"
                    property string glowColor: "#3FFFFFFF"
                    width: parent.width
                    spacing: 10
                    Text {
                        id: nameText
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        font.pointSize: 25
                        font.bold: true
                        text: p_music_Player.thisPlayMusicInfo.name
                        lineHeight: 1
                        color: textInfo.textColor
                        layer.enabled: true
                        layer.effect:  Glow {
                            width: nameText.width
                            height: nameText.height
                            source: nameText
                            spread: .1
                            radius: 12
                            samples: radius*2+1
                            color: textInfo.glowColor
                        }
                    }
                    Flow {
                        id: artistsList
                        clip: true
                        spacing: 0
                        layer.enabled: true
                        layer.effect:   Glow {
                            width: artistsList.width
                            height: artistsList.height
                            source: artistsList
                            spread: .1
                            radius: 12
                            samples: radius*2+1
                            color: textInfo.glowColor
                        }
                        Repeater {
                            id: repeater
                            model: p_music_Player.thisPlayMusicInfo.artists.length
                            delegate: Text {
                                id: artistsText
                                property int currentIndex: index
                                property bool isHoverd: false
                                width: contentWidth
                                height: contentHeight
                                font.bold: true
                                lineHeight: 1
                                font.pointSize: 15
                                text: if(index === p_music_Player.thisPlayMusicInfo.artists.length - 1) return p_music_Player.thisPlayMusicInfo.artists[index].name
                                else return p_music_Player.thisPlayMusicInfo.artists[index].name + " / "
                                color: isHoverd ? "#FFFFFF": "#AFFFFFFF"


                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if(!p_music_Player.thisPlayMusicInfo.artists[index].id) return
                                        let lb = leftBar
                                        let rc = rightContent
                                        let getArtistInfo = p_music_Player.thisPlayMusicInfo.artists[index]
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
                            }
                            onCountChanged: {
                                let w = 0
                                for(let i = 0; i < count;i++) {
                                    w += itemAt(i).width
                                }
                                artistsList.width = w
                                artistsList.height = itemAt(0).height
                            }

                        }

                    }

                    Text {
                        id: albumText
                        property bool isHoverd: false
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        font.pointSize: 15
                        font.bold: true
                        lineHeight: 1
                        text: p_music_Player.thisPlayMusicInfo.album.name
                        color: isHoverd ? "#FFFFFF": "#AFFFFFFF"
                        layer.enabled: true
                        layer.effect:   Glow {
                            width: albumText.width
                            height: albumText.height
                            source: albumText
                            spread: .1
                            radius: 12
                            samples: radius*2+1
                            color: textInfo.glowColor
                        }
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if(!p_music_Player.thisPlayMusicInfo.album.id) return
                                let lb = leftBar
                                let rc = rightContent
                                let getAlbumInfo = p_music_Player.thisPlayMusicInfo.album
                                var func = () => {
                                    lb.thisBtnText = ""
                                    rc.thisQml = "pageQml/PageMusicAlbumDetail.qml"
                                    rc.item.getAlbumInfo = getAlbumInfo
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
                    }

                }

            }
        }
        Item {
            width: parent.width/2 - parent.padding
            height: parent.height
            LyricListView { // 右侧内容
                id: lyricView
                width: parent.width
                height: content.height
                mediaPlayer: p_music_Player
                lyricData: p_music_Player.thisMusicLyric
            }
        }
    }

}

