import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "touch-controls"

  implicitWidth: row.implicitWidth
  implicitHeight: barSize

  // Resolves the absolute directory of this plugin so bundled scripts work anywhere
  readonly property string scriptDir: {
    var base = Qt.resolvedUrl(".").toString()
    if (base.indexOf("file://") === 0) {
      base = base.substring(7)
    }
    return base.replace(/\/+$/, "") + "/scripts/"
  }

  Row {
    id: row
    anchors.verticalCenter: parent.verticalCenter
    spacing: Style.space(2)

    WidgetButton {
      bar: root.bar
      text: "󰌌"
      tooltipText: "Touch Keyboard"
      fontSize: Style.font.body
      fixedWidth: Style.space(28)
      fixedHeight: root.barSize
      onPressed: function() {
        Quickshell.execDetached([root.scriptDir + "osk.sh"])
      }
    }

    WidgetButton {
      bar: root.bar
      text: "󰑮"
      tooltipText: "Rotate Screen"
      fontSize: Style.font.body
      fixedWidth: Style.space(28)
      fixedHeight: root.barSize
      onPressed: function() {
        Quickshell.execDetached([root.scriptDir + "rotate.sh"])
      }
    }

    WidgetButton {
      bar: root.bar
      text: "󰓡"
      tooltipText: "Flip / Lock Keyboard"
      fontSize: Style.font.body
      fixedWidth: Style.space(28)
      fixedHeight: root.barSize
      onPressed: function() {
        Quickshell.execDetached([root.scriptDir + "flip.sh"])
      }
    }
  }
}
