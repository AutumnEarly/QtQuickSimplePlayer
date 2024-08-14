import QtQuick
import QtQuick.Controls
Rectangle {
    id: playListLable
    property string fontColor: "#000000"
    property string normalColor: "#FFFFFF"
    property string hoverdColor: "#FFFFFF"
    property string text: ""
    property string imgSource: ""
    property alias button: btn
    property alias imgSourceSize: coverImg.sourceSize
    property double spacing: 10
    property double padding: 15
    property int fontSize: 11
    width: 100
    height: width * 1.3
    radius: 10

    signal btnClicked()
    signal clicked()

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: playListLable
                color: normalColor
            }
            PropertyChanges {
                target: btn
                y: btn.parent.height
            }
            PropertyChanges {
                target: btn
                opacity: 0
            }
        },
        State {
            name: "hoverd"
            PropertyChanges {
                target: playListLable
                color: hoverdColor
            }
            PropertyChanges {
                target: btn
                y: btn.parent.height - btn.height - padding
            }
            PropertyChanges {
                target: btn
                opacity: 1
            }
        }
    ]
    transitions: [
        Transition {
            from: "normal"
            to: "hoverd"
            ColorAnimation {
                target: playListLable
                property: "color"
                duration: 300
                easing.type: Easing.InOutQuart
            }
            PropertyAnimation {
                target: btn
                property: "y"
                duration: 300
                easing.type: Easing.InOutQuart
            }
            PropertyAnimation {
                target: btn
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuart
            }
        },
        Transition {
            from: "hoverd"
            to: "normal"
            ColorAnimation {
                target: playListLable
                property: "color"
                duration: 300
                easing.type: Easing.InOutQuart
            }
            PropertyAnimation {
                target: btn
                property: "y"
                duration: 300
                easing.type: Easing.InOutQuart
            }
            PropertyAnimation {
                target: btn
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuart
            }
        }
    ]
    MouseArea {
        width: parent.width
        height: parent.height
        hoverEnabled: true
        onClicked: {
            parent.clicked()
        }
        onEntered: {
            parent.state = "hoverd"
        }
        onExited: {
             parent.state = "normal"
        }

        RoundImage {
            id: coverImg
            width: parent.width - padding*2
            height: width
            y: padding
            anchors.topMargin: padding
            anchors.horizontalCenter: parent.horizontalCenter
            source: playListLable.imgSource

            clip: true
            QCToolTipButton {
                id: btn
                width: 50
                height: width
                x: parent.width - width - padding
                y: parent.height - height - padding
                scale: isHovred ? 1.1 : 1
                onClicked: {
                    btnClicked()
                }
                Behavior on scale {
                    ScaleAnimator {
                        target: playListLable
                        duration: 300
                        easing.type: Easing.InOutQuart
                    }
                }
            }
        }
        Text {
            width: parent.width - playListLable.padding*2
            height: parent.height - coverImg.height - spacing -  playListLable.padding
            anchors.top: coverImg.bottom
            anchors.topMargin: spacing
            anchors.horizontalCenter: parent.horizontalCenter
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            font.pointSize: fontSize
            text: playListLable.text
            color: fontColor
        }

    }
}
