import QtQuick
import Qt5Compat.GraphicalEffects

Image {
    id: imgRoot
    property string color: "#00000000"
    width: 30
    height: width
    source: "qrc:/Images/bookmark.svg"
    ColorOverlay {
        anchors.fill: parent
        source: parent
        color: imgRoot.color
    }
}
