import Quickshell
import QtQuick

Item {
    id: root

    property bool showDate: false

    implicitWidth: label.implicitWidth + 16
    implicitHeight: 30

    SystemClock {
        id: clock
    }

    Text {
        id: label
        anchors.centerIn: parent
        font.weight: Font.Medium
        color: "#cdd6f4"
        font.pixelSize: 16
        text: root.showDate ? Qt.formatDateTime(clock.date, "dddd, MMMM d yyyy") : Qt.formatDateTime(clock.date, "h:mm:ss AP")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.showDate = !root.showDate
    }
}
