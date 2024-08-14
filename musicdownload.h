#ifndef MUSICDOWNLOAD_H
#define MUSICDOWNLOAD_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QCoreApplication>
#include <QMap>
#include <QThread>
#include <QDebug>
#include <mutex>
#include "downloadtaskthread.h"

class MusicDownload  : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount NOTIFY countChanged FINAL)
    Q_PROPERTY(QMap<QString,Downloadtaskthread*> downloadInfos READ downloadInfos WRITE setDownloadInfos NOTIFY downloadInfosChanged FINAL)
    Q_PROPERTY(QString downloadSavePath READ downloadSavePath WRITE setDownloadSavePath NOTIFY downloadSavePathChanged FINAL)
    Q_PROPERTY(QJsonArray data READ data NOTIFY dataChanged FINAL)
public:
    explicit MusicDownload(QObject * parent = nullptr);
    ~MusicDownload();

    Q_INVOKABLE void startDownload(const QString& taskId,const QJsonObject & obj);
    Q_INVOKABLE void pauseDownload(const QString& taskId);
    Q_INVOKABLE void cancelDownload(const QString& taskId);
    Q_INVOKABLE void addTask(const QString &url,const QString &fileName, const QString & taskId);
    Q_INVOKABLE void moveTask(const QString& taskId);

    Q_INVOKABLE int loaclIndexOf(const QString & id);
    Q_INVOKABLE void addLocalMusic(const QJsonValue& obj);

    int getCount() const;
    void setCount(int newCount);

    QMap<QString,Downloadtaskthread*> downloadInfos() const;
    void setDownloadInfos(const QMap<QString,Downloadtaskthread*> &newDownloadInfos);

    QString downloadSavePath() const;
    void setDownloadSavePath(const QString &newDownloadSavePath);

    QJsonArray data() const;
    void setData(const QJsonArray &newData);

signals:
    void dataValueChanged();

    void countChanged();

    void downloadInfosChanged();
    void downloadSavePathChanged();

    void dataChanged();

private slots:
    void onDataValueChanged();
private:
    void writeFile(const QString &filePath, const QJsonArray &jsonData);
    QJsonArray readFile(const QString &filePath);

    // 正在下载或在下载任务中的数据
    QMap<QString,Downloadtaskthread*> m_downloadInfos;
    // 已经下载完成的数据
    QJsonArray m_data;
    std::mutex m_mutex;
    QString m_downloadSavePath = "Download/";
    QString m_savePath = "userInfo/downloadInfo.json";
    int m_count = 0;
    int m_taskCount = 0;


};

#endif // MUSICDOWNLOAD_H
