pragma Singleton
import QtQuick 2.15
import qc.window

/*
    主题管理
*/
Item {
    id: control
    property string themeName: theme.name // 当前主题名
    property QCTheme theme: QCTheme {} // 当前主题
    property QCTheme lastTheme: QCTheme {} // 上一次主题
    property var themeData: {
        "system": {"name": "系统主题",briefIntroduction: "系统自带的主题","data":[]},
        "user": {"name": "自定义主题",briefIntroduction: "这里是简介~","data": []} , "keyValue": ["system","user"]
    } // 所有主题
    property var config: { "name": control.theme.name , "type": control.theme.type }
    property string userThemeDataSavePath: "userInfo/themeData.json"
    property string userConfigSavePath: "userInfo/themeConfig.json"

    Component.onCompleted: {
        control.themeData["system"].data.push(control.theme)
        let obj = [
        {
           name: "青色",fontColor: "263339",
           backgroundColor:"E0F2F1",backgroundColor_2:"FFFFFF",
           iconColor:"26A69A",iconColor_2:"FFFFFF",type: "system"
        }]
        let parseUserData = () => {
            let data = QCTool.readFile(control.userThemeDataSavePath)
            try {
                data = JSON.parse(data)
                if(!Array.isArray(data)) data = []

            } catch(err) {
                data = []
                console.log("转换失败！" + err)
            }
            return data
        }
        control.add(parseUserData())
        control.add(obj)
    }

    onThemeChanged: {
        config.name = theme.name
        config.type = theme.type
    }

    function switchTheme(name, type = "system") {
        let obj = null
        let i = 0

        for( i =0;i < control.themeData[type].data.length;i++) {
            if(control.themeData[type].data[i].name === name) {
                obj = control.themeData[type].data[i]
                break
            }
        }
        if(!obj)
        for(let key in control.themeData) {


            if(typeof control.themeData[key] !== "object" || Array.isArray(control.themeData[key])) continue

            let value = control.themeData[key].data
            for( i =0;i < value.length;i++) {
                if(value[i].name === name) {
                    obj = value[i]
                    break
                }
            }
//            console.log("key: " + key + " value " + value)
        }

        if(!obj) {
            console.log("主题切换失败！" + obj)
            return
        }

        control.lastTheme = control.theme
        control.theme = obj
    }
    function add(obj, isWrite = true) {
        let arr = []
        let isChanged = false
        if(Array.isArray(obj)) {
            arr = obj
        } else {
            arr.push(obj)
        }
        for(let i = 0; i < arr.length;i++) {

            let component = Qt.createComponent("QCTheme.qml");
            let t = null
            if (component.status === Component.Ready) {
                t = component.createObject(control);
            }
            if(!t) {
                console.log("主题控件创建失败")
                continue
            }

            t.name = arr[i].name || ""
            t.fontColor = arr[i].fontColor || ""
            t.backgroundColor = arr[i].backgroundColor || ""
            t.backgroundColor_2 = arr[i].backgroundColor_2 || ""
            t.iconColor = arr[i].iconColor || ""
            t.iconColor_2 = arr[i].iconColor_2 || ""
            t.type = arr[i].type || ""

            control.themeData[t.type].data.push(t)
            isChanged = true
        }
        if(isWrite) {
            QCTool.writeFile(control.userThemeDataSavePath,JSON.stringify(control.themeData["user"].data))
        }


        control.themeDataChanged()
    }
    function indexOf(obj) {
        let index = -1
        let i = 0
        for(let key in control.themeData) {
            if(typeof control.themeData[key] !== "object" || Array.isArray(control.themeData[key])) continue

            let value = control.themeData[key].data
            for( i =0;i < value.length;i++) {
                if(value[i].name === obj.name) {
                    index = i
                    break
                }
            }
        }
        return index
    }

    function updateUserData() {

        QCTool.writeFile(control.userThemeDataSavePath,JSON.stringify(control.themeData["user"].data))
    }
}
