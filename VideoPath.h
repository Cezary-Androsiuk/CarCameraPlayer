#ifndef VIDEOPATH_H
#define VIDEOPATH_H

#include <QObject>
#include <QDebug>
#include <QFileInfo>
#include <QDir>

class VideoPath : public QObject
{
    Q_OBJECT
public:
    explicit VideoPath(QObject *parent = nullptr);

signals:

public slots:
    void addVideoFile(QString videoFile);

private:
    QString findBackInFile();
    QString findBackOutFile();
    QString findFrontInFile();
    QString findFrontOutFile();

private:
    QString m_frontVideoFile;
    QString m_backVideoFile;

};

#endif // VIDEOPATH_H
