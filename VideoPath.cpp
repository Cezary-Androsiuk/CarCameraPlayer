#include "VideoPath.h"

VideoPath::VideoPath(QObject *parent)
    : QObject{parent}
{}

void VideoPath::addVideoFile(QString videoFile)
{
    /// videoFile should be valid (handled in caller)

    if(videoFile[videoFile.size() -5] == 'F') /// front camera was given
    {
        m_frontVideoFile = videoFile;

        m_backVideoFile = this->findBackInFile(); /// if failed returns QString("")
        if(m_backVideoFile == "") /// findBackInFile failed
        {
            m_backVideoFile = this->findBackOutFile(); /// if failed returns QString("")

            if(m_backVideoFile == "") /// findBackOutFile failed
            {
                /// back camera file not found
                qInfo() << "back camera file not found";
                return;
            }
        }
    }
    else /// == 'B' /// back camera
    {
        m_backVideoFile = videoFile;

        m_frontVideoFile = this->findFrontInFile(); /// if failed returns QString("")
        if(m_frontVideoFile == "") /// findFrontInFile failed
        {
            m_frontVideoFile = this->findFrontOutFile(); /// if failed returns QString("")

            if(m_frontVideoFile == "") /// findFrontOutFile failed
            {
                /// back camera file not found
                qInfo() << "front camera file not found";
                return;
            }
        }
    }

}

QString VideoPath::findBackInFile()
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

QString VideoPath::findBackOutFile()
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

QString VideoPath::findFrontInFile()
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

QString VideoPath::findFrontOutFile()
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
