import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell.Io

PanelWindow {
    id: root
    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
    }

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 30

    property real cpuUsage: 0
    property var prevCpuStats: null
    property real ramUsage: 0
    property real ramUsed: 0
    property real ramTotal: 0

    Process {
        id: cpuProcess
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.split("\n")[0]
                const parts = line.trim().split(/\s+/)
                const user = parseInt(parts[1])
                const nice = parseInt(parts[2])
                const system = parseInt(parts[3])
                const idle = parseInt(parts[4])
                const iowait = parseInt(parts[5])
                const irq = parseInt(parts[6])
                const softirq = parseInt(parts[7])
                const totalIdle = idle + iowait
                const total = user + nice + system + idle + iowait + irq + softirq
                if (prevCpuStats) {
                    const totalDiff = total - prevCpuStats.total
                    const idleDiff = totalIdle - prevCpuStats.idle
                    cpuUsage = Math.round((totalDiff - idleDiff) / totalDiff * 100)
                }
                prevCpuStats = { total: total, idle: totalIdle }
            }
        }
    }

    Process {
        id: ramProcess
        command: ["cat", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n")
                let memTotal = 0
                let memAvailable = 0
                for (const line of lines) {
                    if (line.startsWith("MemTotal:"))
                        memTotal = parseInt(line.trim().split(/\s+/)[1])
                    else if (line.startsWith("MemAvailable:"))
                        memAvailable = parseInt(line.trim().split(/\s+/)[1])
                }
                ramTotal = Math.round(memTotal / 1024)
                ramUsed = Math.round((memTotal - memAvailable) / 1024)
                ramUsage = Math.round((memTotal - memAvailable) / memTotal * 100)
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProcess.running = false
            cpuProcess.running = true
            ramProcess.running = false
            ramProcess.running = true
        }
    }

    Row {
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        leftPadding: 6


        Item {
            width: image.width + 3
            height: parent.height

            Image {
                id: image
                source: "/home/michael/.config/waybar/image/CachyOS_Logo.svg"
                width: 25
                height: 25
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                sourceSize.width: 25
                sourceSize.height: 25
            }
        }

        Repeater {
            model: Hyprland.workspaces
            delegate: Button {
                implicitWidth: 22
                implicitHeight: 32
                required property HyprlandWorkspace modelData
                text: modelData.name
                highlighted: Hyprland.focusedWorkspace === modelData
                onClicked: Hyprland.dispatch("workspace " + modelData.id)
                // Styling

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

    SystemClock { id: clock }

    Text {
        anchors.centerIn: parent
        font.weight: Font.Medium
        color: "#cdd6f4"
        font.pixelSize: 16
        text: Qt.formatDateTime(clock.date, "h:mm:ss AP")
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource] }

    // Roght side bar
    Row {
        rightPadding: 5
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 5

        // Cpu stats
        Text {
            font.weight: Font.Medium
            font.pixelSize: 16
            color: "#cdd6f4"
            text: cpuUsage + "%" + " " + ""
        }

        // Mem stats
        Text {
            font.weight: Font.Medium
            font.pixelSize: 16
            color: "#cdd6f4"
            text: ramUsage + "%" + " " + ""
        }

        Text {
            font.weight: Font.Medium
            font.pixelSize: 16
            color: "#cdd6f4"
            text: {
                const sink = Pipewire.defaultAudioSink
                if (!sink) return "VOL --"
                const vol = Math.round(sink.audio.volume * 100)
                const muted = sink.audio.muted
                return vol + "%" + " " + (muted ? "" : "")
            }
            MouseArea {
                anchors.fill: parent
                onWheel: (event) => {
                    const sink = Pipewire.defaultAudioSink
                    if (!sink) return
                    const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                    sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + delta))
                }
                onClicked: {
                    const sink = Pipewire.defaultAudioSink
                    if (sink) sink.audio.muted = !sink.audio.muted
                }
            }
        }

        // Pipewire audio thing
        Text {
            font.weight: Font.Medium
            font.pixelSize: 16
            color: "#cdd6f4"
            text: {
                const source = Pipewire.defaultAudioSource
                if (!source) return "MIC --"
                const vol = Math.round(source.audio.volume * 100)
                const muted = source.audio.muted
                return + vol + "%" + " "  + (muted ? "" : "")
            }
            MouseArea {
                anchors.fill: parent
                onWheel: (event) => {
                    const source = Pipewire.defaultAudioSource
                    if (!source) return
                    const delta = event.angleDelta.y > 0 ? 0.05 : -0.05
                    source.audio.volume = Math.max(0, Math.min(1, source.audio.volume + delta))
                }
                onClicked: {
                    const source = Pipewire.defaultAudioSource
                    if (source) source.audio.muted = !source.audio.muted
                }
            }
        }

        // Sys tray
        Row {
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter
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
                        anchor.item: trayIcon
                    }

                    IconImage {
                        id: trayIcon
                        source: modelData.icon
                        width: 20
                        height: 20
                        anchors.fill: parent

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: (event) => {
                                if (event.button === Qt.RightButton) {
                                    menuAnchor.open()
                                } else {
                                    modelData.activate()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
