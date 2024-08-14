import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    property string source: "qrc:/Images/QingQueQ.png"
    property double radius: 8
    property int status: img.status
    property alias fillMode: img.fillMode
    property alias sourceSize: img.sourceSize
    width: 30
    height: 30
    Image {
        id: img
        anchors.fill: parent
        visible: false
        source: parent.source
        fillMode: Image.PreserveAspectCrop
    }
    OpacityMask {
        anchors.fill: parent
        source: img
        maskSource: mask
    }
    Rectangle {
        id: mask
        anchors.fill: parent
        radius: parent.radius
        visible: false
    }
}
