// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayListDetail.js" as PagePlayListDetailJS

/*
    歌单详情 头部部分
*/

Item {
    id: listViewHeader
    width: parent.width - 60
    height: children[0].height + 70
    anchors.horizontalCenter: parent.horizontalCenter
    Column {
        width: parent.width
        height: PagePlayListDetailJS.getAllHeight(children,spacing)
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
                source: musicPlayListInfo ? musicPlayListInfo.coverImg + "?thumbnail=" + 240 + "y" + 240
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
                    font.pointSize: musicPlayListPage.fontSize - 1
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#FF" + thisTheme.iconColor
                    text: musicPlayListInfo ?  musicPlayListInfo.type
                                            : "歌单"
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: 25
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: musicPlayListInfo ? musicPlayListInfo.name
                                            : ""
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: fontSize - 2
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: musicPlayListInfo ? musicPlayListInfo.description
                                            : ""
                }
            }

        }

        Row {
            width: parent.width
            height: 55
            spacing: 15
            QCToolTipButton {
                width: parent.height
                height: width
                color: "#" +thisTheme.iconColor
                iconSource: "qrc:/Images/player.svg"
                hovredColor: "#" + thisTheme.iconColor
                iconColor: "#"+ thisTheme.iconColor_2
                transformOrigin: Item.Center
                onEntered: {
                    scale = 1.2
                }
                onExited: {
                    scale = 1
                }

                Behavior on scale {
                    ScaleAnimator {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
                onClicked: {
                    PagePlayListDetailJS.playerAll()
                }
            }

            QCToolTipButton {
                width: parent.height
                height: width
                iconSource: "qrc:/Images/addPlayList.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                onClicked: {
                    PagePlayListDetailJS.addPlayAll()
                }
            }
        }

        Row {
            width: parent.width - 30
            height: children[0].contentHeight
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                width: 70
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: fontSize
                font.weight: 2
                elide: Text.ElideRight
                text: "#"
                color: "#"+ thisTheme.fontColor
            }
            Text {
                width: parent.width * .3
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: fontSize
                font.weight: 2
                elide: Text.ElideRight
                text: "歌名"
                color: "#"+ thisTheme.fontColor
            }
            Text {
                width: parent.width *.3 - 40
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: fontSize
                font.weight: 2
                elide: Text.ElideRight
                text: "作者"
                color: "#"+ thisTheme.fontColor
            }
            Text {
                width: parent.width *.3 - 80
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: fontSize
                font.weight: 2
                elide: Text.ElideRight
                text: "专辑"
                color: "#"+ thisTheme.fontColor
            }
            Text {
                width: parent.width *.1
                horizontalAlignment: Text.AlignLeft
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: fontSize
                font.weight: 2
                elide: Text.ElideRight
                text: "时长"
                color: "#"+ thisTheme.fontColor
            }

        }

    }
}

