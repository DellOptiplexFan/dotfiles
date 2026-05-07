import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Text {
    color: "#cdd6f4"
    font.pixelSize: 16
    font.weight: Font.Medium
    text: {
        const source = Pipewire.defaultAudioSource;
        if (!source)
            return "-- ";
        const vol = Math.round(source.audio.volume * 100);
        const muted = source.audio.muted;
        return vol + "% " + (muted ? "" : "");
    }

    MouseArea {
        anchors.fill: parent
        onWheel: event => {
            const source = Pipewire.defaultAudioSource;
            if (!source)
                return;
            const delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
            source.audio.volume = Math.max(0, Math.min(1, source.audio.volume + delta));
        }
        onClicked: {
            const source = Pipewire.defaultAudioSource;
            if (source)
                source.audio.muted = !source.audio.muted;
        }
    }
}
