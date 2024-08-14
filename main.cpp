#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "framelesswindow.h"
#include "imagecolor.h"
#include "downloadtask.h"
#include "musicdownload.h"
#include "desktoplyric.h"
#include "qctool.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/musicPlayerDemo/main.qml"_qs);

    qmlRegisterType<FramelessWindow>("qc.window",1,0,"FramelessWindow");
    qmlRegisterType<ImageColor>("qc.window",1,0,"ImageColor");
    qmlRegisterType<MusicDownload>("qc.window",1,0,"MusicDownload");
    qmlRegisterType<DownloadTask>("qc.window",1,0,"DownloadTask");
    qmlRegisterType<DesktopLyric>("qc.window",1,0,"DesktopLyric");

    QCTool qcTool;
    // 将 QCTool 对象注册为 QML 上下文属性
    engine.rootContext()->setContextProperty("QCTool", &qcTool);

    QCoreApplication::setOrganizationName("appEarlyAutumn.org");

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
