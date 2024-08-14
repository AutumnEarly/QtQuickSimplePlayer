#include "qctool.h"

QCTool::QCTool()
{

}
void QCTool::writeFile(const QString &filePath, const QString &obj)
{

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

    QJsonParseError error;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(obj.toUtf8(),&error);
    if (error.error == QJsonParseError::NoError) {
        file.write(jsonDoc.toJson());
        file.close();
    }

//    qDebug() << "文件保存地址: "<< fileInfo.absoluteFilePath();
}

QString QCTool::readFile(const QString &filePath)
{
    QString obj;
    QFile file(filePath);
    if(!file.open(QIODevice::ReadOnly)) {
        qDebug() << "文件打开失败";
        return obj;
    }
    QByteArray data(file.readAll());
    file.close();

    return QString(data);

}

