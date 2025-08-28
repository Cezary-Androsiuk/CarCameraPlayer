#include "AudioMonitor.h"

#include <QDebug>

AudioMonitor::AudioMonitor(QObject *parent)
    : QObject{parent}
{
    m_resendTimer.setInterval(100);
    m_resendTimer.setSingleShot(true);

    QObject::connect(
        &m_mediaDevicesSingleton, &QMediaDevices::audioOutputsChanged,
        this, &AudioMonitor::mainAudioDeviceChanged);

}

void AudioMonitor::pleaseResendSignal(const QString &signal)
{
    if(signal == "mainAudioDeviceChanged")
    {
        m_resentTimerConnection = QObject::connect(
            &m_resendTimer, &QTimer::timeout,
            this, [&](){
                emit this->mainAudioDeviceChanged();
                QObject::disconnect(m_resentTimerConnection);
            });
        m_resendTimer.start();
    }
    else
    {
        qWarning() << "Unknown signal: " << signal;
    }
}
