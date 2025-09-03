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
    Q_PROPERTY(bool alternativeFileFound READ getAlternativeFileFound NOTIFY alternativeFileFoundChanged FINAL)

public:
    explicit VideoPath(QObject *parent = nullptr);

    QString getFrontVideoFile() const;
    QString getBackVideoFile() const;
    bool getAlternativeFileFound() const;

signals:
    void frontVideoFileChanged();
    void backVideoFileChanged();
    void alternativeFileFoundChanged();

public slots:
    void setVideoFile(QString videoFile);

private:
    void buildAlternativeFilePath(QString videoFile);
    QString findBack() const;
    QString findFront() const;

    QString findBackInCurrentDir() const;   /// looking for the "back" file in the "front" file location        // ./backFile
    QString findBackInParentDir() const;    /// looking for the "back" file outside the "front" file location   // ./../Back/backFile
    QString findFrontInCurrentDir() const;  /// looking for the "front" file in the "back" file location        // ./frontFile
    QString findFrontInParentDir() const;   /// looking for the "front" file outside the "back" file location   // ./../Front/frontFile

    void setFrontVideoFile(QString frontVideoFile);
    void setBackVideoFile(QString backVideoFile);
    void setAlternativeFileFound(bool alternativeFileFound);

private:
    QString m_frontVideoFile;
    QString m_backVideoFile;
    bool m_alternativeFileFound;

};

#endif // VIDEOPATH_H
