import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: popup

    // Passed in from shell.qml — resolved by Bar where MPRIS is known to work
    property var player: null
    property real widgetCenterX: 0

    // Emit this instead of setting visible = false directly,
    // so the `visible: bar.mediaOpen` binding in shell.qml is never broken
    signal closeRequested

    anchors.top: true
    anchors.left: true
    anchors.right: true
    exclusionMode: ExclusionMode.Ignore
    implicitHeight: 30 + 4 + 140 + 8
    color: "transparent"

    // Tick position so the progress bar moves while playing
    Timer {
        interval: 1000
        running: popup.visible && popup.player !== null && popup.player.isPlaying
        repeat: true
        onTriggered: if (popup.player)
            popup.player.positionChanged()
    }

    // Click outside card → close
    MouseArea {
        anchors.fill: parent
        onClicked: popup.closeRequested()
    }

    // The card
    Rectangle {
        width: 300
        height: 140
        x: Math.max(4, Math.min(popup.width - width - 4, popup.widgetCenterX - width / 2))
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        color: "#181825"
        radius: 0
        border.color: "#fab387"
        border.width: 2

        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors {
                fill: parent
                margins: 12
            }
            spacing: 6

            // Top row: album art + track info
            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    width: 56
                    height: 56
                    color: "#313244"
                    radius: 0
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    Image {
                        id: albumArt
                        anchors.fill: parent
                        source: popup.player ? popup.player.trackArtUrl : ""
                        fillMode: Image.PreserveAspectCrop
                        visible: status === Image.Ready
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "♪"
                        font.pixelSize: 24
                        color: "#6c7086"
                        visible: albumArt.status !== Image.Ready
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: popup.player ? (popup.player.trackTitle || "Unknown Title") : "No media"
                        color: "#cdd6f4"
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: popup.player ? (popup.player.trackArtist || "") : ""
                        color: "#a6adc8"
                        font.pixelSize: 12
                        elide: Text.ElideRight
                    }

                    Text {
                        Layout.fillWidth: true
                        text: popup.player ? (popup.player.trackAlbum || "") : ""
                        color: "#6c7086"
                        font.pixelSize: 11
                        elide: Text.ElideRight
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }

            // Progress bar — full card width
            Rectangle {
                Layout.fillWidth: true
                height: 3
                radius: 0
                color: "#313244"
                visible: popup.player !== null

                Rectangle {
                    width: {
                        const p = popup.player;
                        if (!p || !p.length || p.length <= 0)
                            return 0;
                        return parent.width * Math.min(1, p.position / p.length);
                    }
                    height: parent.height
                    radius: parent.radius
                    color: "#fab387"
                }
            }

            // Controls — centered under full card width
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Text {
                    text: "󰒮"
                    font.pixelSize: 16
                    color: popup.player && popup.player.canGoPrevious ? "#cdd6f4" : "#45475a"
                    Layout.alignment: Qt.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (popup.player)
                            popup.player.previous()
                    }
                }

                Text {
                    text: popup.player && popup.player.isPlaying ? "󰏤" : "󰐊"
                    font.pixelSize: 22
                    color: "#cdd6f4"
                    Layout.alignment: Qt.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (popup.player)
                            popup.player.togglePlaying()
                    }
                }

                Text {
                    text: "󰒭"
                    font.pixelSize: 16
                    color: popup.player && popup.player.canGoNext ? "#cdd6f4" : "#45475a"
                    Layout.alignment: Qt.AlignVCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (popup.player)
                            popup.player.next()
                    }
                }
            }
        }
    }
}
