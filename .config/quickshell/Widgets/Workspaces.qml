import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls

Row {
    spacing: 3

    Repeater {
        model: Hyprland.workspaces
        delegate: Button {
            implicitWidth: 22
            implicitHeight: 32
            required property HyprlandWorkspace modelData
            text: modelData.name
            highlighted: Hyprland.focusedWorkspace === modelData
            onClicked: Hyprland.dispatch("workspace " + modelData.id)

            contentItem: Text {
                text: parent.text
                font.weight: Font.Medium
                color: "#a6adc8"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                color: parent.highlighted ? "#313244" : "#181825"
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 4
                color: parent.highlighted ? "#fab387" : "#a6adc8"
            }
        }
    }
}
