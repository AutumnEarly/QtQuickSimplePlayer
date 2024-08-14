#include "desktoplyric.h"
#include <QBitmap>
#include <QPainter>

DesktopLyric::DesktopLyric(QQuickWindow * parent) : QQuickWindow(parent)
{

    this->setFlags(Qt::WindowStaysOnTopHint | Qt::FramelessWindowHint);
    this->setColor(Qt::transparent);
    this->show();
}

void DesktopLyric::setFillMask(const int x,const int y,const int w,const int h)
{
//    qDebug() << "x: " << x << " y: " << y << " w: " <<w  << " h: " <<h;
    QBitmap bitmap(this->width(),this->height());
    QPainter painter(&bitmap);
    painter.setBrush(Qt::color0);
    painter.drawRect(0, 0, this->width(), this->height());
    painter.setBrush(Qt::color1); // 设置中间区域为不透明
    painter.drawRect(x, y, w, h);
    painter.end();

    this->setMask(bitmap);
}


void DesktopLyric::setFillMask(const QJsonValue &o)
{

    QBitmap bitmap(this->width(),this->height());
    QPainter painter(&bitmap);
    painter.setBrush(Qt::color0);
    painter.drawRect(0, 0, this->width(), this->height());

    QJsonArray jsonArr = o.toArray();
    if(jsonArr.isEmpty()) {
//        qDebug() << "x: " << o["x"].toDouble() << " y: " << o["y"].toDouble() << " w: " <<o["w"].toDouble()  << " h: " <<o["h"].toDouble();
        painter.setBrush(Qt::color1);
        painter.drawRect(o["x"].toDouble(), o["y"].toDouble(), o["w"].toDouble(), o["h"].toDouble());
    } else {
        for(int i = 0; i < jsonArr.count();i++ ) {
            QJsonObject obj = jsonArr[i].toObject();
            painter.setBrush(Qt::color1);
            painter.drawRect(obj["x"].toDouble(), obj["y"].toDouble(), obj["w"].toDouble(), obj["h"].toDouble());
//            qDebug() << "cnt: " << i << " x: " << obj["x"].toDouble() << " y: " << obj["y"].toDouble() << " w: " <<obj["w"].toDouble()  << " h: " <<obj["h"].toDouble();
        }
    }
    painter.end();
    this->setMask(bitmap);
}

void DesktopLyric::mousePressEvent(QMouseEvent *event)
{
    this->m_startPos = event->globalPosition().toPoint();
    this->m_oldPos = position();
    event->ignore();

    QQuickWindow::mousePressEvent(event);
}

void DesktopLyric::mouseReleaseEvent(QMouseEvent *event)
{
    this->m_oldPos = this->position();

    QQuickWindow::mouseReleaseEvent(event);
}

void DesktopLyric::mouseMoveEvent(QMouseEvent *event)
{
    if (event->buttons() & Qt::LeftButton) {
        this->setPosition(this->m_oldPos - this->m_startPos + event->globalPosition().toPoint());
    }

    QQuickWindow::mouseMoveEvent(event);
}
