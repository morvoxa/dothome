
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
      // Background bar dibuat solid pekat (hitam legam) agar tidak ada celah transparan yang bikin "patah-patah"
      color: "#09090b"

      // 1. STATUS BAR UTAMA (WORKSPACE & CLOCK) - Di posisi tengah layar
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
                    let val = this.text ? this.text.trim() : "";
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
                  onStreamFinished: {
                    if (this.text) clockText.text = this.text.trim();
                  }
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

      // 2. TITLE BAR DI KIRI (Maksimal 60 karakter + "...")
      Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 2

        height: 18
        width: Math.min(titleContentLayout.width + 16, 450)
        color: "#18181b"
        border.color: "#3f3f46"
        border.width: 1
        radius: 9
        clip: true

        RowLayout {
          id: titleContentLayout
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
          anchors.leftMargin: 8
          spacing: 6

          Text {
            text: "~/"
            color: "#a1a1aa"
            font.family: "JetBrainsMono Nerd Font"
            Layout.alignment: Qt.AlignVCenter
          }
          Text {
            id: titleText
            text: "Desktop"
            color: "#f4f4f5"
            font.family: "JetBrainsMono Nerd Font"
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.maximumWidth: 410

            Process {
              id: titleProc
              command: ["sh", "-c", "
                if command -v hyprctl >/dev/null 2>&1; then
                  hyprctl activewindow -j | jq -r '.title // \"Desktop\"'
                elif command -v niri >/dev/null 2>&1; then
                  niri msg -j windows | jq -r '.[] | select(.is_focused) | .title // \"Desktop\"'
                else
                  echo 'Desktop'
                fi
              "]
              running: true
              stdout: StdioCollector {
                onStreamFinished: {
                  let val = this.text ? this.text.trim() : "";
                  if (val !== "") {
                    if (val.length > 60) {
                      titleText.text = val.substring(0, 57) + "...";
                    } else {
                      titleText.text = val;
                    }
                  }
                }
              }
            }

            Timer {
              interval: 300; running: true; repeat: true
              onTriggered: titleProc.running = true
            }
          }
        }
      }

      // 3. STATUS WIFI DI KANAN
      Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 2

        height: 18
        width: wifiContentLayout.width + 12
        color: "#18181b"
        border.color: "#3f3f46"
        border.width: 1
        radius: 9

        RowLayout {
          id: wifiContentLayout
          anchors.centerIn: parent
          spacing: 4

          Text {
            id: wifiIconText
            text: "󰤨"
            color: "#a1a1aa"
            font.family: "JetBrainsMono Nerd Font"
          }
          Text {
            id: wifiText
            text: "Connected"
            color: "#f4f4f5"
            font.family: "JetBrainsMono Nerd Font"

            Process {
              id: wifiProc
              command: ["sh", "-c", "
                if command -v nmcli >/dev/null 2>&1; then
                  ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -n 1)
                  if [ -n \"$ssid\" ]; then
                    echo \"$ssid\"
                  else
                    echo \"Disconnected\"
                  fi
                else
                  echo \"N/A\"
                fi
              "]
              running: true
              stdout: StdioCollector {
                onStreamFinished: {
                  let val = this.text ? this.text.trim() : "";
                  if (val !== "") {
                    if (val === "Disconnected" || val === "N/A") {
                      wifiText.text = "Offline";
                      wifiIconText.text = "󰤭";
                    } else {
                      wifiText.text = val.length > 12 ? val.substring(0, 10) + "..." : val;
                      wifiIconText.text = "󰤨";
                    }
                  }
                }
              }
            }

            Timer {
              interval: 5000; running: true; repeat: true
              onTriggered: wifiProc.running = true
            }
          }
        }
      }
    }
  }
}
