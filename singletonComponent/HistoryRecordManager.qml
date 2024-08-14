pragma Singleton
import QtQuick
import qc.window

Item {
    id: historyRecordManager
    property string savePath: "userInfo/historyRecord.json"
    property int maxCount: 100

    function getData() {
        let data = QCTool.readFile(savePath)
        try {
            data = JSON.parse(data)
        } catch(err) {
            data = []
            console.log("HistoryRecordManager.qml: " + err)
        }
        return data
    }

    function add(obj) {
        let data = QCTool.readFile(savePath)
        try {
            data = JSON.parse(data)
        } catch(err) {
            data = []
            console.log("HistoryRecordManager.qml: " + err)
        }

        let index = data.findIndex( o => o.id === obj.id)
        if(index !== -1) return
        data.unshift(obj)
        if(data.length > maxCount) {
            data = data.slice(0,maxCount)
        }
        QCTool.writeFile(savePath,JSON.stringify(data))
    }
    function remove(obj) {

    }
}
