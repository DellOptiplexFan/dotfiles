import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Item {
    id: root

    signal clicked

    visible: Mpris.players.values.length > 0
    implicitWidth: visible ? label.implicitWidth : 0
    implicitHeight: 30

    Text {
        id: label
        anchors.centerIn: parent
        color: "#cdd6f4"
        font.pixelSize: 13
        font.weight: Font.Medium
        text: {
            if (Mpris.players.values.length === 0)
                return "";
            const p = Mpris.players.values[0];
            if (!p)
                return "";
            const icon = p.isPlaying ? "󰏤 " : "󰐊 ";
            const title = p.trackTitle || "Unknown";
            return icon + (title.length > 22 ? title.slice(0, 22) + "…" : title);
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
