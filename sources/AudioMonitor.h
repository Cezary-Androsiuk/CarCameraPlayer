#ifndef AUDIOMONITOR_H
#define AUDIOMONITOR_H

#include <QObject>
#include <QTimer>
#include <QMediaDevices>

/*
 * This class has purpose in detecting change in output audio device
 * from headphones to speaker and etc.
 *
 * In the end QMediaDevice already has signal for informing about the change,
 * this class will be just a holder for it
 */

class AudioMonitor : public QObject
{
    Q_OBJECT
public:
    explicit AudioMonitor(QObject *parent = nullptr);

public slots:
    void pleaseResendSignal(const QString &signal);

signals:
    void mainAudioDeviceChanged();

private:
    QMediaDevices m_mediaDevicesSingleton; /// object is only a reference to a singleton
    QTimer m_resendTimer;
    QMetaObject::Connection m_resentTimerConnection;
};

#endif // AUDIOMONITOR_H
