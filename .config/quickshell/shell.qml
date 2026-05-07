//@ pragma UseQApplication
import Quickshell

ShellRoot {
    Bar {
        id: bar
    }

    MediaPopup {
        visible: bar.mediaOpen
        player: bar.currentPlayer
        widgetCenterX: bar.mediaWidgetCenterX
        onCloseRequested: bar.mediaOpen = false
    }
}
