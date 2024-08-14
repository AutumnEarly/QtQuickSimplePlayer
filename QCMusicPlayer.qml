
import QtQuick
import QtMultimedia
import "./singletonComponent"

Item {
    id: musicPlayer
    enum PlayerMode {
        ONELOOPPLAY = 0,
        LOOPPLAY,
        RANDOMPLAY,
        PLAYLISTPLAY
    }
    property int randomCurrent: -1
    property int thisPlayingCurrent: -1
    property var thisPlayListInfo: []
    property var randomPlayListIndex: []
    property var thisPlayMusicInfo: {
        "id":"",
        "name":"",
        "artists": [{"id":"","name":""}],
        "album": {"id":"","name":""},
        "coverImg":"",
        "url":"",
        "allTime":"00:00"
    }
    property ListModel thisMusicLyric: ListModel {

    }

    property string source: musicPlayer.thisPlayMusicInfo.url

    property alias duration: mediaPlayer.duration
    property alias position: mediaPlayer.position
    property alias playbackState: mediaPlayer.playbackState
    property alias bufferProgress: mediaPlayer.bufferProgress

    property int playModelength: 4
    property int playMode: QCMusicPlayer.PlayerMode.LOOPPLAY

    property double volume: .7
    property double lastVolume: volume

    property bool isPaused: true

    onThisPlayMusicInfoChanged: {
        console.log("当前播放音乐信息:" + thisPlayingCurrent + "  " + JSON.stringify(thisPlayMusicInfo))
        if("file" === thisPlayMusicInfo.url.slice(0,4) || thisPlayMusicInfo.id === "") {
            console.log("本地音乐：无歌词")
            return
        }
        thisMusicLyric.clear()
        var lyricCallBack = res => {
            if(!res.data) return
            thisMusicLyric.append(res.data)
        }

        p_musicRes.getMusicLyric({id: thisPlayMusicInfo.id,callBack: lyricCallBack})
    }
    onThisPlayListInfoChanged: {
        var i = 0,j = 0
        var t = null
        randomPlayListIndex = Array.from({length: thisPlayListInfo.length - 0}, (_, index) => index + 0);
        for (let i = randomPlayListIndex.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [randomPlayListIndex[i], randomPlayListIndex[j]] = [randomPlayListIndex[j], randomPlayListIndex[i]];
        }

        console.log(JSON.stringify(randomPlayListIndex))
    }


    Component.onCompleted: {
        if(thisPlayMusicInfo.url || thisPlayListInfo.length <= 0) return
        let musicUrlCallBack = res => {
            if(res.data.url === "") {
                console.log("音乐URL获取失败！！")
                return
            }
            let t = JSON.parse(JSON.stringify(thisPlayMusicInfo))
            t.url = res.data.url
            thisPlayMusicInfo = t
            console.log("当前歌曲总数: " +thisPlayListInfo.length)
        }

        p_musicRes.getMusicUrl({id: thisPlayMusicInfo.id,callBack:musicUrlCallBack})

    }

    onIsPausedChanged: {
        if(isPaused) {
            delayVolumeAni.to = 0.1
        } else {
            mediaPlayer.play()
            delayVolumeAni.to = lastVolume
        }
        lastVolume = volume
        delayVolumeAni.restart()
    }

    NumberAnimation { // 缓速提升下降音量
        id: delayVolumeAni
        target: musicPlayer
        property: "volume"
        duration: 300
        easing.type: Easing.Linear
        onStopped: {
            if(isPaused) {
                mediaPlayer.pause()
                volume = lastVolume
            }
            // 检查是否播放成功
            if(mediaPlayer.playbackState === MediaPlayer.PlayingState) {
                musicPlayer.isPaused = false
            } else {
                if(musicPlayer.isPaused === false) { // 如果播放失败那就在获取一次音乐URL
                    musicPlayer.playMusic(thisPlayMusicInfo.id,thisPlayMusicInfo)
                }
                musicPlayer.isPaused = true
            }
        }
    }

    MediaPlayer {
        id: mediaPlayer
        source: musicPlayer.source
        audioOutput: AudioOutput {
            volume: musicPlayer.volume
        }

        onPlaybackStateChanged: {

            if(playbackState === MediaPlayer.StoppedState || playbackState === MediaPlayer.PausedState) {
                musicPlayer.isPaused = true
            }
            if(playbackState === MediaPlayer.StoppedState && position === duration) {
                autoNextPlay()
            }
        }
        onErrorChanged: {

        }
    }

    function playMusic(id,info) {  // 播放音乐 并且设置当前音乐信息

        let musicUrlCallBack = res => {
            if(res.data.url === "") {
                console.log("音乐URL获取失败！！")
                return
            }
            let t = JSON.parse(JSON.stringify(info))
            t.url = res.data.url
            thisPlayMusicInfo = t
            console.log("当前歌曲总数: " +thisPlayListInfo.length)

            musicPlayer.isPaused = false
        }

        if(info.url &&  "file" === info.url.slice(0,4)) {
            thisPlayMusicInfo = info
            console.log("当前歌曲总 数: " +thisPlayListInfo.length)
            musicPlayer.isPaused = false
        } else {
            p_musicRes.getMusicUrl({id:id,callBack:musicUrlCallBack})
        }

        HistoryRecordManager.add(info)
    }
    function pause() { // 暂停音乐
        musicPlayer.isPaused = true
    }
    function play() { // 播放音乐
        musicPlayer.isPaused = false
    }
    function preMusicPlay() { // 播放上一首音乐
        var current = thisPlayingCurrent
        if(current <= -1) {
            return
        }

        if(QCMusicPlayer.PlayerMode.RANDOMPLAY === playMode) {
            for(var i = 0; i < randomPlayListIndex.length;i++) {
                if(current === randomPlayListIndex[i]) {
                    current = i
                    break
                }
            }
            randomCurrent = current ? current-1 : randomPlayListIndex.length - 1
            current = randomPlayListIndex[randomCurrent]
        } else {
            current = current ? current-1 : thisPlayListInfo.length - 1
        }
        thisPlayingCurrent = current
        playMusic(thisPlayListInfo[current].id,thisPlayListInfo[current])
    }
    function nextMusicPlay() { // 播放下一首音乐

        var current = thisPlayingCurrent
        if(current <= -1) {
            return
        }
        if(QCMusicPlayer.PlayerMode.RANDOMPLAY === playMode) {
            for(var i = 0; i < randomPlayListIndex.length;i++) {
                if(current === randomPlayListIndex[i]) {
                    current = i
                    break
                }
            }
            randomCurrent = (current+1) % randomPlayListIndex.length
            current = randomPlayListIndex[randomCurrent]
        } else {
            current = (current + 1) % thisPlayListInfo.length
        }

        thisPlayingCurrent = current
        playMusic(thisPlayListInfo[current].id,thisPlayListInfo[current])
    }

    function autoNextPlay() { // 自动播放下一首音乐
        var mode = musicPlayer.playMode
        switch(mode) {
            case QCMusicPlayer.PlayerMode.ONELOOPPLAY:
                play()
            break
            case QCMusicPlayer.PlayerMode.LOOPPLAY:
                nextMusicPlay()
            break
            case QCMusicPlayer.PlayerMode.RANDOMPLAY:
                nextMusicPlay()
            break
            case QCMusicPlayer.PlayerMode.PLAYLISTPLAY:
                if(thisPlayingCurrent+1 === thisPlayListInfo.length) return
                nextMusicPlay()
            break
        }
    }

    function setPlayerModel() { // 设置播放
        playMode = (playMode+1) % playModelength
    }

}


