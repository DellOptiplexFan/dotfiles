import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Text {
    color: "#cdd6f4"
    font.pixelSize: 16
    font.weight: Font.Medium
    text: {
        const sink = Pipewire.defaultAudioSink;
        if (!sink)
            return "-- ";
        const vol = Math.round(sink.audio.volume * 100);
        const muted = sink.audio.muted;
        return vol + "% " + (muted ? "" : "");
    }

    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            const sink = Pipewire.defaultAudioSink;
            if (!sink)
                return;
            const delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
            sink.audio.volume = Math.max(0, Math.min(1, sink.audio.volume + delta));
        }
        onClicked: {
            const sink = Pipewire.defaultAudioSink;
            if (sink)
                sink.audio.muted = !sink.audio.muted;
        }
    }
}
