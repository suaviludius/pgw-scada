import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: mainWindow
    width: 1200
    height: 720
    visible: true
    title: "PGW MONITORING SYSTEM"

    Material.theme: Material.Dark
    Material.accent: Material.Blue

    // Цвета:
    // бэкграунд: #2b2b2b
    // основа: #3c90a4
    // контрастная основа: #255a66
    // серый мовитон: #3e4556
    // допуск: #3fee85

    // Заголовочная часть с кнопкой подключения к серверу
    header: ToolBar {
        id: header
        height: 60
        Material.background: "#3c90a4"

        RowLayout {
            anchors.fill: parent
            //anchors.margins: 20
            anchors.leftMargin: 5
            anchors.rightMargin: 10
            spacing: 10

            // TODO: Стоит взять образец оформления бокового меню из stepwise-regression
            // и икноки кнопок тоже
            Button {
                id: menuButton
                text: "☰"
                font.pixelSize: 24
                flat: true
                onClicked: {
                    if (drawer.visible) {
                        drawer.close()
                    } else {
                        drawer.open()
                    }
                }
                ToolTip.text: "Меню"
                ToolTip.visible: hovered
            }

            Text {
                text: "PGW Monitoring System"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            Text {
                text: "online"
                font.pixelSize: 15
                font.bold: true
                color: '#3fee85'
                Layout.alignment: Qt.AlignRight
            }

            Button {
                text: '[OFF]'
                flat: true
                ToolTip.text: "Отключиться"
                ToolTip.visible: hovered
            }
        }
    }


    // Выдвижная боковая панель с навигацией
    Drawer {
        id: drawer
        width: 250
        height: parent.height
        //modal: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 8

            Image {
                source: "file:/home/vimero/Projects/pgw-scada/icons/logo.svg"
                width: 140
                height: 60
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                fillMode: Image.PreserveAspectFit
            }

            // NavButton {
            //     text: "Обзор"
            //     //onClicked: stackView.replace(какая-то страничка)
            //     //drawer.close()
            // }

            Item { Layout.fillHeight: true }

            Text {
                text: "v1.0.0"
                color: "#757575"
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
            }
        }

    }
}
