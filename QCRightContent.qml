import QtQuick
import "./theme"

Rectangle {
    id: rightContent

    property QCTheme thisTheme: ThemeManager.theme
    property alias item: rightContentLoader.item
    property var page: []
    property string thisQml: ""
    property int pageCurrent: -1
    property int pageStepCount: 0
    width: content.width - leftBar.width
    height: parent.height
    radius: 10
    border.width: 2
    color: "#"+thisTheme.backgroundColor
    border.color: "#" + thisTheme.backgroundColor_2
    Component.onCompleted:  {
        let thisQml = leftBar.thisQml
        let btnText = leftBar.thisBtnText
        let func = () => {
            leftBar.thisQml = thisQml
            leftBar.thisBtnText = btnText
        }

        push({name: leftBar.thisBtnText,callBack:func,data:{}})
    }
    Binding on thisQml {
        restoreMode: Binding.RestoreBindingOrValue
        when: leftBar.thisBtnText !== ""
        value: leftBar.thisQml
    }

    function push(obj) {
        // 如果不是在顶层操作那么就从当前位置截断操作
        if(pageCurrent  !== page.length - 1) {
            page.splice(0,pageCurrent-1)
        }

        page.push(obj)
        pageCurrent = page.length - 1

        // 如果当前命令的前一个命令名和当前命令名相同那么删除前一个命令 以当前新的命令为准
        if(pageCurrent-1 >= 0 && page[pageCurrent-1].name === page[pageCurrent].name ) {
            page.splice(pageCurrent-1,1)
            pageCurrent = page.length - 1
        }


//        console.log(JSON.stringify(page))
        pageStepCount = page.length
        console.log("添加操作: " + obj.name + " current: " + pageCurrent + " count: " + pageStepCount)
    }
    function previousStep() {
        if(pageCurrent <= 0) return
        pageCurrent -= 1
        let o = page[pageCurrent]
        o.callBack()
        console.log("当前操作: " + o.name)
    }
    function nextStep() {
        if(pageCurrent >= page.length-1) return
        pageCurrent += 1
        let o = page[pageCurrent]
        o.callBack()
        console.log("当前操作: " + o.name)
    }

    Loader {
        id: rightContentLoader
        source: rightContent.thisQml
        onLoaded: {
            if(status === Loader.Ready) {
                item.parent = parent

                console.log("当前加载页面: " + thisQml + " item.parent: " + item.parent)
            }
        }
    }

}
