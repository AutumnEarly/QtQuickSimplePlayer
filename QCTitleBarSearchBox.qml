import QtQuick
import QtQuick.Controls
import "./qcComponent"
/*
    搜索框
*/

Rectangle {

    width: 180
    height: searchTextField.height + 10
    radius: width/2
    border.width: 2
    border.color: if(searchTextField.focus) return "#FF" + thisTheme.iconColor
    else return "#00000000"
    color: "#1F" + thisTheme.iconColor
    Behavior on border.color {
        ColorAnimation {
            duration: 200
        }
    }
    TextField { // 输入框
        id: searchTextField
        property Popup popup: Popup {
            width: 0
            height: 0
            closePolicy: Popup.CloseOnPressOutsideParent
        }
        width: parent.width- 20 - height
        height: contentHeight + 5

        focus: searchTextField.popup.visible
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: fontSize
        color: "#"+ thisTheme.fontColor
        background: Rectangle {
            color: "#00000000"
            border.width: 0
        }
        onPressed: {
            searchTextField.popup.open()
        }
        Keys.onReturnPressed: function (){
            parent.gotoSearchDetailPage()
            rightContent.push({callBack:gotoSearchDetailPage,name: "search"+searchTextField.text,data: {}})
        }
    }
    QCToolTipButton { // 搜索按钮
        width: searchTextField.height
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 10
        cursorShape: Qt.PointingHandCursor
        iconSource: "qrc:/Images/search.svg"
        hovredColor: "#1F" + thisTheme.iconColor
        iconColor: "#" +thisTheme.iconColor
        onClicked: {
            parent.gotoSearchDetailPage()
            rightContent.push({callBack:gotoSearchDetailPage,name: "search"+searchTextField.text,data: {}})
        }
    }
    /*
        切换到搜索页面
    */
    function gotoSearchDetailPage() {
        searchTextField.focus = false

        leftBar.thisQml = ""
        leftBar.thisBtnText = ""
        rightContent.thisQml = "pageQml/PageMusicSearchDetail.qml"
        if(searchTextField.text === "") {
            rightContent.item.searchText = searchTextField.placeholderText
            rightContent.item.updateAll()
        } else {
            rightContent.item.searchText = searchTextField.text
            rightContent.item.updateAll()

        }
    }
}

