cmake_minimum_required(VERSION 3.16)

project(musicPlayerDemo VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 14)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Multimedia)

set(CMAKE_AUTORCC ON)
qt_add_executable(appmusicPlayerDemo
    main.cpp
)

qt_add_qml_module(appmusicPlayerDemo
    URI musicPlayerDemo
    VERSION 1.0
    QML_FILES main.qml
    SOURCES desktoplyric.cpp desktoplyric.h
    SOURCES downloadtask.cpp downloadtask.h
    SOURCES downloadtaskthread.cpp downloadtaskthread.h
    SOURCES framelesswindow.cpp framelesswindow.h
    SOURCES imagecolor.cpp imagecolor.h
    SOURCES musicdownload.cpp musicdownload.h
    RESOURCES ImageResource.qrc
    QML_FILES MusicResource.qml
    QML_FILES QCMusicPlayer.qml
    QML_FILES QCBottomBar.qml  QCLeftBar.qml  QCRightContent.qml QCTitleBar.qml QCTitleBarSearchBox.qml
    # 发现详情页
    QML_FILES pageQml/PageFindMusic.qml
    QML_FILES pageQml/pageFindMusicContent/FindMusicNewMusicContent.qml

    # 最近播放详情页
    QML_FILES pageQml/PageHistoryRecordDetail.qml
    QML_FILES pageQml/pageHistoryRecordDetail/FooterItem.qml
    QML_FILES pageQml/pageHistoryRecordDetail/HeaderItem.qml
    QML_FILES pageQml/pageHistoryRecordDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageHistoryRecordDetail/pageHistoryRecordDetail.js
    QML_FILES pageQml/pageHistoryRecordDetail/OneMusicMenu.qml

    # 本地与下载详情页
    QML_FILES pageQml/PageLocalDownloadDetail.qml
    QML_FILES pageQml/pageLocalDownloadDetail/FooterItem.qml
    QML_FILES pageQml/pageLocalDownloadDetail/HeaderItem.qml
    QML_FILES pageQml/pageLocalDownloadDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageLocalDownloadDetail/pageLocalDownloadDetail.js
    QML_FILES pageQml/pageLocalDownloadDetail/OneMusicMenu.qml

    # 专辑详情页
    QML_FILES pageQml/PageMusicAlbumDetail.qml
    QML_FILES pageQml/pageMusicAlbumDetail/FooterItem.qml
    QML_FILES pageQml/pageMusicAlbumDetail/HeaderItem.qml
    QML_FILES pageQml/pageMusicAlbumDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageMusicAlbumDetail/pageMusicAlbumDetail.js
    QML_FILES pageQml/pageMusicAlbumDetail/OneMusicMenu.qml

    # 喜欢歌单详情页
    QML_FILES pageQml/PageMusicFavoriteDetail.qml
    QML_FILES pageQml/pageMusicFavoriteDetail/HeaderItem.qml
    QML_FILES pageQml/pageMusicFavoriteDetail/FooterItem.qml
    QML_FILES pageQml/pageMusicFavoriteDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageMusicFavoriteDetail/pageMusicFavoriteDetail.js
    QML_FILES pageQml/pageMusicFavoriteDetail/OneMusicMenu.qml

    # 歌词详情页
    QML_FILES pageQml/PageMusicLyricDetail.qml
    QML_FILES pageQml/pageMusicLyricDetail/LyricListView.qml
    QML_FILES pageQml/pageMusicLyricDetail/ContentItem.qml
    QML_FILES pageQml/pageMusicLyricDetail/HeaderItem.qml
    QML_FILES pageQml/pageMusicLyricDetail/FooterItem.qml
    QML_FILES pageQml/pageMusicLyricDetail/BackgroundManager.qml

    # 歌单页
    QML_FILES pageQml/PageMusicPlayList.qml
    QML_FILES pageQml/pageMusicPlayList/FooterItem.qml
    QML_FILES pageQml/pageMusicPlayList/HeaderItem.qml
    QML_FILES pageQml/pageMusicPlayList/ContentItem.qml
    QML_FILES pageQml/pageMusicPlayList/pageMusicPlayList.js
    QML_FILES pageQml/pageMusicPlayList/PlayListsItem.qml
    QML_FILES pageQml/pageMusicPlayList/BoutiquePlayListItem.qml

    # 歌单详情页
    QML_FILES pageQml/PageMusicPlayListDetail.qml
    QML_FILES pageQml/pageMusicPlayListDetail/HeaderItem.qml
    QML_FILES pageQml/pageMusicPlayListDetail/FooterItem.qml
    QML_FILES pageQml/pageMusicPlayListDetail/pageMusicPlayListDetail.js
    QML_FILES pageQml/pageMusicPlayListDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageMusicPlayListDetail/OneMusicMenu.qml

    # 音乐详情页
    QML_FILES pageQml/PageMusic.qml

    # 搜索详情页
    QML_FILES pageQml/PageMusicSearchDetail.qml
    QML_FILES pageQml/pageMusicSearchDetail/pageMusicSearchDetail.js
    QML_FILES pageQml/pageMusicSearchDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageMusicSearchDetail/PlayListDelegate.qml
    QML_FILES pageQml/pageMusicSearchDetail/AlbumDelegate.qml
    QML_FILES pageQml/pageMusicSearchDetail/HeaderItem.qml
    QML_FILES pageQml/pageMusicSearchDetail/ContentItem.qml
    QML_FILES pageQml/pageMusicSearchDetail/FooterItem.qml

    # 歌手详情页
    QML_FILES pageQml/PageArtistsDetail.qml
    QML_FILES pageQml/pageArtistsDetail/pageArtistsDetail.js
    QML_FILES pageQml/pageArtistsDetail/HotOneMusicDelegate.qml
    QML_FILES pageQml/pageArtistsDetail/AlbumsDelegate.qml
    QML_FILES pageQml/pageArtistsDetail/HeaderItem.qml
    QML_FILES pageQml/pageArtistsDetail/FooterItem.qml
    QML_FILES pageQml/pageArtistsDetail/OneMusicMenu.qml

    # 我的歌单详情页
    QML_FILES pageQml/PageMyMusicPlayListDetail.qml
    QML_FILES pageQml/PageEditMyPlayListDetail.qml
    QML_FILES pageQml/pageMyMusicPlayListDetail/HeaderItem.qml
    QML_FILES pageQml/pageMyMusicPlayListDetail/pageMusicPlayListDetail.js
    QML_FILES pageQml/pageMyMusicPlayListDetail/OneMusicDelegate.qml
    QML_FILES pageQml/pageMyMusicPlayListDetail/FooterItem.qml
    QML_FILES pageQml/pageMyMusicPlayListDetail/OneMusicMenu.qml

    # 本地文件夹详情页
    QML_FILES pageQml/PageLocalFolderDetail.qml
    QML_FILES pageQml/pageLocalFolderDetail/ContentItem.qml
    QML_FILES pageQml/pageLocalFolderDetail/FooterItem.qml
    QML_FILES pageQml/pageLocalFolderDetail/HeaderItem.qml
    QML_FILES pageQml/pageLocalFolderDetail/pageLocalFolderDetail.js
    QML_FILES pageQml/pageLocalFolderDetail/FolderShowItem.qml
    QML_FILES pageQml/pageLocalFolderDetail/AllShowItem.qml

    # 公共组件
    QML_FILES qcComponent/QCDesktopLyric.qml
    QML_FILES qcComponent/QCImage.qml
    QML_FILES qcComponent/QCPlayListLable.qml
    QML_FILES qcComponent/QCScrollBar.qml
    QML_FILES qcComponent/QCSwitchPageBar.qml
    QML_FILES qcComponent/QCThisPlayListLabel.qml
    QML_FILES qcComponent/QCToolTipButton.qml
    QML_FILES qcComponent/QCVolumeBtn.qml
    QML_FILES qcComponent/RoundImage.qml
    QML_FILES qcComponent/menu/QCMenu.qml qcComponent/menu/QCMenuItem.qml
    QML_FILES theme/QCTheme.qml theme/QCThemeManager.qml
    QML_FILES qcComponent/QCThemeConfigLabel.qml
    QML_FILES qcComponent/QCMiniPage.qml
    QML_FILES qcComponent/themeConfig/RightMenu.qml
    QML_FILES qcComponent/themeConfig/AddThemePopup.qml
    SOURCES qctool.h qctool.cpp
    QML_FILES qcComponent/themeConfig/SettingThemePopup.qml

    QML_FILES qcComponent/QCCreatePlayListPopup.qml
    QML_FILES qcComponent/QCSelectAddPlayListPopup.qml
    RESOURCES theme/qmldir

    RESOURCES qmldir
    RESOURCES qcComponent/qmldir
    QML_FILES pageQml/pageMusic/HeaderItem.qml


    QML_FILES singletonComponent/HistoryRecordManager.qml
    QML_FILES singletonComponent/MyPlayListManager.qml
    QML_FILES singletonComponent/FavoriteManager.qml
    RESOURCES singletonComponent/qmldir











)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmusicPlayerDemo PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmusicPlayerDemo
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmusicPlayerDemo
    PRIVATE Qt6::Quick)
target_link_libraries(appmusicPlayerDemo
    PRIVATE Qt6::Multimedia)

include(GNUInstallDirs)
install(TARGETS appmusicPlayerDemo
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
