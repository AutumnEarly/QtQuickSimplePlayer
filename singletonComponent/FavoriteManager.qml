pragma Singleton
import QtQuick
import qc.window

Item {
    id: favoriteManager
    property var data: []
    property string savePath: "userInfo/favoriteMusic.json"
    property int maxCount: 100
    Component.onCompleted: {
        let t = QCTool.readFile(savePath)
        try {
            t = JSON.parse(t)
        } catch(err) {
            t = []
            console.log("FavoriteManager.qml: " + err)
        }
        data = t
    }


    function append(obj) {
        if(Array.isArray(obj)) {
            for(let i = 0; i < obj.length;i++) {
                let index = data.findIndex( o => o.id === obj.id)

                if(index !== -1) continue
                data.unshift(obj)
            }
        } else {
            let index = data.findIndex( o => o.id === obj.id)

            if(index !== -1) return
            data.unshift(obj)
        }

        if(data.length > maxCount) {
            data = data.slice(0,maxCount)
        }
        favoriteManager.dataChanged()
        QCTool.writeFile(savePath,JSON.stringify(data))
    }
    function remove(obj) {
        let index = data.findIndex( o => o.id === obj.id)
        if(index === -1) return

        data.splice(index,1)
        favoriteManager.dataChanged()
        QCTool.writeFile(savePath,JSON.stringify(data))
    }
    function favoriteIndexOf(id) {
        let index = data.findIndex( o => o.id === id)
        return index
    }
}
