// HeaderItem.qml
import QtQuick 2.15
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../../qcComponent"
import "../../theme"
import "./pageLocalFolderDetail.js" as PageLocalFolderJS

/*
    歌单 头部部分
*/

Column {
    id: header

    width: parent.width - (localFolderPageListView.leftMargin + localFolderPageListView.rightMargin)
    height: PageLocalFolderJS.getAllHeight(children,spacing)
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 15

    Column {
        id: localFolderTitle
        width: parent.width
        height: PageLocalFolderJS.getAllHeight(children,spacing)
        spacing: 10

        Row {
            width: parent.width
            height: 50
            spacing: 5
            Column {
                width: children[0].width
                height: PageLocalFolderJS.getAllHeight(children,spacing)
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    width: contentWidth
                    height: contentHeight
                    font.pointSize: 18
                    text: "文件夹"
                    color: "#FF" + thisTheme.fontColor
                }
            }
            QCToolTipButton {
                id: musicPlayModeIcon
                width: 50
                height: width
                cursorShape: Qt.PointingHandCursor
                iconSource: "qrc:/Images/folder.svg"
                hovredColor: "#0F" + thisTheme.iconColor
                iconColor: "#" +thisTheme.iconColor
                toolTip.border.color: "BLACK"
                onClicked: function (){
                    folderDialog.open()
                }
            }

        }

        Text {
            width: contentWidth
            height: contentHeight
            font.pointSize: 10
            text: "当前已添加 " + foldersData.length + " 文件夹"
            color: "#AF" + thisTheme.fontColor
        }

        Item {
            width: parent.width
            height: headerSelect.height
            Rectangle {
                id: headerSelect
                radius: width/2
                color: "#0F" + thisTheme.iconColor
                Row {
                    Repeater {
                        model: ListModel {
                            Component.onCompleted: {
                                append(localFolderPage.headerData)
                            }
                        }
                        delegate: headerSelectDelegate
                        onCountChanged: {
                            var w = 0
                            var h = 0
                            for(var i = 0; i < count;i++) {
                                w += itemAt(i).width
                                if(h < itemAt(i).height) {
                                    h = itemAt(i).height
                                }
                            }
                            headerSelect.width = w
                            headerSelect.height = h
                        }

                    }
                }
            }

            Item {
                width: parent.width - headerSelect.width
                height: children[0].height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    property bool isHoverd: false
                    width: contentWidth
                    height: contentHeight
                    anchors.right: parent.right
                    font.pointSize: 11
                    text: "编辑文件夹"
                    color: isHoverd ? "#FF" + thisTheme.fontColor : "#AF" + thisTheme.fontColor
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            let popup = editFolderPopupCmp.createObject(windowPage)
                            popup.open()

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
        }

    }

    Component {
        id: headerSelectDelegate
        Rectangle {
            property bool isHoverd: false
            width: children[0].contentWidth + 35
            height: children[0].contentHeight + 25
            radius: width/2
            color: if(headerData[index].mode  === localFolderPage.mode) return "#2F" + thisTheme.iconColor
            else if(isHoverd) return "#1F" + thisTheme.iconColor
            else return "#00000000"

            Behavior on color {
                ColorAnimation {
                    duration: 200
                    easing.type:  Easing.InOutQuad
                }
            }

            Text {
                font.pointSize: localFolderPage.fontSize
                font.bold: localFolderPage.headerCurrent  === index
                anchors.centerIn: parent
                text: name
                color: "#"+ thisTheme.fontColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: function (mouse){
                    PageLocalFolderJS.selectMode(headerData[index].mode)
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

    Component {
        id: editFolderPopupCmp
        Popup {
            id: control
            property real contentItemHeight: 30
            width: 500
            height: 500
            modal: true
            padding: 0
            anchors.centerIn: parent
            closePolicy: Popup.NoAutoClose

            Overlay.modal: Rectangle {
                GaussianBlur {
                    anchors.fill: parent
                    radius: 8
                    source: control.parent
                }
            }
            background: Item {

                Rectangle {
                    id: popupBackground
                    anchors.fill: parent
                    radius: 8
                    color: "#" + ThemeManager.theme.backgroundColor
                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: "#1F" + ThemeManager.theme.iconColor
                    }
                }
                DropShadow {
                    z: -1
                    width: popupBackground.width
                    height: popupBackground.height
                    horizontalOffset: 1
                    verticalOffset: 3
                    radius: 8.0
                    color: "#2F000000"
                    source: popupBackground
                }
            }
            contentItem: Item {
                id: contentItemRoot
                Column {
                    width: parent.width
                    height: parent.height

                    Item {
                        id: titleText
                        width: parent.width - 20
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            width: contentWidth
                            height: contentHeight
                            anchors.centerIn: parent
                            font.pointSize: 14
                            text: "编辑本地音乐文件夹"
                            color: "#AF" + thisTheme.fontColor
                        }
                    }
                    Flickable {
                        id: contentItem
                        width: parent.width
                        height: parent.height - titleText.height -footerItem.height
                        contentHeight: children[0].height
                        QCScrollBar.vertical: QCScrollBar {
                            handleHeight: 8
                            handleNormalColor: "#1F" + thisTheme.iconColor
                        }
                        Column {
                            width: parent.width - 20
                            height: foldersData.length*contentItemHeight + (foldersData.length-1) * spacing
                            anchors.horizontalCenter: parent.horizontalCenter

                            Repeater {
                                id: checkBoxRepeater
                                model: localFolderPage.foldersData.length
                                delegate: Item {
                                    property alias checkState: checkBox.checkState
                                    width: children[0].width
                                    height: contentItemHeight
                                    CheckBox {
                                        id: checkBox
                                        anchors.verticalCenter: parent.verticalCenter
                                        checkState: Qt.Checked
                                        font.pointSize: 12
                                        text: localFolderPage.foldersData[index].url.slice(8)
                                    }
                                }
                            }
                        }

                    }

                    Item {
                        id: footerItem
                        width: parent.width - 20
                        height: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        Row { // 确定 添加
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height
                            spacing: 15
                            Rectangle {
                                width: 80
                                height: 40
                                radius: 10
                                color: "#"+ThemeManager.theme.iconColor_2
                                Text {
                                    text: "确定"
                                    font.pointSize: 11
                                    anchors.centerIn: parent
                                    color: "#"+ThemeManager.theme.fontColor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        contentItemRoot.updateFoldersData()
                                        control.close()
                                        control.destroy()
                                    }
                                }
                            }
                            Rectangle {
                                width: 90
                                height: 40
                                radius: 10
                                color: "#"+ThemeManager.theme.iconColor_2
                                Text {
                                    text: "添加文件夹"
                                    font.pointSize: 11
                                    anchors.centerIn: parent
                                    color: "#"+ThemeManager.theme.fontColor
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        folderDialog.open()

                                    }
                                }
                            }

                        }

                    }
                }

                Rectangle { // 退出按钮
                    property bool isHoverd: false
                    width: 35
                    height: width
                    radius: 100
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    color: if(isHoverd) return "#1F"+ ThemeManager.theme.iconColor
                           else return "#00000000"
                    Rectangle {
                        width: parent.width / 2
                        height: 3
                        border.color: "#"+ ThemeManager.theme.iconColor
                        anchors.centerIn: parent
                        rotation: 45
                        color: "#"+ ThemeManager.theme.iconColor
                    }
                    Rectangle {
                        width: parent.width / 2
                        height: 3
                        border.color: "#"+ ThemeManager.theme.iconColor
                        anchors.centerIn: parent
                        rotation: -45
                        color: "#"+ ThemeManager.theme.iconColor
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {

                            control.close()
                            control.destroy()
                        }
                        onEntered: {
                            parent.isHoverd = true
                        }
                        onExited: {
                            parent.isHoverd = false
                        }
                    }
                }

                function updateFoldersData() {
                    let t = []
                    for(let i = 0; i < foldersData.length;i++) {
                        if(checkBoxRepeater.itemAt(i).checkState === Qt.Checked) {
                            t.push(foldersData[i])
                        }
                    }
                    foldersData = t
                    localFolderPage.dataValueChanged()
                }


            }
        }
    }


}
