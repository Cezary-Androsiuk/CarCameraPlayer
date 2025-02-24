cmake_minimum_required(VERSION 3.16)

project(CarCameraPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appCarCameraPlayer
    main.cpp
)

qt_add_qml_module(appCarCameraPlayer
    URI CarCameraPlayer
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES Backend.h Backend.cpp
        QML_FILES BetterButtonText.qml
        SOURCES VideoPath.h VideoPath.cpp
        QML_FILES InvalidRoot.qml
        QML_FILES ValidRoot.qml
        QML_FILES ImageButton.qml
        RESOURCES assets/icons/next.svg
        RESOURCES assets/icons/pause.svg
        RESOURCES assets/icons/play.svg
        RESOURCES assets/icons/prev.svg
        RESOURCES assets/icons/volume_0.svg
        RESOURCES assets/icons/volume_1.svg
        RESOURCES assets/icons/volume_2.svg
        RESOURCES assets/icons/volume_3.svg
        RESOURCES assets/icons/switch.svg
        RESOURCES assets/icons/0.svg
        RESOURCES assets/icons/1.svg
        RESOURCES assets/icons/2.svg
        RESOURCES assets/icons/3.svg
        RESOURCES assets/icons/4.svg
        RESOURCES assets/icons/invisible.svg
        RESOURCES assets/icons/visible.svg
        QML_FILES ControlsPanel.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appCarCameraPlayer PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appCarCameraPlayer
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appCarCameraPlayer
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appCarCameraPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
