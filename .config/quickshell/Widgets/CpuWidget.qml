import Quickshell
import Quickshell.Io
import QtQuick

Text {
    id: root

    property real usage: 0
    property var prevStats: null

    color: "#cdd6f4"
    font.pixelSize: 16
    font.weight: Font.Medium
    text: root.usage + "%" + " " + ""

    Process {
        id: proc
        command: ["cat", "/proc/stat"]
        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.split("\n")[0];
                const parts = line.trim().split(/\s+/);
                const user = parseInt(parts[1]);
                const nice = parseInt(parts[2]);
                const system = parseInt(parts[3]);
                const idle = parseInt(parts[4]);
                const iowait = parseInt(parts[5]);
                const irq = parseInt(parts[6]);
                const softirq = parseInt(parts[7]);
                const totalIdle = idle + iowait;
                const total = user + nice + system + idle + iowait + irq + softirq;
                if (root.prevStats) {
                    const totalDiff = total - root.prevStats.total;
                    const idleDiff = totalIdle - root.prevStats.idle;
                    root.usage = Math.round((totalDiff - idleDiff) / totalDiff * 100);
                }
                root.prevStats = {
                    total: total,
                    idle: totalIdle
                };
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
