// PageMusicLyricDetail.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "./pageMusicLyricDetail"
import "../qcComponent"
import "../"

/*
    歌词详情页
*/
MouseArea {
    id: musicLyricPage
    property ListModel lyricData: ListModel{}
    property int backgroundImgBlur: 120

    property bool isShow: false
    visible: true
    hoverEnabled: true

    function setHeight(children,spacing) {
        var h = 0
        for(var i = 0;i < children.length;i++) {
            if(children[i] instanceof Text) {
                h += children[i].contentHeight
            } else {
                h += children[i].height
            }
        }
        h += (children.length-1) *spacing
//        console.log("height: " + h)
        return h
    }

    HeaderItem {
        id: header
    }
    ContentItem {
        id: content
    }
    FooterItem {
        id: footer
    }

    BackgroundManager {
        id: backgroundManager
        z: -1
    }
}
