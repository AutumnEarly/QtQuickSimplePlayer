#include "downloadtaskthread.h"

Downloadtaskthread::Downloadtaskthread()
{

}

Downloadtaskthread::Downloadtaskthread(const QString &url, const QString &savePath,const QString &fileName)
{
    m_url = url;
    m_fileName = fileName;
    m_downloadTask = new DownloadTask(url,savePath,fileName);
    connect(m_downloadTask,&DownloadTask::statusChanged,this,&Downloadtaskthread::setStatus);
    connect(m_downloadTask,&DownloadTask::progressValueChanged,this,&Downloadtaskthread::setProgressValue);
    connect(m_downloadTask,&DownloadTask::downloadRelay,this,&Downloadtaskthread::downloadRelay);
    connect(m_downloadTask,&DownloadTask::downloadError,this,&Downloadtaskthread::downloadError);
}

Downloadtaskthread::~Downloadtaskthread()
{
    // 内存清理
    if(m_downloadTask) {
        if(m_downloadTask->status() == DownloadTask::TaskStatus::Loading) {
            m_downloadTask->pauseDownload();
        }
        m_downloadTask->deleteLater();
    }
    if(m_thread) {
        if(m_thread->isRunning()) {
            m_thread->quit();
            m_thread->wait();
        }
        m_thread->deleteLater();
    }
}

int Downloadtaskthread::status() const
{
    return m_status;
}

void Downloadtaskthread::setStatus(int newStatus)
{
    if (m_status == newStatus)
        return;
    m_status = newStatus;
    emit statusChanged(m_status);
}

QString Downloadtaskthread::savePath() const
{
    return m_savePath;
}

void Downloadtaskthread::setSavePath(const QString &newSavePath)
{
    if (m_savePath == newSavePath)
        return;
    m_savePath = newSavePath;
    emit savePathChanged();
}


void Downloadtaskthread::start()
{
    std::unique_lock<std::mutex> locker(m_mutex);

    if(m_thread == nullptr) {
        m_thread = new QThread();
    }
    qDebug() << "启动" << m_thread->thread() << " 启动线程: " << QThread::currentThread();

        if(m_thread != m_downloadTask->thread()) {
        m_downloadTask->moveToThread(m_thread);
        connect(m_thread,&QThread::started,m_downloadTask,&DownloadTask::startDownload);
        connect(m_downloadTask,&DownloadTask::downloadFinished,m_thread,[=]() {
            qDebug() << "已退出线程: "<< QThread::currentThread();
            m_thread->quit();
            m_thread->wait();
//            m_downloadTask->moveToThread(this->thread());
        });
    }
    m_thread->start();
}

void Downloadtaskthread::pause()
{
    std::lock_guard<std::mutex> locker(m_mutex);
    if(m_thread->isRunning()) {
        m_downloadTask->pauseDownload();
    }
}

double Downloadtaskthread::getProgressValue() const
{
    return m_progressValue;
}

void Downloadtaskthread::setProgressValue(double newProgressValue)
{
    if (qFuzzyCompare(m_progressValue, newProgressValue))
        return;
    m_progressValue = newProgressValue;
    emit progressValueChanged(m_progressValue);
}

QString Downloadtaskthread::getFileName() const
{
    return m_fileName;
}

void Downloadtaskthread::setFileName(const QString &newFileName)
{
    if (m_fileName == newFileName)
        return;
    m_fileName = newFileName;
    emit fileNameChanged(m_fileName);
}
