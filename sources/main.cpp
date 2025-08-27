#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "Backend.h"
#include "VideoPath.h"

/// works for records gained from 70mai Dash Cam Pro Plus A500S
/// 1. po zaznaczeniu pliku .mp4 możliwe są dwa scenariusze, 1{ nagrania uzupełniające (gdy wybierzesz F to uzupełnieniem jest B i na odwrót)
///     są w tym samym katalogu } 2{ nagrania uzupełniające są w katalogu ../Front/ gdy zostanie wybrane B lub ../Back/ gdy zostanie wybrane F }
/// 2. szuka w ścieżce wszystkie pliki z taką samą końcówką co wybrana (B lub F) w celu utworzenia katalogu

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationDisplayName(QString("Car Camera Player ") + version);

    QQmlApplicationEngine engine;

    Backend* backend = new Backend(&engine);
    VideoPath *videoPath = new VideoPath(&engine);
    QObject::connect(backend, &Backend::currentlyPlayedVideoChanged, videoPath, &VideoPath::setVideoFile);

    engine.rootContext()->setContextProperty("appName", app.applicationDisplayName());
    engine.rootContext()->setContextProperty("Backend", backend);
    engine.rootContext()->setContextProperty("VideoPath", videoPath);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("CarCameraPlayer", "Main");

    return app.exec();
}
