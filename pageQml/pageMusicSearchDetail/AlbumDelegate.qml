// AlbumDelegate.qml
import QtQuick 2.15
import "../../qcComponent"

/*
    搜索页 专辑委托项
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
            source: coverImg + "?param=" + width + "y" + height
        }
        Text {
            width: parent.width * .5
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 1
            font.weight: 2
            elide: Text.ElideRight
            text: name
            color: "#"+ thisTheme.fontColor
        }
        Text {
            width: parent.width *.5 - parent.height
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: fontSize - 1
            font.weight: 2
            elide: Text.ElideRight
            text: artist
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
            let getAlbumInfo = contentModel.get(index)
            var func = () => {
                lb.thisBtnText = ""
                rc.thisQml = "pageQml/PageMusicAlbumDetail.qml"
                rc.item.getAlbumInfo = getAlbumInfo
            }
            func()
            rightContent.push({callBack:func,name:"album: "+ getAlbumInfo.name ,data: {}})

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

