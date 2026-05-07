import Quickshell
import Quickshell.Hyprland
import QtQuick

Text {
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    font.weight: Font.Medium
    color: "#a6adc8"
    font.pixelSize: 14
    width: Math.min(implicitWidth, 300)
    elide: Text.ElideRight
    text: Hyprland.activeToplevel && Hyprland.activeToplevel.wayland ? Hyprland.activeToplevel.wayland.title : ""
}
