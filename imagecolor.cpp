#include "imagecolor.h"

ImageColor::ImageColor()
{

}
ImageColor::ImageColor(const QImage &image)
{
    this->avgColor(image);
}
double ImageColor::colorDistance(const QColor &c1, const QColor &c2)
{
    int dr = c1.red() - c2.red();
    int dg = c1.green() - c2.green();
    int db = c1.blue() - c2.blue();
    return std::sqrt(dr * dr + dg * dg + db * db);
}

QString ImageColor::avgColor(const QImage &image)
{
    qDebug() << "图片宽高" << "w: " << image.width() << " h: "<< image.height();
    // 初始化颜色值的总和
    int totalRed = 0;
    int totalGreen = 0;
    int totalBlue = 0;
    int totalPixels = image.width() * image.height();

    // 遍历图片像素，累加颜色值
    for (int y = 0; y < image.height(); ++y) {
        for (int x = 0; x < image.width(); ++x) {
            QColor color(image.pixel(x, y));
            totalRed += color.red();
            totalGreen += color.green();
            totalBlue += color.blue();
        }
    }

    // 计算平均颜色
    int avgRed = totalRed / totalPixels;
    int avgGreen = totalGreen / totalPixels;
    int avgBlue = totalBlue / totalPixels;

    // 创建平均颜色的 QColor 对象
    QColor avgColor(avgRed, avgGreen, avgBlue);

    // 输出平均颜色
    qDebug() << "Average color: " << avgColor.name();
    return avgColor.name();
}

// 选择初始聚类中心的 K-means++ 算法
QVector<QColor> ImageColor::kmeans_plusplus(const QImage& image, int k) {
    QVector<QColor> centroids;

    if (image.width() <= 0) return centroids;

    // 选择第一个聚类中心
    int x = QRandomGenerator::global()->bounded(image.width());
    int y = QRandomGenerator::global()->bounded(image.height());
    centroids.append(image.pixelColor(x, y));

    // 选择剩余的聚类中心
    for (int i = 1; i < k; ++i) {
        QVector<double> minDistances(image.width() * image.height(), std::numeric_limits<double>::max());
        double totalDist = 0.0;

        for (int y = 0; y < image.height(); ++y) {
            for (int x = 0; x < image.width(); ++x) {
                QColor pixel = image.pixelColor(x, y);
                for (int j = 0; j < centroids.size(); ++j) {
                    double d = colorDistance(pixel, centroids[j]);
                    minDistances[y * image.width() + x] = std::min(minDistances[y * image.width() + x], d);
                }
                totalDist += minDistances[y * image.width() + x];
            }
        }

        double randVal = QRandomGenerator::global()->bounded(totalDist);
        double sum = 0.0;
        x = 0;
        y = 0;
        for (y = 0; y < image.height(); ++y) {
            for (x = 0; x < image.width(); ++x) {
                sum += minDistances[y * image.width() + x];
                if (sum >= randVal) {
                    break;
                }
            }
            if (sum >= randVal) {
                break;
            }
        }

        centroids.append(image.pixelColor(x, y));
    }

    return centroids;
}

QVector<QColor> ImageColor::getMainColors(const QImage &image)
{
    qDebug() << "图片宽高" << "w: " << image.width() << " h: "<< image.height();

    QVector<QColor> centroids(kmeans_plusplus(image,this->k));
    QVector<int> centroidsCnt(this->k);
    if(image.width() <= 0) return centroids;


    // 迭代更新聚类中心
    for (int iter = 0; iter < this->maxIterations; ++iter) {
        // 每个聚类中心的像素颜色
        QVector<QVector<QColor>> newCentroids(this->k);
        // 每个聚类中心的像素数量
        QVector<int> clusterSizes(this->k, 0);

        // 分配像素到最近的聚类中心
        for (int y = 0; y < image.height(); ++y) {
            for (int x = 0; x < image.width(); ++x) {
                QColor pixel = image.pixelColor(x, y); // 获取当前像素的颜色值
                int closestCentroid = 0; // 初始化当前像素所属的最近聚类中心索引为0
                double minDistance = m_minDistance; // 初始化默认最小距离
                for (int i = 1; i < this->k; ++i) { // 遍历剩余的聚类中心
                    double distance = colorDistance(pixel, centroids[i]); // 计算当前像素与第i个聚类中心的颜色距离
                    if (distance < minDistance) { // 判断是否找到更近的聚类中心
                        minDistance = distance; // 更新最小距离
                        closestCentroid = i; // 更新最近聚类中心索引
                    }
                }
                newCentroids[closestCentroid].append(pixel); // 将当前像素添加到最近聚类中心的集合中
                clusterSizes[closestCentroid]++; // 增加最近聚类中心的像素数量
            }
        }

        // 更新聚类中心
        for (int i = 0; i < this->k; ++i) {
            if (clusterSizes[i] > 0) {
                // 计算每个簇中像素的均值，更新聚类中心为新的均值颜色
                int r = 0, g = 0, b = 0;
                for (const QColor &color : newCentroids[i]) {
                    r += color.red();
                    g += color.green();
                    b += color.blue();
                }
                r /= clusterSizes[i];
                g /= clusterSizes[i];
                b /= clusterSizes[i];
                QColor newCentroid(r, g, b);
                centroids[i] = newCentroid;
            }
            centroidsCnt[i] += clusterSizes[i];
        }
    }
    // 输出主要构成颜色信息
//    for (int i = 0; i < centroids.size(); ++i) {
//        float light = centroids[i].lightnessF();
//        qDebug() << "Main Color " << centroids[i].name() + " light: " + QString::number(light) << "count: " << centroidsCnt[i];
//    }
    std::sort(centroids.begin(),centroids.end(),[&](QColor a,QColor b) {
        return a.lightnessF() < b.lightnessF();
    });


    return centroids;

}
