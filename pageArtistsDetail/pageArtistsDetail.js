
/*
    歌手详情页 内部函数
*/

/*
    为播放列表添加并播放单曲
*/
function addPlayOneMusic(index, localCurrent = -1) {

    var musicInfo = [{
        id: hotOneMusicData[index].id,name: hotOneMusicData[index].name,artists: hotOneMusicData[index].artists,album: hotOneMusicData[index].album,
        url: "", coverImg: hotOneMusicData[index].coverImg,allTime: hotOneMusicData[index].allTime
    }]
    var findIndex = p_music_Player.thisPlayListInfo.findIndex( o => o.id === hotOneMusicData[index].id)
    if(localCurrent >= 0) {
        musicInfo[0].url = p_musicDownload.data[localCurrent].url
    }
    console.log("PageArtistsDetail.qml: " + findIndex)
    if(findIndex === -1) {
        p_music_Player.thisPlayListInfo.splice(p_music_Player.thisPlayingCurrent+1,0,hotOneMusicData[index])
        p_music_Player.thisPlayListInfoChanged()
        p_music_Player.thisPlayingCurrent += 1
    } else {
        p_music_Player.thisPlayingCurrent = findIndex
    }
    p_music_Player.playMusic(hotOneMusicData[index].id,musicInfo[0])
}

/*
    将播放列表替换为歌单列表
*/
function openRightMenu(parent , x , y , index) {

    oneMusicMenu.parent = parent
    oneMusicMenu.x = x
    oneMusicMenu.y = y
    oneMusicMenu.playListCurrent = index
    oneMusicMenu.open()
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

/*
    获取热门单曲
*/
function getHotOneMusicData(obj) {
    var xhr = new XMLHttpRequest()
    var id = obj.id || ""
    var callBack = obj.callBack || (() =>{})
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var res = JSON.parse(xhr.responseText)

                artistInfo = res.artist
                hotOneMusicData = res.hotSongs.map(r => {
                                        return {
                                            id: r.id,
                                            name: r.name,
                                            artists: r.ar,
                                            album: r.al,
                                            url: "",
                                            coverImg: r.al.picUrl,
                                            allTime: p_musicRes.setAllTime(r.dt)
                                        }
                                    })
                callBack()
            } else {
                console.error("Request failed: " + xhr.status); // 请求失败
            }
        }
    };
    xhr.open("GET", "http://localhost:3000/artists?id=" + id); // 发起 GET 请求
    xhr.send(); // 发送请求
}
/*
    获取专辑
*/
function getAlbumsData(obj) {
    var xhr = new XMLHttpRequest()
    var id = obj.id || ""
    var callBack = obj.callBack || (() =>{})
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var res = JSON.parse(xhr.responseText)
                albumsData = res.hotAlbums
                callBack()
            } else {
                console.error("Request failed: " + xhr.status); // 请求失败
            }
        }
    };
    xhr.open("GET", "http://localhost:3000/artist/album?id=" + id); // 发起 GET 请求
    xhr.send(); // 发送请求
}
/*
    选择显示类型
*/
function selectMode(mode = 0) {
    let onMuiscFunc = () => {
        artistsPageListView.model = [];

        if(hotOneMusicData.length) {
            artistsPageListView.model = hotOneMusicData;
            artistsPageListView.delegate = hotOneMusicDelegate;
        } else {
            let callBack = () => {
                artistsPageListView.model = hotOneMusicData;
                artistsPageListView.delegate = hotOneMusicDelegate;
            }
            getHotOneMusicData({id: getArtistInfo.id,callBack:callBack} );
        }

    }
    let albumsFunc = () => {
        artistsPageListView.model = 0;

        if(albumsData.length) {
            artistsPageListView.model = 1;
            artistsPageListView.delegate = albumsDelegate;
        }
        let callBack = () => {
            artistsPageListView.model = 1;
            artistsPageListView.delegate = albumsDelegate;
        }
        getAlbumsData({id: getArtistInfo.id,callBack:callBack} );

    }

    switch (mode) {
        case 0: onMuiscFunc();
            break;
        case 1: albumsFunc();
            break;
    }
    artistsPage.mode = mode;
}


