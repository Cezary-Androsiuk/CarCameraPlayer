#include "VideoPath.h"

VideoPath::VideoPath(QObject *parent)
    : QObject{parent}
{}

QString VideoPath::getFrontVideoFile() const
{
    return m_frontVideoFile;
}

QString VideoPath::getBackVideoFile() const
{
    return m_backVideoFile;
}

void VideoPath::setVideoFile(QString videoFile)
{
    /// videoFile should be valid (handled in caller)

    this->buildAlternativeFilePath(videoFile);
}

void VideoPath::buildAlternativeFilePath(QString videoFile)
{
    if(videoFile[videoFile.size() -5] == 'F') /// front camera was given
    {
        this->setFrontVideoFile(videoFile);

        QString backVideoFile;
        backVideoFile = this->findBackInFile(); /// if failed returns QString("")

        if(backVideoFile != "") /// findBackInFile found (the same location)
        {
            qInfo() << "found back file2:" << backVideoFile;
            this->setBackVideoFile(backVideoFile);
            return;
        }

        backVideoFile = this->findBackOutFile(); /// if failed returns QString("")

        if(backVideoFile != "") /// findBackOutFile found (in outside location)
        {
            qInfo() << "found back file2:" << backVideoFile;
            this->setBackVideoFile(backVideoFile);
            return;
        }

        /// back camera file not found
        qInfo() << "back camera file not found";
    }
    else /// == 'B' /// back camera
    {
        this->setBackVideoFile(videoFile);

        QString frontVideoFile;
        frontVideoFile = this->findFrontInFile(); /// if failed returns QString("")

        if(frontVideoFile != "") /// findFrontInFile failed (the same location)
        {
            qInfo() << "found front file2:" << frontVideoFile;
            this->setFrontVideoFile(frontVideoFile);
            return;
        }

        frontVideoFile = this->findFrontOutFile(); /// if failed returns QString("")

        if(frontVideoFile != "") /// findFrontOutFile failed (in outside location)
        {
            qInfo() << "found front file2:" << frontVideoFile;
            this->setFrontVideoFile(frontVideoFile);
            return;
        }

        /// front camera file not found
        qInfo() << "front camera file not found";
    }
}

QString VideoPath::findBackInFile() const
{
    QString given = m_frontVideoFile;
    if(given[given.size()-5] != 'F')
    {
        qWarning() << "given file not contains F at size-5 position";
        return "";
    }
    given[given.size()-5] = 'B';
    if(!QFileInfo::exists(given))
    {
        qInfo() << "alternative back in file not exist:" << given;
        return "";
    }
    return given;
}

QString VideoPath::findBackOutFile() const
{
    QString given = m_frontVideoFile;
    if(given[given.size()-5] != 'F')
    {
        qWarning() << "given file not contains F at size-5 position";
        return "";
    }

    QDir backDirectory(given);
    bool cdFiled = false;
    cdFiled |= !backDirectory.cdUp();
    cdFiled |= !backDirectory.cdUp();
    cdFiled |= !backDirectory.cd("Back");

    if(cdFiled)
    {
        qInfo() << "cd failed while creating Back out file path, stoped at:" << backDirectory;
        return "";
    }
    given[given.size()-5] = 'B';
    QString backVideoFile = backDirectory.path() + "/" + QFileInfo(given).fileName();

    if(!QFileInfo::exists(backVideoFile))
    {
        qInfo() << "alternative back in file not exist:" << backVideoFile;
        return "";
    }
    return backVideoFile;
}

QString VideoPath::findFrontInFile() const
{
    QString given = m_backVideoFile;
    if(given[given.size()-5] != 'B')
    {
        qWarning() << "given file not contains B at size-5 position";
        return "";
    }
    given[given.size()-5] = 'F';
    if(!QFileInfo::exists(given))
    {
        qInfo() << "alternative front in file not exist:" << given;
        return "";
    }
    return given;
}

QString VideoPath::findFrontOutFile() const
{
    QString given = m_backVideoFile;
    if(given[given.size()-5] != 'B')
    {
        qWarning() << "given file not contains B at size-5 position";
        return "";
    }
    QDir frontDirectory(given);

    bool cdFiled = false;
    cdFiled |= !frontDirectory.cdUp();
    cdFiled |= !frontDirectory.cdUp();
    cdFiled |= !frontDirectory.cd("Front");

    if(cdFiled)
    {
        qInfo() << "cd failed while creating Front out file path, stoped at:" << frontDirectory;
        return "";
    }
    given[given.size()-5] = 'F';
    QString frontVideoFile = frontDirectory.path() + "/" + QFileInfo(given).fileName();

    if(!QFileInfo::exists(frontVideoFile))
    {
        qInfo() << "alternative front in file not exist:" << frontVideoFile;
        return "";
    }
    return frontVideoFile;
}

void VideoPath::setFrontVideoFile(QString frontVideoFile)
{
    if(frontVideoFile == m_frontVideoFile)
        return;

    m_frontVideoFile = frontVideoFile;
    emit this->frontVideoFileChanged();
}

void VideoPath::setBackVideoFile(QString backVideoFile)
{
    if(backVideoFile == m_backVideoFile)
        return;

    m_backVideoFile = backVideoFile;
    emit this->backVideoFileChanged();
}
