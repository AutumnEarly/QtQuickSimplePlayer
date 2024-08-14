import QtQuick
import QtQuick.Controls

MouseArea {
    id: qcTipBtn
    property alias toolTip: toolTip
    property bool isHovred: false
    property bool isHighlight: false
    property string color: "#00000000"
    property string hovredColor: ""
    property string iconSource: "qrc:/Images/prePlayer.svg"
    property string iconColor: ""

    property string text: ""
    width: 30
    height: width
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onEntered:  {
        isHovred = true
        toolTip.isHoverd = true
    }
    onExited: {
        isHovred = false
        toolTip.isHoverd = false
    }
    Rectangle {
        anchors.fill: parent
        radius: 100
        color: if(isHovred || isHighlight) return parent.hovredColor
        else return parent.color
    }
    QCImage {
        width: parent.width*.55
        height: width
        anchors.centerIn: parent
        source: parent.iconSource
        sourceSize: Qt.size(32,32)
        color: parent.iconColor
    }
    Rectangle {
        id: toolTip
        property string text: qcTipBtn.text
        property alias font: toolTipText.font
        property int delay: 1000 // 延时出现
        property int timeOut: -1 // 超时消失
        property bool isHoverd: false
        z: qcTipBtn.z + 5
        width: toolTipText.contentWidth + 20
        height: toolTipText.contentHeight + 10
        anchors {
            top: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        state: "noVisible"
        states: [
            State {
                name: "noVisible"
                PropertyChanges {
                    target: toolTip
                    opacity: 0
                }
            },
            State {
                name: "visible"
                PropertyChanges {
                    target: toolTip
                    opacity: 1
                }
            }
        ]
        transitions: [
            Transition {
                from: "noVisible"
                to: "visible"
                PropertyAnimation {
                    target: toolTip
                    property: "opacity"
                    duration: 300
                    easing.type: Easing.Linear
                }
            },
            Transition {
                from: "visible"
                to: "noVisible"
                PropertyAnimation {
                    target: toolTip
                    property: "opacity"
                    duration: 300
                    easing.type: Easing.Linear
                    onStopped: {
                        console.log("00")
                    }
                }
            }
        ]
        onIsHoverdChanged: {
            if(text === "") return
            if(isHoverd) {
                toolTipTim.interval = delay
                toolTipTim.start()
            } else if(!isHoverd) {
                toolTipTim.interval = 0
                toolTip.state = "noVisible"
            }
        }
        onVisibleChanged: {
            if(visible) {
                if(timeOut > 0) {
                    toolTipTim.interval = timeOut
                    toolTipTim.start()
                }
            }
        }
        Text {
            id: toolTipText
            anchors.centerIn: parent
            text: toolTip.text
        }
        Timer {
            id: toolTipTim
            onTriggered: {
                if(toolTip.state === "noVisible" && toolTip.isHoverd) {
                    toolTip.state = "visible"
                    return
                }
                if(toolTip.state === "visible") {
                    toolTip.state = "noVisible"
                }
            }
        }
    }

}
