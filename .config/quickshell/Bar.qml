import Quickshell
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import QtQuick
import "Widgets"

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30

    property bool mediaOpen: false
    property var currentPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property real mediaWidgetCenterX: 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
    }

    // Left: workspaces + active window title
    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        leftPadding: 6

        Workspaces {}
        WindowTitle {}
    }

    // Center: media widget + clock
    Row {
        anchors.centerIn: parent
        spacing: 3

        MediaWidget {
            id: mediaBarWidget
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                root.mediaWidgetCenterX = mediaBarWidget.mapToItem(null, mediaBarWidget.width / 2, 0).x;
                root.mediaOpen = !root.mediaOpen;
            }
        }

        Clock {
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Right: status widgets
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        rightPadding: 5
        spacing: 5

        CpuWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        RamWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        VolumeWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        MicWidget {
            anchors.verticalCenter: parent.verticalCenter
        }
        SysTray {
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
