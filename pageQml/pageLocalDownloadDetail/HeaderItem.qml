// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageLocalDownloadDetail.js" as PageLocalDownloadJS

/*
    本地与下载 头部部分
*/

Item {
    width: musicLocalDownloadPageListView.width - 60
    height: children[0].height + 70
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
        width: parent.width
        height: PageLocalDownloadJS.getAllHeight(children,spacing)
        anchors.top: parent.top
        anchors.topMargin: 30
        spacing: 20
        Rectangle {
            id: headerSelect
            radius: width/2
            color: "#0F" + thisTheme.iconColor
            Row {
                Repeater {
                    model: ListModel {
                        Component.onCompleted: {
                            append(musicLocalDownloadPage.headerData)
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
                    PageLocalDownloadJS.playerAll()
                }
            }

            QCToolTipButton {
                width: parent.height
                height: width
                iconSource: "qrc:/Images/folder.svg"
                hovredColor: "#1F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                onClicked: {
                    PageLocalDownloadJS.addLocalMusic()


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
                font.pointSize: musicLocalDownloadPage.fontSize
                font.bold: musicLocalDownloadPage.headerCurrent  === index
                anchors.centerIn: parent
                text: headerText
                color: "#"+ thisTheme.fontColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: function (mouse){
                    forceActiveFocus()
                    headerCurrent = index
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

