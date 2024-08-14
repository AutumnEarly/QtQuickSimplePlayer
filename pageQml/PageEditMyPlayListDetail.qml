//PageEditMyPlayListDetail.qml
import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import "../theme"
import "../qcComponent"
import "../"
/*
    编辑我的歌单详情页
*/
Item {
    id: editMyPlayListDetail
    property var playListInfo: null
    property var playListInfo_2: null
    property QCTheme thisTheme: ThemeManager.theme
    property int fontSize: 12
    width: parent.width
    height: parent.height

    onPlayListInfoChanged: {
        coverImage.source = playListInfo.coverImgMode === "0" ?
                    playListInfo.coverImg + "?thumbnail=" + 200 + "y" + 200 :
                    playListInfo.userCoverImg

        nameTextField.text = playListInfo.name
        descriptionTextField.text = playListInfo.description
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["图片 (*.jpg *.png)"]

        onAccepted: {
            playListInfo_2.coverImgMode = "1"
            coverImage.source = fileDialog.file
            console.log("PageEditMyPlayListDetail.qml: 选择图片路径：" + fileDialog.file)
        }
    }

    Column {
        width: 800
        height: 400
        padding: 30
        Text {
            width: parent.width
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 18
            font.family: "黑体"
            elide: Text.ElideRight
            text: "编辑歌单信息"
            color: "#"+ thisTheme.fontColor
        }
        Row {
            width: parent.width - parent.leftPadding - parent.rightPadding
            spacing: 15
            padding: 15
            Column { // 文本编辑栏
                width: parent.width - coverImage.width - parent.spacing*2 - parent.padding *2
                height: 240
                spacing: 10
                padding: 0
                Row { // 歌单名编辑
                    width: 480
                    height: 30
                    spacing: 5

                    Text { // 输入说明
                        width: 60
                        height: contentHeight
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pointSize: fontSize
                        font.family: "黑体"
                        elide: Text.ElideRight
                        text: "歌单名:"
                        color: "#"+ thisTheme.fontColor
                    }

                    Rectangle { // 输入框
                        width: 400
                        height: 30
                        color: "#2F"+ thisTheme.iconColor
                        radius: 8
                        Row {
                            width: parent.width - 15
                            height: parent.height - 15
                            anchors.centerIn: parent
                            TextField {
                                id: nameTextField
                                property Popup popup: Popup {
                                    width: 0
                                    height: 0
                                    closePolicy: Popup.CloseOnPressOutsideParent
                                }
                                focus: popup.visible
                                width: parent.width - nameTextCount.width - 10
                                text: ""
                                maximumLength: 50
                                anchors.verticalCenter: parent.verticalCenter
        //                                    validator: RegularExpressionValidator {regularExpression: /^.{1,50}$/ }
                                font.pointSize: 12
                                color: "#"+ thisTheme.fontColor
                                background: Rectangle {
                                    color: "#00000000"
                                    border.width: 0
                                }

                                onTextChanged: {

                                }
                                onPressed: {
                                    popup.open()
                                }
                            }
                            Text {
                                id: nameTextCount
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignRight
                                font.pointSize: fontSize
                                font.family: "黑体"
                                elide: Text.ElideRight
                                text: nameTextField.text.length+ "/50"
                                color: "#AF"+ thisTheme.fontColor
                            }
                        }
                    }

                }
                Row { // 歌单简介编辑
                    width: 480
                    height: 200
                    spacing: 5
                    Text { // 输入说明
                        width: 60
                        height: contentHeight
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pointSize: fontSize
                        font.family: "黑体"
                        elide: Text.ElideRight
                        text: "歌单名:"
                        color: "#"+ thisTheme.fontColor
                    }
                    Rectangle { // 输入框
                        width: 400
                        height: parent.height
                        color: "#2F"+ thisTheme.iconColor
                        radius: 8
                        Item {
                            width: parent.width - 15
                            height: parent.height - 15
                            anchors.centerIn: parent
                            TextField {
                                id: descriptionTextField
                                property Popup popup: Popup {
                                    width: 0
                                    height: 0
                                    closePolicy: Popup.CloseOnPressOutsideParent
                                }
                                focus: popup.visible
                                width: parent.width
                                height: parent.height - descriptionTextCount.height
                                text: ""
                                maximumLength: 500
                                wrapMode: Text.WrapAnywhere
//                                validator: RegularExpressionValidator {regularExpression: /^.{1,50}$/ }
                                font.pointSize: 12
                                color: "#"+ thisTheme.fontColor
                                background: Rectangle {
                                    color: "#00000000"
                                    border.width: 0
                                }

                                onTextChanged: {

                                }
                                onPressed: {
                                    popup.open()
                                }
                            }
                            Text {
                                id: descriptionTextCount
                                width: parent.width
                                anchors.top: descriptionTextField.bottom
                                height: contentHeight
                                horizontalAlignment: Text.AlignRight
                                font.pointSize: fontSize
                                font.family: "黑体"
                                elide: Text.ElideRight
                                text: descriptionTextField.text.length+ "/500"
                                color: "#AF"+ thisTheme.fontColor
                            }

                        }


                    }

                }

            }
            Column { // 封面编辑
                width: 180
                height: width
                spacing: 10
                RoundImage {
                    id: coverImage
                    width: 180
                    height: width
                    radius: 6
                }
                Row { // 选择封面 回到默认 (按钮)
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10
                    Rectangle {
                        width: children[0].contentWidth + 30
                        height: children[0].contentHeight + 20
                        radius: 10
                        color: "#"+ ThemeManager.theme.iconColor_2
                        Text {
                            text: "选择图片"
                            font.pointSize: 12
                            anchors.centerIn: parent
                            color: "#"+ ThemeManager.theme.fontColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                fileDialog.open()

                            }
                        }
                    }
                    Rectangle {
                        width: children[0].contentWidth + 30
                        height: children[0].contentHeight + 20
                        radius: 10
                        color: "#"+ ThemeManager.theme.iconColor_2
                        Text {
                            text: "默认"
                            font.pointSize: 12
                            anchors.centerIn: parent
                            color: "#"+ ThemeManager.theme.fontColor
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                playListInfo_2.coverImgMode = "0"
                                coverImage.source = playListInfo.coverImg

                            }
                        }
                    }
                }
            }
        }

        Row { // 确定取消
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15
            Rectangle {
                width: 80
                height: 40
                radius: 10
                color: "#"+ThemeManager.theme.iconColor_2
                Text {
                    text: "添加"
                    font.pointSize: 12
                    anchors.centerIn: parent
                    color: "#"+ThemeManager.theme.fontColor
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        playListInfo.coverImgMode = playListInfo_2.coverImgMode
                        if(playListInfo.coverImgMode === "1") {
                            playListInfo.userCoverImg = coverImage.source
                        }
                        playListInfo.name = nameTextField.text
                        playListInfo.description = descriptionTextField.text
                        MyPlayListManager.updateDataValue()
                        var l = leftBar , r = rightContent
                        l.thisQml = ""
                        l.thisBtnText = ""
                        r.thisQml = "pageQml/PageMyMusicPlayListDetail.qml"
                        r.item.playListInfo = playListInfo

                    }
                }
            }
            Rectangle {
                width: 80
                height: 40
                radius: 10
                color: "#"+ ThemeManager.theme.iconColor_2
                Text {
                    text: "取消"
                    font.pointSize: 12
                    anchors.centerIn: parent
                    color: "#"+ ThemeManager.theme.fontColor
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var l = leftBar , r = rightContent
                        l.thisQml = ""
                        l.thisBtnText = ""
                        r.thisQml = "pageQml/PageMyMusicPlayListDetail.qml"
                        r.item.playListInfo = playListInfo

                    }
                }
            }

        }


    }

}
