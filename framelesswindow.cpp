#include "framelesswindow.h"

FramelessWindow::FramelessWindow(QWindow * parent) : QQuickWindow(parent)
{

    this->setFlags(Qt::Window | Qt::FramelessWindowHint | Qt::WindowMinMaxButtonsHint);
    this->setColor(Qt::transparent);
    this->show();
}

void FramelessWindow::mousePressEvent(QMouseEvent *event)
{
    this->start_pos = event->globalPosition();
    this->old_pos = this->position();
    this->old_size = this->size();
    event->ignore();

    QQuickWindow::mousePressEvent(event);
}

void FramelessWindow::mouseReleaseEvent(QMouseEvent *event)
{
    this->old_pos = this->position();
    QQuickWindow::mouseReleaseEvent(event);
}

void FramelessWindow::mouseMoveEvent(QMouseEvent *event)
{
    QPointF pos = event->position();
    if(event->buttons() & Qt::LeftButton) {
        // 改变大小
        this->setWindowGeometry(event->globalPosition());
        if(pos.y() <= 80) {
//            this->setPosition((this->old_pos - this->start_pos + event->globalPosition()).toPoint());
        }

    } else {
        this->mouse_pos = this->getMousePos(pos);
        this->setCursorIcon();
    }
    QQuickWindow::mouseMoveEvent(event);
}

void FramelessWindow::setWindowGeometry(const QPointF &pos)
{
    QPointF offset = this->start_pos - pos;
    if(offset.x() == 0 && offset.y() == 0) return;
    static auto set_geometry_func = [this](const QSize & size,const QPointF &pos) {
        QPointF t_pos = this->old_pos;
        QSize t_size = minimumSize();
        if(size.width() > minimumWidth()) {
            t_pos.setX(pos.x());
            t_size.setWidth(size.width());
        } else if(this->mouse_pos == LEFT) {
            t_pos.setX(this->old_pos.x()+this->old_size.width()-minimumWidth());
        }
        if(size.height() > minimumHeight()) {
            t_pos.setY(pos.y());
            t_size.setHeight(size.height());
        } else if(this->mouse_pos == TOP) {
            t_pos.setY(this->old_pos.y()+this->old_size.height()-minimumHeight());
        }
        this->setGeometry(t_pos.x(),t_pos.y(),t_size.width(),t_size.height());
        this->update();
    };

    switch (this->mouse_pos) {
    case TOPLEFT: set_geometry_func(this->old_size + QSize(offset.x(),offset.y()),
                          this->old_pos - offset);
        break;
    case TOP: set_geometry_func(this->old_size + QSize(0,offset.y()),
                          this->old_pos - QPointF(0,offset.y()));
        break;
    case TOPRIGHT: set_geometry_func(this->old_size - QSize(offset.x(),-offset.y()),
                          this->old_pos - QPointF(0,offset.y()));
        break;
    case LEFT: set_geometry_func(this->old_size + QSize(offset.x(),0),
                          this->old_pos - QPointF(offset.x(),0));
        break;
    case RIGHT: set_geometry_func(this->old_size - QSize(offset.x(),0),
                          this->position());
        break;
    case BOTTOMLEFT: set_geometry_func(this->old_size + QSize(offset.x(),-offset.y()),
                          this->old_pos - QPointF(offset.x(),0));
        break;
    case BOTTOM: set_geometry_func(this->old_size + QSize(0,-offset.y()),
                          this->position());
        break;
    case BOTTOMRIGHT: set_geometry_func(this->old_size - QSize(offset.x(),offset.y()),
                          this->position());
        break;
    default:
        break;
    }

}

void FramelessWindow::setCursorIcon()
{
    static bool isSet = false;
    switch (this->mouse_pos) {
    case TOPLEFT:
    case BOTTOMRIGHT:
        this->setCursor(Qt::SizeFDiagCursor);
        isSet = true;
        break;
    case TOP:
    case BOTTOM:
        this->setCursor(Qt::SizeVerCursor);
        isSet = true;
        break;
    case TOPRIGHT:
    case BOTTOMLEFT:
        this->setCursor(Qt::SizeBDiagCursor);
        isSet = true;
        break;
    case LEFT:
    case RIGHT:
        this->setCursor(Qt::SizeHorCursor);
        isSet = true;
        break;
    default:
        if(isSet) {
            isSet = false;
            this->unsetCursor();
        }
        break;
    }
}

FramelessWindow::MousePosition FramelessWindow::getMousePos(const QPointF &pos)
{
    int x = pos.x();
    int y = pos.y();
    int w = this->width();
    int h = this->height();

    MousePosition mouse_pos = NORMAL;

    if(x >= 0 && x <= this->step && y >= 0 && y <= this->step) {
        mouse_pos = TOPLEFT;
    } else if(x > this->step && x < (w - this->step) && y >= 0 && y <= this->step) {
        mouse_pos = TOP;
    } else if(x >= (w - this->step) && x <= w && y >= 0 && y <= this->step) {
        mouse_pos = TOPRIGHT;
    } else if(x >= 0 && x <= this->step &&  y > this->step && y < (h - this->step)) {
        mouse_pos = LEFT;
    } else if(x >= (w - this->step) && x <= w &&  y > this->step && y < (h - this->step)) {
        mouse_pos = RIGHT;
    } else if(x >= 0 && x <= this->step &&  y >= (h - this->step) && y < h) {
        mouse_pos = BOTTOMLEFT;
    } else if(x > this->step && x < (w - this->step) && y >= (h - this->step) && y <= h) {
        mouse_pos = BOTTOM;
    } else if(x >= (w - this->step) && x <= w && y >= (h - this->step) && y <= h) {
        mouse_pos = BOTTOMRIGHT;
    }
    return mouse_pos;

}

FramelessWindow::MousePosition FramelessWindow::getMouse_pos() const
{
    return mouse_pos;
}

void FramelessWindow::setMouse_pos(MousePosition newMouse_pos)
{
    if (mouse_pos == newMouse_pos)
        return;
    mouse_pos = newMouse_pos;
    emit mouse_posChanged();
}
