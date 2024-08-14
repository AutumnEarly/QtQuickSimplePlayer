#ifndef DOWNLOADTASK_H
#define DOWNLOADTASK_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QThread>

class DownloadTask  : public QObject {
    Q_OBJECT
    Q_PROPERTY(TaskStatus status READ status WRITE setStatus NOTIFY statusChanged FINAL)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged FINAL)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged FINAL)
    Q_PROPERTY(QString savePath READ savePath WRITE setSavePath NOTIFY savePathChanged FINAL)
    Q_PROPERTY(double progressValue READ progressValue NOTIFY progressValueChanged FINAL)

public:
    enum TaskStatus {
        Normal = 0,
        Loading,
        Paused,
        Cancel,
        Ready,
        Error
    };
    Q_ENUM(TaskStatus);
    explicit DownloadTask();
    DownloadTask(QObject *parent);
    DownloadTask(const QString &url,const QString &savePath,const QString &fileName);
    ~DownloadTask();
    Q_INVOKABLE void startDownload();
    Q_INVOKABLE void pauseDownload();
    Q_INVOKABLE void cancelDownload();

    TaskStatus status() const;
    void setStatus(TaskStatus newStatus);

    QString url() const;
    void setUrl(const QString &newUrl);

    QString fileName() const;
    void setFileName(const QString &newfileName);

    QString savePath() const;
    void setSavePath(const QString &newSavePath);


    double progressValue() const;
    void setProgressValue(double newProgressValue);

signals:
    // 下载成功信号
    void downloadRelay(const QString &filename, const QString& savePath);
    // 下载完成
    void downloadFinished();
    // 下载错误
    void downloadError(const QString &error, const QString &filename);

    void statusChanged(int);

    void urlChanged(QString);

    void fileNameChanged(QString);

    void savePathChanged(QString);

    void progressValueChanged(double);

public slots:
    void onDownloadReadyRead();
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onFinished();
private:

    QNetworkAccessManager *m_manger = nullptr;
    QNetworkReply *m_reply = nullptr;
    QFile m_file;
    QString m_url = "";
    QString m_fileName = "";
    QString m_savePath = "";
    double m_progressValue = 0;
    TaskStatus m_status = TaskStatus::Normal;
    int m_progressByte = 0;
    int m_bufferByte = 0;
    bool m_paused = true;

};


#endif // DOWNLOADTASK_H
