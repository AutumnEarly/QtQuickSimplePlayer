// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageHistoryRecordDetail.js" as PageHistoryRecordJS

/*
    最近播放 头部部分
*/

Item {
    width: historyRecordPageListView.width - 60
    height: children[0].height + 70
    anchors.horizontalCenter: parent.horizontalCenter

    Column {
        width: parent.width
        height: PageHistoryRecordJS.getAllHeight(children,spacing)
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
                            append(historyRecordPage.headerData)
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
                font.pointSize: historyRecordPage.fontSize
                font.bold: historyRecordPage.headerCurrent  === index
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

