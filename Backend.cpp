#include "Backend.h"

Backend::Backend(QObject *parent)
    : QObject{parent},
    m_selectedFile(""),
    m_currentPlayedVideoIndex(-1)
{
    QObject::connect(this, &Backend::selectedFileChanged, this, &Backend::validateSelectedFile);
    // QObject::connect(this, &Backend::invalidSelectedFile, this, );
    QObject::connect(this, &Backend::validSelectedFile, this, &Backend::makePlaylist);
    // QObject::connect(this, &Backend::validSelectedFile, this, &Backend::makeRelatedFile);

}

void Backend::setSelectedFile(QUrl selectedFile)
{
    qDebug() << "selected url in cpp:" << selectedFile;
    this->setSelectedFile(selectedFile.toLocalFile());
}

void Backend::setSelectedFile(QString selectedFile)
{
    if(selectedFile == m_selectedFile)
        return;

    qDebug() << "selected file in cpp:" << selectedFile;
    m_selectedFile = selectedFile;
    emit this->selectedFileChanged();
}

void Backend::validateSelectedFile()
{
    QChar type;
    QFileInfo fileInfo(m_selectedFile);
    if(!this->isValidFileName(fileInfo.fileName(), type))
    {
        qDebug() << "selected file" << fileInfo.fileName() << "is not valid";
        emit this->invalidSelectedFile();
        return;
    }

    m_selectedFileType = type; /// handled in isValidFileName (B or F)
    qDebug() << "m_selectedFileType" << m_selectedFileType;

    QDir parentDir = m_selectedFile;
    parentDir.cdUp();
    m_parentDirectory = parentDir.path();
    qDebug() << "m_parentDirectory" << m_parentDirectory;
    if(!parentDir.exists())
    {
        qDebug() << "directory"<<m_parentDirectory<<"not exist";
        exit(1);
    }

    qDebug() << "selected file" << m_selectedFile << "is valid";
    emit this->validSelectedFile();
}

void Backend::makePlaylist()
{
    QDirIterator dirIt(m_parentDirectory, QDir::NoDotAndDotDot | QDir::Files);
    QStringList playlist;
    while(dirIt.hasNext())
    {
        QString file = dirIt.next();
        QString fileName = QFileInfo(file).fileName();
        QChar type;
        if(!this->isValidFileName(fileName, type))
        {
            qDebug() << "in" << m_parentDirectory << "skip file:" << file;
            continue;
        }

        if(m_selectedFileType != type)
        {
            qDebug() << "in" << m_parentDirectory << "skip file:" << file << "due not equal type";
            continue;
        }

        // qDebug() << "added" << file;
        playlist.append(file);
    }
    // qDebug() << "playlist:" << playlist;
    m_playlist = playlist;


    /// set current Index
    m_currentPlayedVideoIndex = -1;
    for(const auto &file : m_playlist)
    {
        ++ m_currentPlayedVideoIndex;

        if(file == m_selectedFile)
        {
            break;
        }
    }
    qDebug() << "index" << m_currentPlayedVideoIndex;
    if(m_currentPlayedVideoIndex == -1)
    {
        qWarning() << "file" << m_selectedFile << "was not found in playlist" << m_playlist;
    }

}

bool Backend::isValidFileName(QString fileName, QChar &type) const
{
    type = '\0';

    if(fileName.size() < 7)
    {
        qDebug() << fileName << "has to short name";
        return false;
    }
    QString firstTwo = fileName.left(2);
    if(firstTwo != "EV")
    {
        qDebug() << fileName << "has invalid begin";
        return false;
    }
    QString lastFive = fileName.right(4);
    if(lastFive.toLower() != ".mp4")
    {
        qDebug() << fileName << "has invalid end";
        return false;
    }
    QChar localType = fileName.at(fileName.size() -5);
    if(localType != 'B' && localType != 'F')
    {
        qDebug() << fileName << "has invalid type";
        return false;
    }

    type = localType;
    return true;
}
