#ifndef DOWNLOADTASKTHREAD_H
#define DOWNLOADTASKTHREAD_H

#include <QObject>
#include "downloadtask.h"

class Downloadtaskthread : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString fileName READ getFileName WRITE setFileName NOTIFY fileNameChanged FINAL)
    Q_PROPERTY(double progressValue READ getProgressValue NOTIFY progressValueChanged FINAL)
    Q_PROPERTY(int status READ status  NOTIFY statusChanged FINAL)
    Q_PROPERTY(QString savePath READ savePath WRITE setSavePath NOTIFY savePathChanged FINAL)

public:
    Downloadtaskthread();
    Downloadtaskthread(const QString &url, const QString &savePath,const QString &fileName );
    ~Downloadtaskthread();
    void start();
    void pause();
    void cancel();
    void setMusicInfo(const QString &source,const QString &name,const QString &artist,const QString &album);
    double getProgressValue() const;
    void setProgressValue(double newProgressValue);

    QString getFileName() const;
    void setFileName(const QString &newFileName);

    int status() const;
    void setStatus(int newStatus);

    QString savePath() const;
    void setSavePath(const QString &newSavePath);

signals:

    // 下载写入成功信号
    void downloadRelay(const QString &filename, const QString& savePath);

    void downloadError(const QString &error, const QString &filename);

    void nameChanged();
    void progressValueChanged(double progress);

    void fileNameChanged(const QString& fileName );

    void statusChanged(int status);

    void savePathChanged();

    void artistsChanged();

    void albumChanged();

private:
    DownloadTask *m_downloadTask = nullptr;
    std::mutex m_mutex;
    QThread *m_thread = nullptr;
    QString m_url = "";
    QString m_savePath = "";
    QString m_fileName = "";
    int m_status = 0;
    double m_progressValue = 0;


};


#endif // DOWNLOADTASKTHREAD_H
