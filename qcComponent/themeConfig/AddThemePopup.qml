// AddThemePopup.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import Qt5Compat.GraphicalEffects
import "../"
import "../../theme"

/*
    添加主题弹出框
*/
Popup {
    id: addThemePopup
    property QCTheme thisTheme: QCTheme { name: "未定义";type: "user"}
    width: 800
    height: 400
    modal: true
    padding: 0
    anchors.centerIn: parent
    closePolicy: Popup.NoAutoClose
    Overlay.modal: Rectangle {
        color: "#2F00FFFF"
        GaussianBlur {
            anchors.fill: parent
            radius: 8
            source: addThemePopup.parent
        }
    }

    Flickable {
        anchors.fill: parent
        Column {
            width: parent.width
            height: parent.height
            padding: 15
            spacing: 20
            Row {
                width: parent.width - parent.padding *2
                height: children[1].height
                spacing: 15
                Column {
                    width: parent.width * .3
                    height: addThemePopup.getAllHeight(children,spacing)
                    spacing: 10
                    Column {
                        width: 200
                        height: addThemePopup.getAllHeight(children,spacing)
                        spacing: 5
                        QCMiniPage {
                            thisTheme: addThemePopup.thisTheme
                            width: 200
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Text {
                           text: "主页预览"
                           font.pointSize: 12
                           anchors.horizontalCenter: parent.horizontalCenter
                           color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }


                }
                Column {
                    width: parent.width * .7
                    height: addThemePopup.getAllHeight(children,spacing)
                    spacing: 10
                    Row { // 主题名修改
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Text {
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "主题名"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[0].height
                                anchors.centerIn: parent
                                spacing: 5
                                TextField { // 输入框
                                    id: nameTextField
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.spacing
                                    height: contentHeight+5
                                    placeholderText: "未定义"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
//                                    validator: RegularExpressionValidator {regularExpression: /{0,12}/ }
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        addThemePopup.thisTheme.name = text
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                    }

                    Row { // 背景颜色控制
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题 颜色球
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Rectangle {
                                width: 40
                                height: width
                                radius: 100
                                color: "#"+ addThemePopup.thisTheme.backgroundColor
                            }
                            Text {
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "背景颜色"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[1].height
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    width: contentWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "#"
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                }
                                TextField { // 输入框
                                    id: backgroundColorTextField
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.children[0].width - parent.spacing
                                    placeholderText: "FAF2F1"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    validator: RegularExpressionValidator {regularExpression: /^[a-fA-F0-9]{6}$/}
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        if(text !== "") {
                                            addThemePopup.thisTheme.backgroundColor = text
                                        } else {
                                            addThemePopup.thisTheme.backgroundColor = placeholderText
                                        }
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(十六进制颜色)"
                            font.pointSize: 10
                            color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }

                    Row { // 背景颜色(次选)控制
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题 颜色球
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Rectangle {
                                width: 40
                                height: width
                                radius: 100
                                color: "#"+ addThemePopup.thisTheme.backgroundColor_2
                            }
                            Text {
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "背景颜色(次选)"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[1].height
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    width: contentWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "#"
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                }
                                TextField { // 输入框
                                    id: backgroundColor_2TextField
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.children[0].width - parent.spacing
                                    height: contentHeight+5
                                    placeholderText: "FFFFFF"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    validator: RegularExpressionValidator {regularExpression: /^[a-fA-F0-9]{6}$/}
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        if(text !== "") {
                                            addThemePopup.thisTheme.backgroundColor_2 = text
                                        } else {
                                            addThemePopup.thisTheme.backgroundColor_2 = placeholderText
                                        }
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(十六进制颜色)"
                            font.pointSize: 10
                            color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }

                    Row { // 图标颜色控制
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题 颜色球
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Rectangle {
                                width: 40
                                height: width
                                radius: 100
                                color: "#"+ addThemePopup.thisTheme.iconColor
                            }
                            Text {
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "图标颜色"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[1].height
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    width: contentWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "#"
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                }
                                TextField { // 输入框
                                    id: iconColorTextField
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.children[0].width - parent.spacing
                                    placeholderText: "FF5966"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    validator: RegularExpressionValidator {regularExpression: /^[a-fA-F0-9]{6}$/}
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        if(text !== "") {
                                            addThemePopup.thisTheme.iconColor = text
                                        } else {
                                            addThemePopup.thisTheme.iconColor = placeholderText
                                        }
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(十六进制颜色)"
                            font.pointSize: 10
                            color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }

                    Row { // 图标颜色(次选)控制
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题 颜色球
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Rectangle {
                                width: 40
                                height: width
                                radius: 100
                                color: "#"+ addThemePopup.thisTheme.iconColor_2
                            }
                            Text {
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "图标颜色(次选)"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[1].height
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    width: contentWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "#"
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                }
                                TextField { // 输入框
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.children[0].width - parent.spacing
                                    placeholderText: "FFFFFF"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    validator: RegularExpressionValidator {regularExpression: /^[a-fA-F0-9]{6}$/}
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        if(text !== "") {
                                            addThemePopup.thisTheme.iconColor_2 = text
                                        } else {
                                            addThemePopup.thisTheme.iconColor_2 = placeholderText
                                        }
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(十六进制颜色)"
                            font.pointSize: 10
                            color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }

                    Row { // 字体颜色控制
                        width: parent.width
                        height: 40
                        spacing: 15

                        Row { // 标题 颜色球
                            width: parent.width * 0.3
                            height: parent.height
                            spacing: 10
                            Rectangle { // 颜色球
                                width: 40
                                height: width
                                radius: 100
                                color: "#"+ addThemePopup.thisTheme.fontColor
                            }
                            Text { // 标题
                                width: parent.width - 40 - parent.spacing
                                anchors.verticalCenter: parent.verticalCenter
                                text: "文本颜色"
                                font.pointSize: 13
                                color: "#"+ themeConfigLabel.thisTheme.fontColor
                            }

                        }
                        Rectangle { // 输入框
                            width: parent.width *.5 - parent.spacing*2
                            height: parent.height
                            color: "#"+ themeConfigLabel.thisTheme.backgroundColor
                            radius: 8
                            Row {
                                width: parent.width - 10
                                height: children[1].height
                                anchors.centerIn: parent
                                spacing: 5
                                Text {
                                    width: contentWidth
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "#"
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                }
                                TextField { // 输入框
                                    id: fontColorTextField
                                    property Popup popup: Popup {
                                        width: 0
                                        height: 0
                                        closePolicy: Popup.CloseOnPressOutsideParent
                                    }
                                    focus: popup.visible
                                    width: parent.width - parent.children[0].width - parent.spacing
                                    placeholderText: "572C27"
                                    text: ""
                                    anchors.verticalCenter: parent.verticalCenter
                                    validator: RegularExpressionValidator {regularExpression: /^[a-fA-F0-9]{6}$/}
                                    font.pointSize: 12
                                    color: "#"+ themeConfigLabel.thisTheme.fontColor
                                    topInset: (height-contentHeight)/2
                                    background: Rectangle {
                                        color: "#00000000"
                                        border.width: 0
                                    }
                                    onTextEdited: {
                                        if(text !== "") {
                                            addThemePopup.thisTheme.fontColor = text
                                        } else {
                                            addThemePopup.thisTheme.fontColor = placeholderText
                                        }
                                    }

                                    onPressed: {
                                        popup.open()
                                    }
                                }
                            }
                        }
                        Text {
                            width: parent.width * 0.2
                            anchors.verticalCenter: parent.verticalCenter
                            text: "(十六进制颜色)"
                            font.pointSize: 10
                            color: "#"+ themeConfigLabel.thisTheme.fontColor
                        }
                    }

                }
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15
                Rectangle {
                    width: 80
                    height: 40
                    radius: 10
                    color: "#"+themeConfigLabel.thisTheme.iconColor_2
                    Text {
                        text: "添加"
                        font.pointSize: 12
                        anchors.centerIn: parent
                        color: "#"+themeConfigLabel.thisTheme.fontColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ThemeManager.add(addThemePopup.thisTheme)
                            addThemePopup.close()
                        }
                    }
                }
                Rectangle {
                    width: 80
                    height: 40
                    radius: 10
                    color: "#"+themeConfigLabel.thisTheme.iconColor_2
                    Text {
                        text: "取消"
                        font.pointSize: 12
                        anchors.centerIn: parent
                        color: "#"+themeConfigLabel.thisTheme.fontColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            addThemePopup.close()
                        }
                    }
                }

            }

        }
        Rectangle {
            property bool isHoverd: false
            width: 35
            height: width
            radius: 100
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            color: if(isHoverd) return "#1F"+ themeConfigLabel.thisTheme.iconColor
                   else return "#00000000"
            Rectangle {
                width: parent.width / 2
                height: 3
                border.color: "#"+ themeConfigLabel.thisTheme.iconColor
                anchors.centerIn: parent
                rotation: 45
                color: "#"+ themeConfigLabel.thisTheme.iconColor
            }
            Rectangle {
                width: parent.width / 2
                height: 3
                border.color: "#"+ themeConfigLabel.thisTheme.iconColor
                anchors.centerIn: parent
                rotation: -45
                color: "#"+ themeConfigLabel.thisTheme.iconColor
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    addThemePopup.close()
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

    background: Item {

        Rectangle {
            id: popupBackground
            anchors.fill: parent
            radius: 8
            color: "#" + themeConfigLabel.thisTheme.backgroundColor
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: "#1F" + themeConfigLabel.thisTheme.iconColor
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

    Component.onCompleted: {

    }

    function getAllHeight(children,spacing) {
        var h = 0
        for(var i = 0;i < children.length;i++) {
            if(children[i] instanceof Text) {
                h += children[i].contentHeight
            } else {
                h += children[i].height
            }
        }
        h += (children.length-1) *spacing
        return h
    }

}

