#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QDir>
#include <QFileInfo>
#include <QDirIterator>

extern const char *version;

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

signals:
    void selectedFileChanged();
    void validSelectedFile();
    void invalidSelectedFile();
    void currentPlayedVideoIndexChanged();
    void currentlyPlayedVideoChanged(QString videoPath);

public slots:
    void setSelectedFile(QUrl selectedFile); // used by qml
    void setSelectedFile(QString selectedFile);
    void validateSelectedFile();

    void goToNextVideo(); // used by qml
    void goToPrevVideo(); // used by qml

    void makePlaylist();
    void changeCurrentlyPlayedVideo();

private:
    bool isValidFileName(QString fileName, QChar &type) const;
    void setCurrentPlayedVideoIndex(int index);
    int getInitCurentPlayedVideoIndex() const;

    QString m_selectedFile;
    QChar m_selectedFileType;
    QString m_parentDirectory;

    QStringList m_playlist;

    int m_currentPlayedVideoIndex;
};

#endif // BACKEND_H
