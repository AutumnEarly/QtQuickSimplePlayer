import QtQuick
import QtQuick.Controls
import "../"
import "../singletonComponent"

MouseArea {
    id: qcVolumeBtn
    property string textColor: ""
    property string backgroundColor: ""
    property string sliderBackgroundColor: ""
    property string sliderColor: ""
    property string handleColor: ""
    property string handleBorderColor: ""
    property string btnColor: ""
    property string btnIconColor: ""
    property string btnHovredColor: ""
    width: parent.height
    height: 165
    anchors.bottom: parent.bottom
    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: volumeSliderBackground
                height: 0
                opacity: 0
            }
        },
        State {
            name: "hoverd"
            PropertyChanges {
                target: volumeSliderBackground
                height: 130
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "normal"
            to: "hoverd"
            NumberAnimation {
                target: volumeSliderBackground
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: volumeSliderBackground
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "hoverd"
            to: "normal"
            NumberAnimation {
                target: volumeSliderBackground
                property: "height"
                duration: 300
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: volumeSliderBackground
                property: "opacity"
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    ]

    hoverEnabled: true
    onClicked: function (mouse) {
        mouse.accepted = false
    }
    onExited: {
        qcVolumeBtn.state = "normal"
    }
    Rectangle {
        id: volumeSliderBackground
        width: parent.width
        height: 130
        color: backgroundColor
        radius: 12
        anchors.bottom: volumeIconBtn.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            anchors.bottom: volumeSlider.top
            anchors.bottomMargin: 1
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: volumeSlider.pressed ? 1 : 0
            color: textColor
            text: parseInt(volumeSlider.value *100)
        }

        Slider {
            id: volumeSlider
            width: 12
            height: parent.height - 40
            visible: true
            anchors.centerIn: parent
            orientation: Qt.Vertical
            from: 0.
            value: p_music_Player.volume
            to: 1.
            background: Rectangle {
                radius: width/2
                color: sliderBackgroundColor
                Rectangle {
                    width: parent.width
                    height:(1-volumeSlider.visualPosition) * parent.height
                    anchors.bottom: parent.bottom
                    radius: width/2
                    color: sliderColor
                }
            }
            handle: Rectangle {
                z: 2
                implicitWidth: 20
                implicitHeight: width
                x: -((width - volumeSlider.width)/2)
                y: (volumeSlider.availableHeight - height)*volumeSlider.visualPosition
                color: volumeSlider.pressed ? handleBorderColor : handleColor
                border.width: 1.5
                border.color: handleBorderColor
                radius: 100
            }
            onMoved: {
                p_music_Player.lastVolume = p_music_Player.volume
                p_music_Player.volume = value
            }
        }
    }

    QCToolTipButton {
        id: volumeIconBtn
        width: 35
        height: width
        propagateComposedEvents: true
        cursorShape: Qt.PointingHandCursor
        anchors.bottom: parent.bottom
        iconSource: if(volumeSlider.value) return "qrc:/Images/volume.png"
        else return "qrc:/Images/stopVolume.png"
        hovredColor: btnHovredColor
        iconColor: btnIconColor
        onClicked: function (mouse) {
            mouse.accepted = false
            if(p_music_Player.volume !== 0 ) {
                p_music_Player.volume = 0
            } else {
                p_music_Player.volume = p_music_Player.lastVolume
            }
        }
        onEntered: {
            qcVolumeBtn.state = "hoverd"
        }
    }
}

