import QtQuick
import QtQuick.Dialogs

Item {
    FileDialog {
        id: fileDialog
        title: "Wybierz plik"
        onAccepted: {
            console.log("Wybrany plik: " + fileUrl)
            Qt.quit() // Zamknij aplikację po wybraniu pliku
        }
        onRejected: {
            console.log("Dialog został zamknięty bez wyboru pliku")
            Qt.quit() // Zamknij aplikację, gdy dialog zostanie zamknięty bez wyboru
        }

        Component.onCompleted: fileDialog.open()
    }

}
