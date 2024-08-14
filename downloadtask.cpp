#include "downloadtask.h"


DownloadTask::DownloadTask()
{

}

DownloadTask::DownloadTask(QObject * parent) : QObject(parent) {

}

DownloadTask::DownloadTask(const QString &url, const QString &savePath,const QString &fileName) :
    m_url(url) , m_savePath(savePath) , m_fileName(fileName)
{

}

DownloadTask::~DownloadTask() {
    if (m_reply) {
        m_reply->deleteLater();
    }
    if (m_manger) {
        m_manger->deleteLater();
    }

    qDebug() << " 已析构" ;
}

void DownloadTask::startDownload()
{
    qDebug() << "运行线程: "<< QThread::currentThreadId();
    if(m_status == TaskStatus::Loading) return;

    if(m_manger == nullptr) {
        m_manger = new QNetworkAccessManager(this);
    }

    // 设置状态
    setStatus(TaskStatus::Loading);
    m_paused = false;

    // 请求网络
    QNetworkRequest request;
    request.setUrl(QUrl(m_url));
    request.setRawHeader(QByteArray("Range"), QString("bytes=" + QString::number(m_bufferByte) + "-").toLocal8Bit());
    m_reply = m_manger->get(request);
    qDebug() << "音乐"+ m_fileName + "开始下载"  ;

    // 准备写入文件
    QString fullPath = m_savePath + "/" + m_fileName;
    // 检查目录是否存在，如果不存在则创建
    QFileInfo fileInfo(fullPath);
    QDir dir = fileInfo.absoluteDir();
    if (!dir.exists()) {
        dir.mkpath(".");
    }
    m_file.setFileName(fullPath);
    if (!m_file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        m_reply->abort();
        return;
    }

    // 连接下载完成信号
    connect(m_reply,&QNetworkReply::finished,this,&DownloadTask::onFinished,
            Qt::UniqueConnection);
    // 连接可有新数据获取时
    connect(m_reply,&QNetworkReply::readyRead,this,&DownloadTask::onDownloadReadyRead,
            Qt::UniqueConnection);
    // 连接下载进度信号
    connect(m_reply,&QNetworkReply::downloadProgress,this,&DownloadTask::onDownloadProgress,
            Qt::UniqueConnection);
}

void DownloadTask::pauseDownload()
{
    if(m_status != TaskStatus::Loading) return;
    m_paused = true;
    setStatus(TaskStatus::Paused);
    if(m_reply) {
        m_reply->abort();
    }
    qDebug() << "暂停下载音乐：" << m_fileName << " 已下载byte: " << m_progressByte + m_bufferByte;
}

void DownloadTask::cancelDownload()
{
    setStatus(TaskStatus::Cancel);
    if(m_reply) {
        m_reply->abort();
    }

    qDebug() << "取消下载音乐：" << m_fileName;
}

void DownloadTask::onDownloadReadyRead()
{
    QByteArray data = m_reply->readAll(); // 读取缓冲区数据
    m_progressByte += data.length(); // 更新下载的数据长度
    m_file.write(data); // 把新的缓冲数据读入文件
//    qDebug() << "本次下载的数据长度~" << data.length() << " 累计下载数据 " << m_progressByte+m_bufferByte <<
//        "总数据：";
}

void DownloadTask::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal)
{
    if (bytesTotal > 0) {
        double progress =  (double)(bytesReceived+m_bufferByte) / (bytesTotal+m_bufferByte) * 100;
        setProgressValue(progress);
    }
}
void DownloadTask::onFinished()
{
    m_file.close();

    auto noError_func = [&]() {
        qDebug() << "获取数据文件大小：" <<  m_reply->header(QNetworkRequest::ContentLengthHeader).toInt() + m_bufferByte;

        setStatus(TaskStatus::Ready);
        QString suffix = m_url.sliced(m_url.lastIndexOf('.',-1));
        QFileInfo fileInfo(m_file);
        fileInfo.suffix();
        QString newFileName = fileInfo.absoluteFilePath() + suffix;
        if(QFile::exists(m_file.fileName())) {
            if(m_file.rename(newFileName)) {

                qDebug() << "音乐: \n"+ m_fileName + "下载完成" + m_file.fileName() ;
                emit downloadRelay(m_fileName,"file:///" + m_file.fileName());

            } else {
                setStatus(TaskStatus::Error);
                m_file.remove();
                qDebug() << "音乐: \n"+ m_fileName + "写入失败"  ;
                emit downloadError("写入失败",m_fileName);
            }
        }
    };
    auto defaultError_func = [&]() {
        m_bufferByte += m_progressByte;
        setStatus(TaskStatus::Error);
//        m_progressByte = 0;
//        m_bufferByte = 0;
//        m_file.remove();
        qDebug() << "音乐: " << m_fileName + "下载失败" << m_reply->errorString() ;
        emit downloadError(m_reply->errorString(),m_fileName);
    };
    auto canceledError_func = [&]() {
        if(m_status == TaskStatus::Paused) {
            m_bufferByte += m_progressByte;
        }
        if(m_status == TaskStatus::Cancel) {
            m_progressByte = 0;
            m_bufferByte = 0;

            m_file.remove();
        }
    };
    switch(m_reply->error()) {
        case QNetworkReply::NoError:
            noError_func();
            break;
        case QNetworkReply::OperationCanceledError:
            canceledError_func();
            break;
        default:
            defaultError_func();
            break;
    }

    m_progressByte = 0;
    m_reply->deleteLater();
    m_reply = nullptr;

    // 发送下载成功信号
    emit downloadFinished();

}
double DownloadTask::progressValue() const
{
    return m_progressValue;
}

void DownloadTask::setProgressValue(double newProgressValue)
{
    if (qFuzzyCompare(m_progressValue, newProgressValue))
        return;
    m_progressValue = newProgressValue;
    emit progressValueChanged(m_progressValue);
}


DownloadTask::TaskStatus DownloadTask::status() const
{
    return m_status;
}

void DownloadTask::setStatus(TaskStatus newStatus)
{
    if (m_status == newStatus)
        return;
    m_status = newStatus;
    emit statusChanged(m_status);
}

QString DownloadTask::url() const
{
    return m_url;
}

void DownloadTask::setUrl(const QString &newUrl)
{
    if (m_url == newUrl)
        return;
    m_url = newUrl;
    emit urlChanged(m_url);
}

QString DownloadTask::fileName() const
{
    return m_fileName;
}

void DownloadTask::setFileName(const QString &newfileName)
{
    if (m_fileName == newfileName)
        return;
    m_fileName = newfileName;
    emit fileNameChanged(m_fileName);
}

QString DownloadTask::savePath() const
{
    return m_savePath;
}

void DownloadTask::setSavePath(const QString &newSavePath)
{
    if (m_savePath == newSavePath)
        return;
    m_savePath = newSavePath;
    emit savePathChanged(m_savePath);
}


