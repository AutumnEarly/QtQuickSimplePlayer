#include "musicdownload.h"



MusicDownload::MusicDownload(QObject * parent) : QObject(parent)
{
    m_data = readFile(m_savePath);
    connect(this,&MusicDownload::dataValueChanged,this,&MusicDownload::onDataValueChanged);
}

MusicDownload::~MusicDownload()
{
    for(const auto taskInfo : m_downloadInfos.values()) {
        if(taskInfo) {
            taskInfo->deleteLater();
        }
    }
    qDebug() << " 已析构" ;
}
void MusicDownload::startDownload(const QString &taskId,const QJsonObject & obj) {
    if(m_downloadInfos.find(taskId) == m_downloadInfos.end()) {
        qDebug() << "无此任务！";
        return;
    }

    connect(m_downloadInfos[taskId],&Downloadtaskthread::downloadRelay,this,[this,obj,taskId](const QString& fileName,const QString & savePath) {
        if(this->loaclIndexOf(QString::number( obj["id"].toInteger())) >= 0) return;
        QJsonObject o(obj);
        o["url"] = savePath;
        this->m_data.insert(0,o);
        this->m_taskCount++;
        this->moveTask(taskId);
        emit dataValueChanged();
    });
    m_downloadInfos[taskId]->start();
}

void MusicDownload::pauseDownload(const QString& taskId)
{
    if(m_downloadInfos.find(taskId) == m_downloadInfos.end()) return;

    m_downloadInfos[taskId]->pause();
}

void MusicDownload::cancelDownload(const QString& taskId)
{
    moveTask(taskId);
}

void MusicDownload::addTask(const QString &url, const QString &fileName,const QString & taskId)
{
    std::lock_guard<std::mutex> locker(m_mutex);
    if(m_downloadInfos.find(taskId) != m_downloadInfos.end()) return;

    m_downloadInfos.insert(taskId,new Downloadtaskthread(url,m_downloadSavePath,fileName));
    setCount(m_downloadInfos.count());
    qDebug() << "已添加任务！" << "当前任务数: " << m_count;
}

void MusicDownload::moveTask(const QString& taskId)
{
    std::lock_guard<std::mutex> locker(m_mutex);
    if(m_downloadInfos.find(taskId) == m_downloadInfos.end()) return;

    DownloadTask dt = m_downloadInfos.take(taskId);
    dt.deleteLater();
    setCount(m_downloadInfos.count());
}

int MusicDownload::loaclIndexOf(const QString &findId)
{
    for(int i = 0; i < m_data.count();i++) {
        QString id = QString::number(m_data.at(i).toObject()["id"].toInteger());
        if(id == findId) {
            return i;
        }
    }
    return -1;
}

void MusicDownload::addLocalMusic(const QJsonValue& obj)
{
    QJsonArray jsonArr = obj.toArray();
    if(!jsonArr.isEmpty()) {
        int len = jsonArr.count();
        bool isChanged = false;
        for(int i = 0; i < len;i++) {
            if(loaclIndexOf(obj.toString()) >= 0) continue;
            m_data.insert(0,jsonArr[len - i - 1]);
            isChanged = true;
        }
        if(isChanged) {
            writeFile(m_savePath,m_data);
            emit dataValueChanged();
        }
    } else {
        if(loaclIndexOf(obj.toString()) >= 0) return;
        m_data.insert(0,obj);
        writeFile(m_savePath,m_data);
        emit dataValueChanged();
    }
}
void MusicDownload::writeFile(const QString &filePath, const QJsonArray &obj)
{
    QJsonDocument jsonDoc(obj);
    QFileInfo fileInfo(filePath);
    QDir dir = fileInfo.absoluteDir();
    if(!dir.exists()) {
        dir.mkpath(".");
    }
    QFile file(filePath);
    if(!file.open(QIODevice::WriteOnly)) {
        qDebug() << "写入失败";
        return;
    }
    file.write(jsonDoc.toJson());
    file.close();
    qDebug() << "文件保存地址: "<< fileInfo.absoluteFilePath();
}

QJsonArray MusicDownload::readFile(const QString &filePath)
{
    QJsonArray obj;
    QFile file(filePath);
    if(!file.open(QIODevice::ReadOnly)) {
        qDebug() << "文件打开失败";
        return obj;
    }
    QByteArray data(file.readAll());
    file.close();

    QJsonParseError error;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(data,&error);
    if (error.error == QJsonParseError::NoError && jsonDoc.isObject()) {
        qDebug() << "C++ json转换数据失败!";
        return obj;
    } else {
        qDebug() << "C++ json转换数据成功!";
        return jsonDoc.array();
    }

}

QJsonArray MusicDownload::data() const
{
    return m_data;
}

void MusicDownload::setData(const QJsonArray &newData)
{
    if (m_data == newData)
        return;
    m_data = newData;
    emit dataChanged();
}

void MusicDownload::onDataValueChanged()
{
    QJsonDocument jsonDoc(m_data);
    QFileInfo fileInfo(m_savePath);
    QDir dir = fileInfo.absoluteDir();
    if(!dir.exists()) {
        dir.mkpath(".");
    }
    QFile file(m_savePath);
    if(!file.open(QIODevice::WriteOnly)) {
        qDebug() << "写入失败";
        return;
    }
    file.write(jsonDoc.toJson());
    file.close();
}


int MusicDownload::getCount() const
{
    return m_count;
}

void MusicDownload::setCount(int newCount)
{
    if (m_count == newCount)
        return;
    m_count = newCount;
    emit countChanged();
}

QMap<QString,Downloadtaskthread*> MusicDownload::downloadInfos() const
{
    return m_downloadInfos;
}

void MusicDownload::setDownloadInfos(const QMap<QString,Downloadtaskthread*> &newDownloadInfos)
{
    if (m_downloadInfos == newDownloadInfos)
        return;
    m_downloadInfos = newDownloadInfos;
    emit downloadInfosChanged();
}

QString MusicDownload::downloadSavePath() const
{
    return m_downloadSavePath;
}

void MusicDownload::setDownloadSavePath(const QString &newDownloadSavePath)
{
    if (m_downloadSavePath == newDownloadSavePath)
        return;
    m_downloadSavePath = newDownloadSavePath;
    emit downloadSavePathChanged();
}


