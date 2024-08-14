import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt5Compat.GraphicalEffects
import "../theme"

Item {
    id: control
    property QCTheme thisTheme: QCTheme{}
    width: 180
    height: width * .7
    Pane {
        width: parent.width
        height: parent.height
        padding: 0
        clip: true
        visible: false
        background: Rectangle {
            clip: true
            color: "#"+ control.thisTheme.backgroundColor
        }
        Rectangle {
            id: header
            width: control.width
            height: 10
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#"+ control.thisTheme.backgroundColor
            clip: true
        }
        Row {
            id: content
            width: control.width - 10
            height: control.height - header.height - footer.height
            anchors.top: header.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            clip: true

            Rectangle {
                id: leftBar
                width: 30
                height: parent.height
                color: "#"+ control.thisTheme.backgroundColor
                Column {
                    spacing: 5
                    Repeater {
                        model: 6
                        delegate: Rectangle {
                            width: leftBar.width
                            height: 8
                            radius: width/2
                            color: "#1F"+ control.thisTheme.iconColor
                        }
                    }
                }
            }
            Pane {
                id: rightContent
                width: parent.width - leftBar.width - content.spacing
                height: parent.height - 4
                leftPadding: 5
                rightPadding: 5
                clip: true
                background: Rectangle {
                    radius: 8
                    border.width: 2
                    border.color: "#"+ control.thisTheme.backgroundColor_2
                    color: "#"+ control.thisTheme.backgroundColor
                }
                Column {
                    width: parent.width - leftPadding - rightPadding
                    height: parent.height
                    anchors.centerIn: parent
                    spacing: 5
                    Row {
                        height: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5
                        Repeater {
                            model: 3
                            delegate: Rectangle {
                                width: 35
                                height: 20
                                radius: 8
                                color: "#2F"+ control.thisTheme.iconColor
                            }
                        }
                    }

                    Grid {
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        columns: 4
                        spacing: (parent.width - (25*columns)) / (columns-1)
                        Repeater {
                            model: 8
                            delegate: Rectangle {
                                width: 25
                                height: width*1.2
                                radius: 6
                                color: "#"+ control.thisTheme.backgroundColor_2
                            }
                        }
                    }

                }


            }
        }
        Item {
            id: footer
            width: control.width - 10
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: content.bottom
            Rectangle {
                anchors.fill: parent
                border.width: 0
                color: "#"+ control.thisTheme.backgroundColor
            }
            Row {
    //                    height: footer.height
                anchors.centerIn: parent
                spacing: 5
                Rectangle {
                    width: footer.height/2
                    height: width
                    radius: 100
                    color: "#"+ control.thisTheme.iconColor
                }
                Rectangle {
                    width: footer.height/2
                    height: width
                    radius: 100
                    color: "#"+ control.thisTheme.iconColor
                }
                Rectangle {
                    width: footer.height/2
                    height: width
                    radius: 100
                    color: "#"+ control.thisTheme.iconColor
                }
            }
        }
        Slider {
            id: progressSlider
            width: parent.width
            height: 3
            from: 0
            to: p_music_Player.duration
            anchors.bottom: footer.top
            background: Rectangle {
                color: "#1F" + control.thisTheme.iconColor
                Rectangle {
                    width: progressSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#FF" + control.thisTheme.iconColor
                }
            }
            handle: Rectangle {
                z: 2
                id: handle
                implicitWidth: 10
                implicitHeight: width
                x: (progressSlider.availableWidth - width)*progressSlider.visualPosition
                y: -((height - progressSlider.height)/2)
                color: progressSlider.pressed ? "#" + control.thisTheme.iconColor :  "#"+ control.thisTheme.iconColor_2
                border.width: 1.5
                border.color: "#" + control.thisTheme.iconColor
                radius: 100
            }

            Connections {
                target: p_music_Player
                enabled: !progressSlider.pressed
                function onPositionChanged() {
                    progressSlider.value = p_music_Player.position
                }
            }
        }
    }

    OpacityMask {
        anchors.fill: control
        source: control.children[0]
        maskSource: mask
    }
    Rectangle {
        id: mask
        width: control.width
        height: control.height
        radius: 15
        visible: false
    }
}


