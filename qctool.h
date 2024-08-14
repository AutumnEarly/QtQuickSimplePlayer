#ifndef QCTOOL_H
#define QCTOOL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJSValue>
#include <QJsonArray>

#include <QFile>
#include <QDir>

class QCTool : public QObject
{
    Q_OBJECT
public:
    explicit QCTool();
    Q_INVOKABLE void writeFile(const QString &filePath, const QString &jsonData);
    Q_INVOKABLE QString readFile(const QString &filePath);
};

#endif // QCTOOL_H
