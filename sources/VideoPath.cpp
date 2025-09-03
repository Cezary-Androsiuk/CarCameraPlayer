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

        QString backVideoFile = this->findBack();  /// if failed returns QString("")

        if(backVideoFile == "") /// back video file not found
        {
            qInfo() << "back camera file not found";
        }
        else /// back video file found
        {
            qInfo() << "found back file2:" << backVideoFile;
            this->setBackVideoFile(backVideoFile);
            return;
        }
    }
    else /// == 'B' /// back camera
    {
        this->setBackVideoFile(videoFile);

        QString frontVideoFile = this->findFront();  /// if failed returns QString("")

        if(frontVideoFile == "") /// front video file not found
        {
            qInfo() << "front camera file not found";
        }
        else /// front video file found
        {
            qInfo() << "found front file2:" << frontVideoFile;
            this->setFrontVideoFile(frontVideoFile);
            return;
        }
    }
}

QString VideoPath::findBack() const
{
    QString backVideoFile;

    backVideoFile = this->findBackInCurrentDir(); /// if failed returns QString("")
    if(backVideoFile != "") /// findBackInCurrentDir found (the same location)
        return backVideoFile;

    backVideoFile = this->findBackInParentDir(); /// if failed returns QString("")
    if(backVideoFile != "") /// findBackInParentDir found (in outside location)
        return backVideoFile;

    return backVideoFile;
}

QString VideoPath::findFront() const
{
    QString frontVideoFile;

    frontVideoFile = this->findFrontInCurrentDir(); /// if failed returns QString("")
    if(frontVideoFile != "") /// findFrontInCurrentDir failed (the same location)
        return frontVideoFile;

    frontVideoFile = this->findFrontInParentDir(); /// if failed returns QString("")
    if(frontVideoFile != "") /// findFrontInParentDir failed (in outside location)
        return frontVideoFile;

    return frontVideoFile;
}

QString VideoPath::findBackInCurrentDir() const
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

QString VideoPath::findBackInParentDir() const
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

QString VideoPath::findFrontInCurrentDir() const
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

QString VideoPath::findFrontInParentDir() const
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
