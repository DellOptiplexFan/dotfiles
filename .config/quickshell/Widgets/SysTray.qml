import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Row {
    spacing: 4

    Repeater {
        model: SystemTray.items
        delegate: Item {
            required property SystemTrayItem modelData
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: icon
            }

            IconImage {
                id: icon
                source: modelData.icon
                width: 20
                height: 20
                anchors.fill: parent

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: event => {
                        if (event.button === Qt.RightButton)
                            menuAnchor.open();
                        else
                            modelData.activate();
                    }
                }
            }
        }
    }
}
