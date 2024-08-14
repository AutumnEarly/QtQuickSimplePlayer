
/*
    搜索页 内部函数
*/

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
    return h
}
/*
    更新所有数据
*/
function updateAll() {
    initPageCountInfo()
    contentCacheBuffer = []
    contentModel.clear()
    search(headerData[headerCurrent].type)
}
/*
    初始化操作信息
*/
function initPageCountInfo() {
    contentCurrent = -1
    pageCount = 0
    thisPage = 0
    switchPageBar.curretIndex = 0
    isFind = false

}
/*
    搜索
*/
function search(type = "1") {

    switch(type) {
        case "1": searchSongs(searchText)
        break
        case "10": searchAlbums(searchText)
        break
        case "1000": searchPlayLists(searchText)
        break
    }
}
/*
    搜索单曲
*/
function searchSongs(keywords) {

    console.log("当前搜索单曲")

    var song = "1"
    var searchCallBack = res => {
        if(res.data === null) return

        isFind = true
        allCount = res.data.songCount
        pageCount = Math.ceil(allCount / limit)
        count = res.data.songs.length
        content.height = res.data.songs.length * 80 + 30
        console.log("共: " + allCount +"当前返回: " + count +",页: "+ thisPage + ",数量," + pageCount + "页" )
        res = res.data.songs.map(obj=> {
                    return {
                        id: obj.id,
                        name: obj.name,
                        artists: obj.ar,
                        album: obj.al,
                        coverImg: obj.al.picUrl,
                        url: "",
                        allTime: p_musicRes.setAllTime(obj.dt)
                    }
                 })
        contentCacheBuffer[thisPage] = res
        contentData = contentCacheBuffer[thisPage]
        contentRepeater.model = contentData

        setVisible(musicSearchPageFlickable.contentY)
    }
    contentRepeater.delegate = songsDelegate
    contentRepeater.model = 0
    content.height = 0
    p_musicRes.search({key:keywords,type:song,callBack:searchCallBack,
                          limit:limit,offset:thisPage})
}
/*
    搜索歌单
*/
function searchPlayLists(keywords) {
    console.log("当前搜索歌单")

    var playList = "1000"
    var searchCallBack = res => {
        if(res.data === null) return
        isFind = true
        allCount = res.data.playlistCount
        pageCount = Math.ceil(allCount / limit)
        count = res.data.playlists.length
        content.height = res.data.playlists.length * 80 + 30
        console.log("共: " + allCount +"当前返回: " + count +",页: "+ thisPage + ",数量," + pageCount + "页" )
        res = res.data.playlists.map(obj=> {
                    return {
                      id: obj.id,
                      name: obj.name,
                      description: obj.description || "",
                      nickname: obj.creator.nickname,
//                      createImg: obj.creator.avatarUrl,
                      coverImg: obj.coverImgUrl.split('?')[0],
                      trackCount: obj.trackCount,
                      playCount: obj.playCount
                    }
                 })
        contentCacheBuffer.push(res)
        contentModel.append(res)

        setVisible(musicSearchPageFlickable.contentY)
    }
    contentModel.clear()
    contentRepeater.model = contentModel
    contentRepeater.delegate = playListDelegate
    content.height = 0
    p_musicRes.search({key:keywords,type:playList,callBack:searchCallBack,
                          limit:limit,offset:thisPage})
}
/*
    搜索专辑
*/
function searchAlbums(keywords) {
    console.log("当前搜索专辑")

    var album = "10"
    var searchCallBack = res => {
        if(res.data === null) return
        isFind = true
        allCount = res.data.albumCount
        pageCount = Math.ceil(allCount / limit)
        count = res.data.albums.length
        console.log("共: " + allCount +"当前返回: " + count +",页: "+ thisPage + ",数量," + pageCount + "页" )
        res = res.data.albums.map(obj=> {
                    return {
                      id: obj.id,
                      name: obj.name,
                      artist: obj.artist.name,
                      coverImg: obj.blurPicUrl.split('?')[0],
                      description: obj.description || "",
                    }
                 })
        content.height = res.length * 80 + 30
        contentCacheBuffer[thisPage] = res
        contentModel.append(res)

        setVisible(musicSearchPageFlickable.contentY)
    }

    contentModel.clear()
    contentRepeater.model = contentModel
    contentRepeater.delegate = albumDelegate
    content.height = 0
    p_musicRes.search({key:keywords,type:album,callBack:searchCallBack,
                          limit:limit,offset:thisPage})
}
/*
    切换页面
*/
function switchPage(page) {
    if(contentCacheBuffer[page] !== undefined ) {
        console.log("借用缓存")
        contentModel.clear()
        contentModel.append(contentCacheBuffer[page])
        setVisible(musicSearchPageFlickable.contentY)
    } else {
        search(headerData[headerCurrent].type)
    }
}

/*
    设置委托项是否加载
*/
function setVisible(contentY) {
    if(musicSearchPageFlickable.count <= 0) return
    if(contentRepeater.count <= 0) return
    var step = musicSearchPageFlickable.wheelStep
    var i = 0
    var t = loadItem.slice(0,loadItem.length)
    loadItem = []
    for(i = 0; i < contentRepeater.count;i++) {
        var startY = (content.y+ i * contentItemHeight)
        var endY = (musicSearchPageFlickable.contentY +musicSearchPageFlickable.height)
        if(startY+step >= contentY) {
            if(startY < endY+step) {
                loadItem.push(i)
            } else break
        }
    }

    for(i = 0; i < loadItem.length;i++) {
        contentRepeater.itemAt(loadItem[i]).visible = true
    }
    for(i = 0; i < t.length;i++) {
        if(loadItem.indexOf(t[i]) === -1) {
            contentRepeater.itemAt(t[i]).visible = false
        }
    }

//        console.log("loadItems: " + JSON.stringify(loadItem))
//        console.log("lastItems: " + JSON.stringify(t))
}
