cmake_minimum_required(VERSION 3.16)

project(CarCameraPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/assets/icons/appIcon/appicon.rc")

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup()

qt_add_executable(appCarCameraPlayer
    sources/main.cpp
    ${APP_ICON_RESOURCE_WINDOWS}
)

qt_policy(SET QTP0001 NEW)

qt_add_qml_module(appCarCameraPlayer
    URI CarCameraPlayer
    VERSION 1.0
    QML_FILES qml/Main.qml
    QML_FILES qml/BetterButtonText.qml
    QML_FILES qml/InvalidRoot.qml
    QML_FILES qml/ValidRoot.qml
    QML_FILES qml/ImageButton.qml
    QML_FILES qml/ControlsPanel.qml

    SOURCES sources/Backend.h sources/Backend.cpp
    SOURCES sources/VideoPath.h sources/VideoPath.cpp

    RESOURCES assets/icons/next.svg
    RESOURCES assets/icons/pause.svg
    RESOURCES assets/icons/play.svg
    RESOURCES assets/icons/prev.svg
    RESOURCES assets/icons/volume_0.svg
    RESOURCES assets/icons/volume_1.svg
    RESOURCES assets/icons/volume_2.svg
    RESOURCES assets/icons/volume_3.svg
    RESOURCES assets/icons/replace.svg
    RESOURCES assets/icons/0.svg
    RESOURCES assets/icons/1.svg
    RESOURCES assets/icons/2.svg
    RESOURCES assets/icons/3.svg
    RESOURCES assets/icons/4.svg
    RESOURCES assets/icons/invisible.svg
    RESOURCES assets/icons/visible.svg
    RESOURCES assets/icons/folder.svg
    RESOURCES assets/icons/opened_folder.svg
    RESOURCES assets/icons/add_folder.svg

    RESOURCES assets/icons/appIcon/appicon.rc
    SOURCES sources/AudioMonitor.h sources/AudioMonitor.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCarCameraPlayer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCarCameraPlayer
    OUTPUT_NAME "Car Camera Player"
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCarCameraPlayer
    PRIVATE Qt6::Quick
    Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS appCarCameraPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
