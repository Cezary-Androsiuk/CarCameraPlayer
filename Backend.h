#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QDebug>
#include <QUrl>
#include <QDir>
#include <QFileInfo>
#include <QDirIterator>

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

public slots:
    void setSelectedFile(QUrl selectedFile); // used by qml
    void setSelectedFile(QString selectedFile);
    void validateSelectedFile();

    void goToNextVideo(); // used by qml
    void goToPrevVideo(); // used by qml

    void makePlaylist();

private:
    bool isValidFileName(QString fileName, QChar &type) const;
    void setCurrentPlayedVideoIndex(int index);
    int initCurentPlayedVideoIndex() const;

    QString m_selectedFile;
    QChar m_selectedFileType;
    QString m_parentDirectory;

    QStringList m_playlist;

    int m_currentPlayedVideoIndex;
};

#endif // BACKEND_H
