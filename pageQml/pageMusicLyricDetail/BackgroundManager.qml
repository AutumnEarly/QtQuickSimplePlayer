import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import qc.window
import "../../qcComponent"

Item {
    width: parent.width
    height: parent.height
    ImageColor {
        id: imgColor
    }

    Loader {
        id: background
        anchors.fill: parent
        sourceComponent: gradientBackground
        Rectangle {
            anchors.fill: parent

        }
    }
    Component {
        id: imgBackground
        Item {
            property string source: p_music_Player.thisPlayMusicInfo.coverImg

            onSourceChanged: {
                if(backgroundImg.visible) {
                    backgroundImgBuffer.source = source
                } else {
                    backgroundImg.source = source
                }
            }

            anchors.fill: background
            Image {
                id: backgroundImg
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(500,500)
                opacity: 1
                onStatusChanged: {
                    if(status === Image.Error) {
                        console.log("切换背景失败！！")
                    }
                    if(status === Image.Ready && !visible) {
                        visible = true
                        backgroundImgBuffer.source = ""
                        backgroundImgBuffer.visible = false
                        blurBackgroundImg.source = backgroundImg
                        console.log("当前显示: img1")
                    }

                }
            }
            Image {
                id: backgroundImgBuffer
                visible: false
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                sourceSize: Qt.size(500,500)
                opacity: 1
                onStatusChanged: {
                    if(status === Image.Error) {
                        console.log("切换背景失败！！")
                    }

                    if(status === Image.Ready&& !visible) {
                        visible = true
                        backgroundImg.source = ""
                        backgroundImg.visible = false
                        blurBackgroundImg.source = backgroundImgBuffer
                        console.log("当前显示: img2")
                    }
                }
            }
            GaussianBlur {
                id: blurBackgroundImg
                anchors.fill: parent
                radius: musicLyricPage.backgroundImgBlur
                samples: 120
            }
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#3F000000"
            }
        }


    }
    Component {
        id: gradientBackground
        Item {
            anchors.fill: parent
            LinearGradient {
                id: linear
                anchors.fill: parent
                start: Qt.point(0,0)
                end: Qt.point(width,height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "red" }
                    GradientStop { position: 1.0; color: "blue" }
                }
                Connections {
                    target: content.coverItem
                    function onStatusChanged() {
                        if(content.coverItem.status === Image.Ready) {

                            var callBack = res => {
                                var colors = imgColor.getMainColors(res.image)
                                linear.gradient.stops[0].color = colors[2]
                                linear.gradient.stops[1].color = colors[3]
                            }
                            content.coverItem.grabToImage(callBack,Qt.size(200,200))
                        }

                    }
                }
                Component.onCompleted: {
                    if(content.coverItem.status === Image.Ready) {

                        var callBack = res => {
                            var colors = imgColor.getMainColors(res.image)
                            linear.gradient.stops[0].color = colors[0]
                            linear.gradient.stops[1].color = colors[1]
                            linear.gradient.stops[2].color = colors[2]
                        }
                        content.coverItem.grabToImage(callBack,Qt.size(200,200))
                    }
                }
            }
            ColorOverlay {
                anchors.fill: parent
                color: "#3F000000"
            }
        }


    }

}
