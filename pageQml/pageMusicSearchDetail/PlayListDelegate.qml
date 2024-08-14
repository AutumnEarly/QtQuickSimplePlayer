// PlayListDelegate.qml
import QtQuick 2.15
import "../../qcComponent"

/*
    搜索页 歌单委托项
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
    Row {
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        spacing: 10

        RoundImage {
            width: parent.height
            height: width
            source:  coverImg + "?param=" + width + "y" + height
        }
        Text {
            width: parent.width * .4
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 1
            font.weight: 2
            elide: Text.ElideRight
            text: name
            color: "#"+ thisTheme.fontColor
        }
        Text {
            width: parent.width *.3 - parent.height
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 1
            font.weight: 2
            elide: Text.ElideRight
            text: nickname
            color: "#"+ thisTheme.fontColor
        }
        Text {
            width: parent.width *.1
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 2
            font.weight: 2
            elide: Text.ElideRight
            text: trackCount
            color: "#"+ thisTheme.fontColor
        }
        Text {
            width: parent.width *.2
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 2
            font.weight: 2
            elide: Text.ElideRight
            text: playCount
            color: "#"+ thisTheme.fontColor
        }
    }
    onParentChanged: {
        if(parent != null) {
            anchors.horizontalCenter = parent.horizontalCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onDoubleClicked: {
            let lb = leftBar
            let rc = rightContent
            let musicPlayListInfo = {id:id,type:"歌单",name:name,coverImg:coverImg,nickname:nickname,description:description}
            var func = () => {
                lb.thisBtnText = ""
                rc.thisQml = "pageQml/PageMusicPlayListDetail.qml"
                rc.item.musicPlayListInfo = musicPlayListInfo
            }
            func()
            rightContent.push({callBack:func,name:leftBar.thisBtnText ,data: {}})
        }

        onClicked: function (mouse) {
            forceActiveFocus()
            contentCurrent = index
        }
        onEntered: {
            parent.isHoverd = true
        }
        onExited: {
            parent.isHoverd = false
        }
    }
}

