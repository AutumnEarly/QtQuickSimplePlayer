// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayListDetail.js" as PageMyPlayListJS

/*
    我的歌单 头部部分
*/

Item {
    id: listViewHeader
    width: parent.width - 60
    height: children[0].height + 70
    anchors.horizontalCenter: parent.horizontalCenter
    Column {
        width: parent.width
        height: PageMyPlayListJS.getAllHeight(children,spacing)
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
                source: playListInfo ? playListInfo.coverImgMode === "0" ?
                            playListInfo.coverImg + "?thumbnail=" + 200 + "y" + 200 :
                            playListInfo.userCoverImg : ""
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
                    text: playListInfo ?  playListInfo.type
                                            : "歌单"
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: 25
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: playListInfo ? playListInfo.name
                                            : ""
                }
                Text {
                    width: parent.width
                    height: contentHeight
                    font.pointSize: fontSize - 2
                    wrapMode: Text.Wrap
                    elide: Text.ElideRight
                    color: "#"+ thisTheme.fontColor
                    text: playListInfo ? playListInfo.description
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
                    PageMyPlayListJS.playerAll()
                }
            }

            QCToolTipButton {
                width: parent.height
                height: width
                iconSource: "qrc:/Images/addPlayList.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                onClicked: {
                    PageMyPlayListJS.addPlayAll()
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
    QCToolTipButton {
        id: editPlayList
        width: 50
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 20
        cursorShape: Qt.PointingHandCursor
        iconSource: "qrc:/Images/editPlayList.svg"
        hovredColor: "#0F" + thisTheme.iconColor
        iconColor: "#" +thisTheme.iconColor
        onClicked: {
            let lb = leftBar
            let rc = rightContent
            let playListInfo = musicPlayListPage.playListInfo
            var func = () => {
                lb.thisBtnText = ""
                rc.thisQml = "pageQml/PageEditMyPlayListDetail.qml"
                rc.item.playListInfo = playListInfo
                rc.item.playListInfo_2 = JSON.parse(JSON.stringify(playListInfo))
            }
            func()
            rightContent.push({callBack:func,name:"myPlayList: "+ playListInfo.name ,data: {}})
        }
    }
}
