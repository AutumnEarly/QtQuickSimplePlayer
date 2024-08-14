// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "./pageMusicSearchDetail.js" as PageSearchJS

/*
    搜索页 头部部分
*/

Item { // 头部部分
    id: header
    width: musicSearchPageFlickable.width- 80
    height: PageSearchJS.getAllHeight(children,0)
    anchors.top: parent.top
    anchors.topMargin: 20
    anchors.horizontalCenter: parent.horizontalCenter

    Column { // 头部部分排版
        width: parent.width
        height: PageSearchJS.getAllHeight(children,spacing)
        spacing: 15
        Text { // 搜索文本
            width: parent.width
            height: contentHeight
            font.pointSize: fontSize + 5
            wrapMode: Text.Wrap
            text: "搜索音乐 " + searchText
            color: "#"+ thisTheme.fontColor
        }

        Rectangle { // 选择搜索类型栏

            radius: width/2
            color: "#0F" + thisTheme.iconColor
            Row {
                Repeater {
                    model: ListModel {
                    }
                    delegate: headerDelegate
                    onCountChanged: {
                        var w = 0
                        var h = 0
                        for(var i = 0; i < count;i++) {
                            w += itemAt(i).width
                            if(h < itemAt(i).height) {
                                h = itemAt(i).height
                            }
                        }
                        parent.parent.width = w
                        parent.parent.height = h
                    }
                    Component.onCompleted: {
                        model.append(headerData)
                    }
                }
            }
        }

        Row { // 功能按钮
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
                propagateComposedEvents: true
                onClicked: function (mouse) {
                    mouse.accepted = false

                }
            }

            QCToolTipButton {
                width: parent.height
                height: width
                iconSource: "qrc:/Images/addPlayList.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                propagateComposedEvents: true
                onClicked: function (mouse) {
                    mouse.accepted = false
                }
            }
        }

        Row { // 单曲提示文本
            visible: headerData[headerCurrent].type === "1"

            width: parent.width - 30
            height: headerData[headerCurrent].type === "1" ? children[0].contentHeight : 0
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

