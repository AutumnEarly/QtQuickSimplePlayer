// HeaderDelegate.qml
import QtQuick
import QtQuick.Controls
import "../../qcComponent"
import "./pageArtistsDetail.js" as PageArtistJS

/*
    歌手详情页 头部部分
*/
Item {
    id: listViewHeader
    width: artistsPage.width - 60
    height: children[0].height + 70
    anchors.horizontalCenter: parent.horizontalCenter
    Column {
        width: parent.width
        height: PageArtistJS.getAllHeight(children,spacing)
        padding: 0
        anchors.top: parent.top
        anchors.topMargin: 40
        spacing: 20
        Row {
            width: parent.width
            height: 200
            spacing: 20
            RoundImage {
                id: playListDetailCoverImg
                width: parent.height
                height: width
                source: artistInfo ? artistInfo.picUrl + "?thumbnail=" + 240 + "y" + 240
                                          : ""
                sourceSize: Qt.size(240,240)
            }
            Column {
                width: parent.width - playListDetailCoverImg.width - parent.spacing
                anchors.verticalCenter: playListDetailCoverImg.verticalCenter
                spacing: 15
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: artistsPage.fontSize - 1
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#FF" + thisTheme.iconColor
                    text: "艺术家"
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: 25
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: artistInfo ? artistInfo.name
                                            : ""
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: fontSize - 2
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: artistInfo ? artistInfo.briefDesc
                                            : ""
                }
            }

        }

        Rectangle {
            id: headerSelect
            radius: width/2
            color: "#0F" + thisTheme.iconColor
            Row {
                Repeater {
                    model: ListModel {
                        Component.onCompleted: {
                            append(artistsPage.headerData)
                        }
                    }
                    delegate: headerSelectDelegate
                    onCountChanged: {
                        var w = 0
                        var h = 0
                        for(var i = 0; i < count;i++) {
                            w += itemAt(i).width
                            if(h < itemAt(i).height) {
                                h = itemAt(i).height
                            }
                        }
                        headerSelect.width = w
                        headerSelect.height = h
                    }

                }
            }
        }

    }

    Component {
        id: headerSelectDelegate
        Rectangle {
            property bool isHoverd: false
            width: children[0].contentWidth + 35
            height: children[0].contentHeight + 25
            radius: width/2
            color: if(headerCurrent === index) return "#2F" + thisTheme.iconColor
            else if(isHoverd) return "#1F" + thisTheme.iconColor
            else return "#00000000"

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type:  Easing.InOutQuad
                }
            }

            Text {
                font.pointSize: artistsPage.fontSize
                font.bold: artistsPage.headerCurrent  === index
                anchors.centerIn: parent
                text: headerText
                color: "#"+ thisTheme.fontColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: function (mouse){
                    headerCurrent = index
                    PageArtistJS.selectMode(index)
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

