#ifndef VIDEOPATH_H
#define VIDEOPATH_H

#include <QObject>
#include <QDebug>
#include <QFileInfo>
#include <QDir>

class VideoPath : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString backVideoFile READ getBackVideoFile NOTIFY backVideoFileChanged FINAL)
    Q_PROPERTY(QString frontVideoFile READ getFrontVideoFile NOTIFY frontVideoFileChanged FINAL)

public:
    explicit VideoPath(QObject *parent = nullptr);

    QString getFrontVideoFile() const;
    QString getBackVideoFile() const;

signals:
    void frontVideoFileChanged();
    void backVideoFileChanged();

public slots:
    void setVideoFile(QString videoFile);

private:
    void buildAlternativeFilePath(QString videoFile);

    QString findBackInFile() const;   /// looking for the back file in the front file location        // ./backFile
    QString findBackOutFile() const;  /// looking for the back file outside the front file location   // ./../Back/backFile
    QString findFrontInFile() const;  /// looking for the front file in the back file location        // ./frontFile
    QString findFrontOutFile() const; /// looking for the front file outside the back file location   // ./../Front/frontFile

    void setFrontVideoFile(QString frontVideoFile);
    void setBackVideoFile(QString backVideoFile);

private:
    QString m_frontVideoFile;
    QString m_backVideoFile;

};

#endif // VIDEOPATH_H
