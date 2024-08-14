// HeaderItem.qml
import QtQuick 2.15
import "../../qcComponent"
import "../../theme"
import "./pageMusicPlayList.js" as PagePlayListJS
import  "../../singletonComponent"

/*
    歌单 头部部分
*/

Column {
    id: header

    width: parent.width - (musicPlayListPageListView.leftMargin + musicPlayListPageListView.rightMargin)
    height: PagePlayListJS.getAllHeight(children,spacing)
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 15
    Component.onCompleted: {
        PagePlayListJS.setPlayListCat({})
    }



    Item {
        id: playListInfoTitle
        width: parent.width
        height: children[0].height
        Row {
            width: parent.width
            height: children[0].height
            Column {
                width: parent.width
                height: PagePlayListJS.getAllHeight(children,spacing)
                spacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    width: contentWidth
                    height: contentHeight

                    font.pointSize: 18
                    text: "歌单"
                    color: "#FF" + thisTheme.fontColor
                }
                Text {
                    width: contentWidth
                    height: contentHeight

                    font.pointSize: 10
                    text: boutiquePlayListAllCount + " 精品歌单," + playListAllCount + " 歌单"
                    color: "#AF" + thisTheme.fontColor
                }
            }


        }
    }

    Column { // 歌单类型分类
        id: playListCatClassify
        property string activeName: "ACG"
        property real contentItemWidth: 90
        property real contentItemHeight: 35
        property bool isDropDown: true
        width: parent.width
        height: PagePlayListJS.getAllHeight(children,spacing)
        spacing: 10
        Item {
           width: parent.width
           height: 35
           Row { // 歌单分类标题
               id: playListCatClassifyTitle
               width: children[0].width + 30
               height: children[0].height
               anchors.verticalCenter: parent.verticalCenter
               spacing: 5
               Text {
                   width: contentWidth
                   height: contentHeight
                   anchors.verticalCenter: parent.verticalCenter
                   font.pointSize: 14
                   text: "歌单分类"
                   color: "#7F" + thisTheme.fontColor
               }
               QCToolTipButton {
                   width: 30
                   height: width
                   anchors.verticalCenter: parent.verticalCenter
                   cursorShape: Qt.PointingHandCursor
                   rotation: playListCatClassify.isDropDown ? 0 : -90
                   iconSource: "qrc:/Images/dropDown.svg"
                   hovredColor: "#2F" + thisTheme.iconColor
                   iconColor: "#FF" + thisTheme.fontColor
                   onClicked: function (mouse) {
                       playListCatClassify.isDropDown = !playListCatClassify.isDropDown
                   }
                   Behavior on rotation {
                       RotationAnimation {
                           duration: 300
                           easing.type: Easing.InOutQuad
                       }
                   }
               }
           }

           Item {
               id: headerSelectBar
               width: parent.width - playListCatClassifyTitle.width
               height: 30
               anchors.right: parent.right
               Row {
                   anchors.right: parent.right
                   spacing: 10
                   Repeater {
                       model: headerData.length
                       delegate: Rectangle {
                           property bool isHoverd: false
                           width: children[0].contentWidth + 20
                           height: children[0].contentHeight + 10
                           radius: width/2
                           color: headerData[index].name === activeCatName ?  "#2F" +thisTheme.iconColor : "#00000000"
                           Text {
                               anchors.centerIn: parent
                               font.pointSize: musicPlayListPage.fontSize - 1
                               font.bold: parent.isHoverd
                               text: headerData[index].name
                               color: if(headerData[index].name === activeCatName) return "#" +thisTheme.iconColor
                               else return "#"+ thisTheme.fontColor
                           }
                           MouseArea {
                               anchors.fill: parent
                               hoverEnabled: true
                               onClicked: {
                                   musicPlayListPage.activeCatName = headerData[index].name

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
       }
        ListView {
            interactive: false
            width: parent.width
            height: playListCatClassify.isDropDown ? 0 : contentHeight
            spacing: 15
            clip: true
            opacity: playListCatClassify.isDropDown ? 0 : 1
            model: playListCategories ? playListCategories.length : 0
            delegate: Item {
                width: playListCatClassify.width
                height:  gridCat.height
                Row {
                    width: parent.width
                    height: gridCat.height
                    spacing: 10
                    Item {
                        id: classifyName
                        width: playListCatClassify.contentItemWidth
                        height: playListCatClassify.contentItemHeight
                        Rectangle {
                            width: children[0].width + 20
                            height: children[0].height + 10
                            anchors.verticalCenter: parent.verticalCenter
                            radius: width/2
                            color: "#00000000"
                            Text {
                                width: contentWidth
                                height: contentHeight
                                anchors.centerIn: parent
                                font.pointSize: fontSize
                                text: playListCategories[index].classifyName
                                color: "#7F" + thisTheme.fontColor
                            }

                        }

                    }

                    Grid {
                        id: gridCat
                        property var thisData: playListCategories ? playListCategories[gridCat.thisIndex].data : []
                        property real thisIndex: index
                        width: parent.width - classifyName.width - parent.spacing
                        height: rows * playListCatClassify.contentItemHeight
                        padding: 0
                        spacing: 0
                        columns: Math.floor(width / playListCatClassify.contentItemWidth )
                        rows: Math.ceil(gridCat.thisData.length / columns)
                        Repeater {
                            model: playListCategories ? gridCat.thisData.length : 0
                            delegate: Item {
                                property bool isHoverd: false
                                width: playListCatClassify.contentItemWidth
                                height: playListCatClassify.contentItemHeight
                                Rectangle {

                                    width: children[0].width + 20
                                    height: children[0].height + 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    radius: width/2
                                    color: if(activeCatName === gridCat.thisData[index].name)
                                    return "#2F" + thisTheme.iconColor
                                    else return "#00000000"
                                    Text {
                                        width: contentWidth
                                        height: contentHeight
                                        anchors.centerIn: parent
                                        font.pointSize: fontSize
                                        font.bold: isHoverd
                                        text: gridCat.thisData[index].name
                                        color: if(activeCatName === gridCat.thisData[index].name)
                                        return "#FF" + thisTheme.iconColor
                                        else return "#" + thisTheme.fontColor
                                        MouseArea {
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: {
                                                musicPlayListPage.activeCatName = gridCat.thisData[index].name

                                            }
                                            onEntered: {
                                                isHoverd = true
                                            }
                                            onExited: {
                                                isHoverd = false
                                            }
                                        }
                                    }
                                }

                            }

                        }
                    }

                }



            }

            Behavior on height {
                NumberAnimation {
                    property: "height"
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    property: "opacity"
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }
        }

    }



//    Item {
//        id: headerBackgournd
//        width: parent.width
//        height: 160
//        // 封面背景
//        RoundImage {
//            id: headerBackgournd_1
//            visible: false
//            anchors.fill: parent
//            radius: 12
//            source: boutiquePlayListData.length > 0 ? boutiquePlayListData[0].coverImg : "qrc:/Images/HuoHuo.png"
//            sourceSize: Qt.size(30,30)
//        }
//        FastBlur {
//            anchors.fill: headerBackgournd_1
//            source: headerBackgournd_1
//            radius: 60
//            transparentBorder: true
//        }
//        FastBlur {
//            z: headerBackgournd_1.z+1
//            anchors.fill: headerBackgournd_1
//            source: headerBackgournd_1
//            radius: 100
//            layer.enabled: true
//            layer.effect: ColorOverlay {

//                anchors.fill: parent
//                color: "#3F000000"
//            }
//        }

//        // 歌单信息
//        Item {
//            z: headerBackgournd_1.z+1
//            id: boutiquePlayListInfo
//            property string nameText: ""
//            property string descriptionText: ""
//            width: parent.width - 30
//            height: headerBackgournd.height - 30
//            anchors.centerIn: parent
//            RoundImage {
//                id: boutiquePlayListCoverImg
//                width: parent.height
//                height: width
//                source: headerBackgournd_1.source
//                sourceSize: Qt.size(width,height)
//            }
//            Column {
//                property var childrenHeight: []
//                width: parent.width - boutiquePlayListCoverImg.width - anchors.leftMargin
//                height: parent.height
//                spacing: 15
//                anchors.left: boutiquePlayListCoverImg.right
//                anchors.leftMargin: 20
//                anchors.verticalCenter: boutiquePlayListCoverImg.verticalCenter
//                Text {
//                    width: parent.width
//                    height: contentHeight
//                    font.pointSize: musicPlayListPage.fontSize
//                    wrapMode: Text.Wrap
//                    elide: Text.ElideRight
//                    color: "WHITE"
//                    text: boutiquePlayListData.length > 0 ? boutiquePlayListData[0].name : ""
//                }
//                Text {
//                    width: parent.width
//                    height: if(parent.height-parent.children[0].height - contentHeight > 0) return parent.height-parent.children[0].height
//                    else return contentHeight
//                    font.pointSize: musicPlayListPage.fontSize - 2
//                    wrapMode: Text.Wrap
//                    elide: Text.ElideRight
//                    color: "WHITE"
//                    text: boutiquePlayListData.length > 0 ? boutiquePlayListData[0].description : ""
//                    onTextChanged: {
////                            console.log(this.contentHeight)
//                        parent.setHeight()
//                    }

//                }
//                function setHeight() {
//                    var h = 0
//                    var remainingH = boutiquePlayListInfo.height
//                    var childH = 0
//                    var childMinH = 20
//                    childrenHeight = []
//                    for(var i = 0 ; i < children.length;i++) {
//                        if(children[i] instanceof Text ) {
//                            childH = children[i].contentHeight
////                                console.log("childIndex: " + i + " contentHeight: " + children[i].contentHeight)
//                        } else {
//                            childH = children[i].height
//                        }

//                        if(remainingH - childH - (children.length-i)*childMinH > 0) {
//                            childrenHeight.push(childH+ spacing)
//                            h += childH + spacing
//                            remainingH -= childH
//                        } else if(children.length-1 === i) {
//                            childrenHeight.push(remainingH- spacing)
//                            h += remainingH + spacing
//                            remainingH -= remainingH
//                        }
////                            console.log("achildH: " + children[i].height + " remainingH: " + remainingH)
//                    }
////                        console.log(JSON.stringify(childrenHeight))
//                    childrenHeightChanged()
//                }
//            }
//        }

//    }

}
