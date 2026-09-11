
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Variants {
  model: Quickshell.screens

  delegate: Component {
    PanelWindow {
      required property var modelData
      screen: modelData

      anchors { top: true; left: true; right: true }
      implicitHeight: 24
      color: "transparent"

      Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 2

        height: 18
        width: contentLayout.width + 12
        color: "#18181b"
        border.color: "#3f3f46"
        border.width: 1
        radius: 9

        RowLayout {
          id: contentLayout
          anchors.centerIn: parent
          spacing: 6

          RowLayout {
            spacing: 4
            Text {
              text: ""
              color: "#a1a1aa"
              font.family: "JetBrainsMono Nerd Font"
            }
            Text {
              id: wsText
              text: "1"
              color: "#f4f4f5"
              font.family: "JetBrainsMono Nerd Font"

              Process {
                id: wsProc
                command: ["sh", "-c", "
                  if command -v hyprctl >/dev/null 2>&1; then
                    hyprctl activeworkspace -j | jq '.id'
                  elif command -v niri >/dev/null 2>&1; then
                    niri msg -j workspaces | jq '.[] | select(.is_active) | .idx'
                  else
                    echo '1'
                  fi
                "]
                running: true
                stdout: StdioCollector {
                  onStreamFinished: {
                    let val = this.text.trim();
                    if (val !== "") wsText.text = val;
                  }
                }
              }

              Timer {
                interval: 200; running: true; repeat: true
                onTriggered: wsProc.running = true
              }
            }
          }

          Rectangle { width: 1; height: 8; color: "#3f3f46" }

          RowLayout {
            spacing: 4
            Text {
              text: "󱑍"
              color: "#a1a1aa"
              font.family: "JetBrainsMono Nerd Font"
            }
            Text {
              id: clockText
              text: "00:00"
              color: "#f4f4f5"
              font.family: "JetBrainsMono Nerd Font"

              Process {
                id: clockProc
                command: ["date", "+%H:%M"]
                running: true
                stdout: StdioCollector {
                  onStreamFinished: clockText.text = this.text.trim()
                }
              }

              Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: clockProc.running = true
              }
            }
          }
        }
      }
    }
  }
}
