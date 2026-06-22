// Main.qml
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
    readonly property color mainLightColor: "#3c90a4"
    readonly property color mainDarkColor: "#255a66"
    readonly property color onlineColor: "#3fee85"
    readonly property color offlineColor: "#e95349"
    readonly property color menuBgColor: "#2b2b2b"
    readonly property color greyColor: "#3e4556"
    readonly property color versionColor: "#757575"


    // Заголовочная часть с кнопкой подключения к серверу
    header: ToolBar {
        id: header
        height: 60
        Material.background: mainDarkColor

        RowLayout {
            anchors.fill: parent
            //anchors.margins: 20
            anchors.leftMargin: 5
            anchors.rightMargin: 10
            spacing: 5

            // TODO: Стоит взять образец оформления бокового меню из stepwise-regression
            Button {
                id: menuButton
                icon.source: "qrc:/icons/white/align-justify.svg"
                font.pixelSize: 30
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
                id: connectionTxt
                text: connectionBtn.isConnected ? "online" : "offline"
                // text: "online"
                font.pixelSize: 15
                font.bold: true
                color: connectionBtn.isConnected ? onlineColor : offlineColor
                Layout.alignment: Qt.AlignRight
            }

            Button {
                id: connectionBtn
                property bool isConnected: false
                icon.source: isConnected ? "qrc:/icons/white/toggle-right.svg" : "qrc:/icons/white/toggle-left.svg"
                // icon.source: "qrc:/icons/white/toggle-left.svg"
                icon.width: 30
                icon.height: 30
                onClicked: {
                    isConnected = !isConnected
                }
                //text: '[OFF]'
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
                source: "qrc:/logo/small.svg"
                //width: 50
                //height: 60
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.bottomMargin: 20
                //fillMode: Image.PreserveAspectFit
            }

            ItemDelegate { text: "Обзор";           width: parent.width; Layout.fillWidth: true; onClicked: stackView.replace(dashboardPage)}
            ItemDelegate { text: "Активные сессии"; width: parent.width; Layout.fillWidth: true; onClicked: stackView.replace(dashboardPage)}
            ItemDelegate { text: "Журнал CDR";      width: parent.width; Layout.fillWidth: true; onClicked: stackView.replace(dashboardPage)}
            ItemDelegate { text: "Управление";      width: parent.width; Layout.fillWidth: true; onClicked: stackView.replace(dashboardPage)}
            ItemDelegate { text: "Настройки";       width: parent.width; Layout.fillWidth: true; onClicked: stackView.replace(dashboardPage)}

            // Заполнитель пустоты
            Item { Layout.fillHeight: true }

            Text {
                text: "v1.0.0"
                color: versionColor
                font.pixelSize: 10
                Layout.alignment: Qt.AlignHCenter
            }
        }

    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: DashboardPage {
            id: dashboardPage
        }
    }
}
