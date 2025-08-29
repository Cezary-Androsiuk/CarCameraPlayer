#include "Backend.h"

const char *version = "v1.4.0";

Backend::Backend(QObject *parent)
    : QObject{parent},
    m_selectedFile(""),
    m_currentPlayedVideoIndex(-1)
{
    QObject::connect(this, &Backend::selectedFileChanged, this, &Backend::validateSelectedFile);
    QObject::connect(this, &Backend::validSelectedFile, this, &Backend::makePlaylist);
    QObject::connect(this, &Backend::currentPlayedVideoIndexChanged, this, &Backend::changeCurrentlyPlayedVideo);

}

void Backend::setSelectedFile(QUrl selectedFile)
{
    this->setSelectedFile(selectedFile.toLocalFile());
}

void Backend::setSelectedFile(QString selectedFile)
{
    if(selectedFile == m_selectedFile)
        return;

    qDebug() << "selected file:" << selectedFile;
    m_selectedFile = selectedFile;
    emit this->selectedFileChanged();
}

void Backend::validateSelectedFile()
{
    QChar type;
    QFileInfo fileInfo(m_selectedFile);
    QString invalidFileReason;
    if(!this->isValidFileName(fileInfo.fileName(), type, invalidFileReason))
    {
        qDebug() << "selected file" << fileInfo.fileName() << "is not valid\n" "reason:" << invalidFileReason << "\n";
        emit this->invalidSelectedFile(invalidFileReason);
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
        invalidFileReason = "parent directory not exist";
        qDebug() << "directory"<<m_parentDirectory<<"not exist";
        emit this->invalidSelectedFile(invalidFileReason);
        return;
    }

    qDebug() << "selected file" << m_selectedFile << "is valid";
    emit this->validSelectedFile();
}

void Backend::goToNextVideo()
{
    int cpvi = m_currentPlayedVideoIndex;

    if(cpvi >= m_playlist.size()-1)
        cpvi = 0;
    else
        ++ cpvi;

    this->setCurrentPlayedVideoIndex(cpvi);
}

void Backend::goToPrevVideo()
{
    int cpvi = m_currentPlayedVideoIndex;

    if(cpvi <= 0)
        cpvi = m_playlist.size()-1;
    else
        -- cpvi;

    this->setCurrentPlayedVideoIndex(cpvi);
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
        QString invalidFileReason;
        if(!this->isValidFileName(fileName, type, invalidFileReason))
        {
            qDebug() << "in" << m_parentDirectory << "skip file:" << file << "\n""reason:" << invalidFileReason << "\n";
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


    /// set current played video index
    int cpvi = this->getInitCurentPlayedVideoIndex();
    this->setCurrentPlayedVideoIndex(cpvi);
}

void Backend::changeCurrentlyPlayedVideo()
{
    QString videoPath = m_playlist.at(m_currentPlayedVideoIndex);
    emit this->currentlyPlayedVideoChanged(videoPath);
}

bool Backend::isValidFileName(QString fileName, QChar &type, QString &invalidFileReason) const
{
    type = '\0';

    /// check length of the file name
    if(fileName.size() < 5)
    {
        invalidFileReason = QString::asprintf("to short name, expected < 5, got %lld", fileName.size());
        return false;
    }

    /// check if last five letters are "B.mp4" or "F.mp4" (case insensitive)
    QString postfix = fileName.right(5).toUpper();
    if(postfix != "B.MP4" && postfix != "F.MP4")
    {
        invalidFileReason = "invalid postfix, expected \"B.mp4\" or \"F.mp4\" (case insensitive), got \"" + postfix + "\"";
        return false;
    }

    type = postfix[0];
    return true;
}

void Backend::setCurrentPlayedVideoIndex(int index)
{
    if(m_currentPlayedVideoIndex == index)
        return;

    m_currentPlayedVideoIndex = index;
    emit this->currentPlayedVideoIndexChanged();
}

int Backend::getInitCurentPlayedVideoIndex() const
{
    int cpvi = -1; /// m_currentPlayedVideoIndex
    for(const auto &file : m_playlist)
    {
        ++ cpvi;

        if(file == m_selectedFile)
        {
            break;
        }
    }
    // qDebug() << "index" << cpvi;
    if(cpvi == -1)
    {
        qWarning() << "file" << m_selectedFile << "was not found in playlist" << m_playlist;

        exit(1);
        /// user selects a file, and then a playlist is created (all files in the path where the selected file is located),
        /// and then the file cannot be found in the playlist (I don't know how to handle this)
    }

    return cpvi;
}
