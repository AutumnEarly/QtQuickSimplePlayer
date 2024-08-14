import QtQuick

Item { // 尾部部分
    id: footer
    property string color: ""
    property string borderColor: ""
    property string fontColor: ""
    property string preBtnSource: ""
    property string nextBtnSource: ""
    property int curretIndex: 0
    property int count: 10
    property int maxItems: 8
    width: parent.width
    height: 120
    signal clicked()

    Row {
        width: footer.getAllWidth(children,spacing)
        height: 35
        spacing: 10
        anchors.centerIn: parent
        Rectangle { // 后退一页
            property bool isHoverd: false
            width: 35
            height: width
            radius: 12
            color: footer.color
            QCImage {
                width: parent.width * .45
                height: width
                anchors.centerIn: parent
                rotation: 90
                source: footer.preBtnSource
                color: footer.fontColor
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: function (mouse) {
                    if(!(footer.curretIndex-1 < 0) ) {
                        footer.curretIndex = footer.curretIndex-1
                    }
                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }

            }
        }
        Repeater { // 切换页面按钮
            id: repeater
            property int offset: footer.count - footer.maxItems > 0 ?footer.count - footer.maxItems-1:0
            anchors.centerIn: parent
            model: footer.count > footer.maxItems ? footer.maxItems : footer.count
            delegate: Rectangle {
                property int thisIndex: index + repeater.setIndexOffset(footer.curretIndex)
                property bool isHoverd: false
                width: 35
                height: width
                radius: 12
                color: footer.color
                border.color: footer.curretIndex === thisIndex ? footer.borderColor : "#00000000"
                Text {
                    anchors.centerIn: parent
                    font.pointSize: 12
                    text: thisIndex+1
                    color: footer.fontColor
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: function (mouse) {
                        footer.curretIndex = parent.thisIndex
                        footer.clicked()
                    }
                    onEntered: {
                        parent.isHoverd = true
                    }
                    onExited: {
                        parent.isHoverd = false
                    }

                }
            }

            function setIndexOffset(index) {
                if(repeater.offset <=0) return 0
                if(repeater.offset - index > 0) {
                    return index
                } else {
                    return repeater.offset
                }
            }
        }
        Rectangle { // 省略
            property bool isHoverd: false
            visible: footer.count > footer.maxItems
            width: 35
            height: width
            radius: 12
            color: "#00000000"
            Text {
                anchors.centerIn: parent
                font.pointSize: 20
                text: "···"
                color: footer.fontColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: function (mouse) {

                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }

            }

        }
        Rectangle { // 切换最后一页
            property bool isHoverd: false
            visible: footer.count > footer.maxItems
            width: 35
            height: width
            radius: 12
            color: footer.color
            border.color: footer.curretIndex === footer.count-1 ? footer.borderColor : "#00000000"
            Text {
                anchors.centerIn: parent
                font.pointSize: 12
                text: footer.count
                color: footer.fontColor
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: function (mouse) {
                    footer.curretIndex = footer.count-1
                }
                onEntered: {
                    parent.isHoverd = true
                }
                onExited: {
                    parent.isHoverd = false
                }

            }
        }
        Rectangle { // 前进一页
            property bool isHoverd: false
            width: 35
            height: width
            radius: 12
            color: footer.color
            QCImage {
                width: parent.width * .45
                height: width
                anchors.centerIn: parent
                rotation: -90
                source: footer.nextBtnSource
                color: footer.fontColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: function (mouse) {
                    if(!(footer.curretIndex+1 >= footer.count) ) {
                        footer.curretIndex = footer.curretIndex+1
                    }
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
    function getAllWidth(children,spacing) {
        var w = 0
        var visibleCount = 0
        for(var i = 0; i < children.length;i++) {
            if(children[i].visible) {
                w += children[i].width
            } else {
                visibleCount++;
            }
        }
        return w + spacing * (children.length-1-visibleCount-1)
    }
}
