import Quickshell
import Quickshell.Io
import QtQuick

Text {
    id: root

    property real usage: 0

    color: "#cdd6f4"
    font.pixelSize: 16
    font.weight: Font.Medium
    text: root.usage + "%" + " " + ""

    Process {
        id: proc
        command: ["cat", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n");
                let memTotal = 0;
                let memAvailable = 0;
                for (const line of lines) {
                    if (line.startsWith("MemTotal:"))
                        memTotal = parseInt(line.trim().split(/\s+/)[1]);
                    else if (line.startsWith("MemAvailable:"))
                        memAvailable = parseInt(line.trim().split(/\s+/)[1]);
                }
                root.usage = Math.round((memTotal - memAvailable) / memTotal * 100);
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            proc.running = false;
            proc.running = true;
        }
    }
}
