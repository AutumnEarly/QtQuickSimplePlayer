
import QtQuick
import qc.window

Item {

    /*
        获取歌词
    */
    function getMusicLyric(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || ""
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)
                    var lyric = {}
                    try {
                        if(!res.hasOwnProperty("pureMusic")) {
                            let lrc = res.lrc.lyric
                            let tlrc = res.tlyric.lyric
                            lyric = parseLyric(lrc,tlrc)
                        } else {
                           let lrc = res.lrc.lyric
                           lyric = parseLyric(lrc,"")
                           console.log("这是纯音乐")
                        }
                    } catch (err) {
                        lyric = [{ "lyric": "当前暂无歌词哦~","tlrc": "",tim: 0  }]
                        console.log("歌词解析错误！" + err)
                    }



                    callBack({data: lyric,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/lyric?id=" + id); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        解析歌词
    */
    function parseLyric(lrc,tlrc) {

        var i = 0
        lrc = lrc.split('\n')
        tlrc = tlrc.split('\n')

        try {
            if(Array.isArray(lrc)) {

                for(i = 0; i < lrc.length;i++) {
                    if(!lrc[i]) continue
                    let t = lrc[i].match(/\[(.*?)\]\s*(.*)/)
                    let tim = t[1].split(':')
                    tim = parseInt(tim[0]) * 60*1000 + parseInt(parseFloat(tim[1])*1000)
                    lrc[i] = {tim: tim, lyric: t[2],tlrc: ""}
                }

            }
            if(Array.isArray(tlrc)) {

                for(i = 0; i < tlrc.length;i++) {
                    if(!tlrc[i]) continue
                    let t = tlrc[i].match(/\[(.*?)\]\s*(.*)/)
                    let tim = -1
                    if(!t) {
                        tlrc[i] = {tim: tim, lyric: ""}
                        continue
                    }
                    tim = t[1].split(':')
                    tim = parseInt(tim[0]) * 60*1000 + parseInt(parseFloat(tim[1])*1000)
                    tlrc[i] = {tim: tim, lyric: t[2]}
                }

            }

            if(Array.isArray(tlrc))
            for(i = 0; i < lrc.length;i++) {
                let index = tlrc.findIndex(r => lrc[i].tim === r.tim)
                if(index !== -1) {
                    lrc[i].tlrc = tlrc[index].lyric
                }
            }
        } catch(err) {
            console.log("歌词解析错误！" + err)
            for(i = 0; i < lrc.length;i++) {
               lrc[i] = { "lyric": lrc[i],"tlrc": "",tim: 0 }
            }
        }



        lrc = lrc.filter(item => item.lyric)
        return lrc
    }

    /*
        获取音乐URL
    */
    function getMusicUrl(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data[0]

                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/song/url?id=" + id); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取最新音乐
    */
    function getNewMusic(obj) {
        var xhr = new XMLHttpRequest()
        var type = obj.type || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data
                    res = res.map(obj=> {
                                return {
                                    id: obj.id,
                                    name: obj.name,
                                    artist: obj.artists.map(ar => ar.name).join("/ "),
                                    album: obj.album.name,
                                    coverImg: obj.album.picUrl,
                                    url: "",
                                    allTime: "00:00"
                                }
                             })
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/song?type=" + type); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取歌单列表
    */
    function getMusicPlayList(obj) {
        var xhr = new XMLHttpRequest()
        var cat = obj.cat || "全部"
        var limit = obj.limit || ""
        var order = obj.order || "hot"
        var offset = obj.offset || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/playlist?&cat="+cat+"&limit="+ limit +"&offset=" + offset); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取精品歌单
    */
    function getMusicBoutiquePlayList(obj) {
        var xhr = new XMLHttpRequest()
        var cat = obj.cat || "全部"
        var limit = obj.limit || ""
        var offset = obj.offset || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/top/playlist/highquality?cat="+cat+"&limit="+ limit + "&offset=" + offset); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取歌单详情
    */
    function getMusicPlayListDetail(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlist
                    res = {
                        id: res.id,
                        name: res.name,
                        description: res.description,
                        coverImg: res.coverImgUrl.split('?')[0],
                        trackIds: res.trackIds.map(obj=> {
                                                        return obj.id
                                                   })
                    }
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/playlist/detail?id=" + id); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取专辑详情
    */
    function getMusicAlbumDetail(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)

                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000//album?id=" + id); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取歌曲详情
    */
    function getMusicDetail(obj) {
        var xhr = new XMLHttpRequest()
        var ids = obj.ids || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).songs
                    res = res.map(obj=> {
                                return {
                                    id: obj.id,
                                    name: obj.name,
                                    artists: obj.ar,
                                    album: obj.al,
                                    coverImg: obj.al.picUrl,
                                    url: "",
                                    allTime: setAllTime(obj.dt)
                                }
                             })
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/song/detail?ids=" + ids); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        搜索音乐
    */
    function search(obj) {

        var xhr = new XMLHttpRequest()
        var key = obj.key || ""
        var type = obj.type || ""
        var limit = obj.limit || "50"
        var offset = obj.offset || "0"
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).result
                    callBack({data:res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/search?keywords=" + key +"&type="+type + "&limit="+limit+"&offset="+offset); // 发起 GET 请求
        xhr.send(); // 发送请求
    }
    /*
        获取歌手单曲
    */
    function getArtistsMusic(obj) {
        var xhr = new XMLHttpRequest()
        var id = obj.id || ""
        var callBack = obj.callBack || (()=>{})
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)

                    callBack({data: res,status:xhr.status})
                } else {
                    callBack({data:null,status:xhr.status})
                    console.error("Request failed: " + xhr.status); // 请求失败
                }
            }
        };
        xhr.open("GET", "http://localhost:3000/artists?id=" + id); // 发起 GET 请求
        xhr.send(); // 发送请求
    }

    /*
        歌曲时长解析
    */
    function setAllTime(time) {
        var h = parseInt(time / 1000 / 3600)
        h = h ? h : ""
        var m = parseInt(time / 1000 / 60)
        m = m < 10 ? "0"+ m : m
        var s = parseInt(time / 1000 % 60)
        s = s < 10 ? "0" + s : s
        return h !== "" ? h+":" : h + m +":" + s
    }
    /*
        设置播放歌曲信息
    */
    function setThisPlayMusic(info) {


        thisPlayMusicInfo.id = info.id || ""
        thisPlayMusicInfo.name = info.name || ""
        thisPlayMusicInfo.artist = info.artist || ""
        thisPlayMusicInfo.album = info.album || ""
        thisPlayMusicInfo.url = info.url || ""
        thisPlayMusicInfo.coverImg = info.coverImg || ""
        thisPlayMusicInfo.allTime = info.allTime || "00:00"
        thisPlayMusicInfoChanged()
    }
    /*
        查找是否有重复
    */
    function indexOf(findId) {
        var index = -1
        var isFind = false
        for(var j = 0; j < thisPlayListInfo.count;j++) {
            if(thisPlayListInfo.get(j).id === findId) {
                return j
            }
        }
        return index
    }
    /*
        添加新的歌曲
    */
    function appendPlayListInfo(info,insertIndex = 0) {
        var index = -1
        var isFind = false
        var findId = 0
        for(var i = 0; i < info.length;i++) {
            findId = info[i].id
            index = indexOf(findId)
            if(index === -1) {
                thisPlayListInfo.insert(++insertIndex,info[i])
                console.log("已添加 " +thisPlayListInfo.count)
            }
        }

    }

}
