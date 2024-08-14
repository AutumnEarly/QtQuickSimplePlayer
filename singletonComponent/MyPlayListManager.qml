pragma Singleton
import QtQuick

Item {
    id: control
    property var data: []
    property string savePath: "userInfo/playlistInfo.json"


    Component.onCompleted: {
        let t = QCTool.readFile(savePath)
        try {
            t = JSON.parse(t)
            if(!Array.isArray(t)) {
                t = []
            }

//            console.log(JSON.stringify(t))
        } catch(err) {
            t = []
            console.log(err)
        }
        control.data = t
        control.dataChanged()
    }
    function addPlayList(obj) {

        let savePath = "userInfo/playListData/" + Qt.formatDateTime(new Date(),"yyyyMMddHHmmss") + ".json"
        let playList = {name: obj.name ,type: "歌单",
            coverImg: "",userCoverImg: "",coverImgMode: "0",description: "",dataPath: savePath }

        control.data.push(playList)
        QCTool.writeFile(savePath,"[]")
        QCTool.writeFile("userInfo/playlistInfo.json",JSON.stringify(control.data))
        dataChanged()
    }

    function addMusic(index,obj) {
        let t = QCTool.readFile(control.data[index].dataPath)
        if(Array.isArray(obj)) {

            try {
                t = JSON.parse(t)
                console.log(JSON.stringify(t))
            } catch(err) {
                t = []
                console.log("array: " + err)
            }

            for(let i = 0; i < obj.length;i++) {
                let findIndex = t.find((o) => o.id === obj[i].id)
                if(findIndex) {
                    console.log("QCMyPlayListManager.qml: " + control.data[index].name + "歌单添加音乐失败！")
                    continue
                }
                t.unshift(obj[i])
                console.log("QCMyPlayListManager.qml: " + control.data[index].name + "歌单添加音乐: " + JSON.stringify(obj[i]) )
            }

            control.data[index].coverImg = t[0].coverImg

            updateDataValue()
            QCTool.writeFile(control.data[index].dataPath,JSON.stringify(t))
        } else {
            try {
                t = JSON.parse(t)

            } catch(err) {
                t = []
                console.log("playListManager: " +err)
            }

            let findIndex = t.find((o) => o.id === obj.id)
            if(findIndex) {
                console.log("QCMyPlayListManager.qml: " + control.data[index].name + "歌单添加音乐失败！")
                return
            }

            t.unshift(obj)
            control.data[index].coverImg = obj.coverImg

            updateDataValue()
            QCTool.writeFile(control.data[index].dataPath,JSON.stringify(t))
            console.log("QCMyPlayListManager.qml: " + control.data[index].name + "歌单添加音乐: " + JSON.stringify(obj) )
        }
    }

    function updateDataValue() {
        QCTool.writeFile(savePath,JSON.stringify(data))
    }
}
