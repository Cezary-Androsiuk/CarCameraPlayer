#include "AudioMonitor.h"

AudioMonitor::AudioMonitor(QObject *parent)
    : QObject{parent}
{
    QObject::connect(
        &m_mediaDevicesSingleton, &QMediaDevices::audioOutputsChanged,
        this, &AudioMonitor::mainAudioDeviceChanged);
}
