#ifndef IMAGECOLOR_H
#define IMAGECOLOR_H

#include <QObject>
#include <QImage>
#include <QColor>
#include <QVector>
#include <QRandomGenerator>
#include <cmath>
#include <QDebug>

class ImageColor : public QObject
{
    Q_OBJECT
public:
    ImageColor();
    ImageColor(const QImage &image);

    // 获取平均色
    Q_INVOKABLE QString avgColor(const QImage &image);
    // K-means++算法
    Q_INVOKABLE QVector<QColor> getMainColors(const QImage &image);
    // 定义最小距离
    double m_minDistance = 15;
    // 定义聚类中心的数量
    const int k = 5;
    // 定义最大迭代次数
    const int maxIterations = 5;

private:
    // 计算两个颜色之间的距离（欧氏距离）
    double colorDistance(const QColor &c1, const QColor &c2);
    QVector<QColor> kmeans_plusplus(const QImage& image, int k);
};

#endif // IMAGECOLOR_H
