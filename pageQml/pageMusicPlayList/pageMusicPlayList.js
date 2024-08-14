
/*
    获取歌单数据并设置
    cat: 获取歌单类型
*/
function setPlayListData(obj) {
    let cat = obj.cat || "ACG"
    let limit = musicPlayListPage.limit
    let offset = obj.offset || "0"

    var playListCallBack = function(res) {
        if(res.data === null) return
        content.playListItem.model = 0
        let playlists = res.data.playlists.map(obj=> {
                                                   return {
                                                       id: obj.id,
                                                       name: obj.name,
                                                       description: obj.description,
                                                       coverImg: obj.coverImgUrl.split('?')[0],
                                                       creater: obj.creator,
                                                       updateTime: obj.updateTime,
                                                       createTime: obj.createTime,
                                                   }
                                                })
        playListData = playlists
        playListCount = playListData.length
        playListAllCount = res.data.total

        console.log("playList: " + JSON.stringify(playlists[0]))
        console.log("歌单: 共: " + playListAllCount +",已获取: " + playListCount + ",页: "+ offset)
    }
    p_musicRes.getMusicPlayList({cat:cat,limit: limit,offset:offset,callBack:playListCallBack})

}
/*
    获取精品歌单数据并设置
    cat: 获取歌单类型
*/
function setBoutiquePlayListData(obj) {
    let cat = obj.cat || "ACG"
    let limit = musicPlayListPage.limit
    let offset = obj.offset || "0"
    var boutiquePlayListCallBack = res=> {
        if(res.data === null) return
        content.boutiquePlayListItem.model = 0
        let playlists = res.data.playlists.map(obj=> {
                                                   return {
                                                       id: obj.id,
                                                       name: obj.name,
                                                       description: obj.description,
                                                       coverImg: obj.coverImgUrl.split('?')[0],
                                                       creater: obj.creator,
                                                       updateTime: obj.updateTime,
                                                       createTime: obj.createTime,
                                                   }
                                                })

        boutiquePlayListData = playlists
        boutiquePlayListCount = boutiquePlayListData.length
        boutiquePlayListAllCount = res.data.total

        console.log("精品歌单: 共: " + boutiquePlayListAllCount +",已获取: " + boutiquePlayListCount + ",页: "+ offset)
    }
    p_musicRes.getMusicBoutiquePlayList({cat:cat,limit: limit,offset:offset,callBack: boutiquePlayListCallBack})
}
/*
    获取歌单类型
*/
function setPlayListCat(obj) {
    let xhr = new XMLHttpRequest()
    let callBack = obj.callBack || (()=>{})
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                let res = JSON.parse(xhr.responseText);
                if(res.code !== 200) return;
                let i = 0;

                let classifyCat = [];
                for(let key in res.categories) {
                    classifyCat.push({"classifyName": res.categories[key],"data": []})
                }

                for(i = 0; i < res.sub.length;i++) {
                    let t = res.sub[i]
                    classifyCat[t.category].data.push(t)
                }

                playListCategories = classifyCat;
//                console.log("PageMusicPlayList.qml: classifyCat: " + JSON.stringify(playListCategories))
                callBack({data: classifyCat,status:xhr.status});
            } else {
                callBack({data:null,status:xhr.status});
                console.error("Request failed: " + xhr.status); // 请求失败
            }
        }
    };
    xhr.open("GET", "http://localhost:3000/playlist/catlist"); // 发起 GET 请求
    xhr.send(); // 发送请求
}


/*
    获取Column组件的高度
*/
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
//        console.log("height: " + h)
    return h
}
