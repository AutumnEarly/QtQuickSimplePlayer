#ifndef DESKTOPLYRIC_H
#define DESKTOPLYRIC_H

#include <QObject>
#include <QQuickView>
#include <QQuickWindow>
#include <QJsonObject>
#include <QJsonArray>
#include <QPixmap>
#include <QImage>
class DesktopLyric : public QQuickWindow
{
    Q_OBJECT
public:
    DesktopLyric(QQuickWindow *parent = nullptr);

    Q_INVOKABLE void setFillMask(const int x,const int y,const int w,const int h);
    Q_INVOKABLE void setFillMask(const QJsonValue &o);
protected:
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
private:
    QPoint m_oldPos;
    QPoint m_startPos;
};

#endif // DESKTOPLYRIC_H
