// Dashboard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs


Page {
    id: dashboardPage
    background: Rectangle {
        color: "#123345"
        }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        // Строка с метриками
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            MetricCard {
                icon: "qrc:/icons/white/users.svg"
                title: "Активные сессии"
                value: 11
            }

            MetricCard {
                icon: "qrc:/icons/white/trello.svg"
                title: "Сессий сегодня"
                value: 22
            }

            MetricCard {
                icon: "qrc:/icons/white/alert-octagon.svg"
                title: "Отклоненные"
                value: 33
            }

            MetricCard {
                icon: "qrc:/icons/white/activity.svg"
                title: "Нагрузка"
                value: 44
            }
        }

        // График активности сервера
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 300
            radius: 8
            color: "#1a2a3a"  // Цвет фона графика


            GraphsView {
                id: sessionGraph
                anchors.fill: parent
                anchors.rightMargin: 16
                anchors.topMargin: 16
                antialiasing: true
                //marginLeft: 0.8

                // Настройка внешнего вида
                theme: GraphsTheme {

                    backgroundVisible: false
                    plotAreaBackgroundVisible : false
                    gridVisible : true
                    //labelsVisible : true

                    axisY.mainColor: "#E6E6E6"
                    axisX.mainColor: "#E6E6E6"

                    labelTextColor: greyColor
                    axisX.labelTextColor: "#E6E6E6"
                    axisY.labelTextColor: "#E6E6E6"

                    labelFont.pointSize: 14
                    axisXLabelFont.pointSize: 12
                    axisYLabelFont.pointSize: 12

                }

                // Горизонтальная ось
                ValueAxis {
                    id: axisX
                    min: 0
                    max: 60
                    labelFormat: "%d"
                    titleText: "Cекунд назад"
                    //lineVisible: false
                }

                // Вертикальная ось
                ValueAxis {
                    id: axisY
                    min: 0
                    max: 1000
                    titleText: "Aктивные сессии"
                    //lineVisible: false
                }


                // Линейный график
                //TODO: может стоить сделать bar?
                LineSeries {
                    axisX: axisX
                    axisY: axisY
                    color: mainLightColor
                    width: 2
                }
            }
        }

        // Нижний ряд окна
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            // Лента последних событий
            Rectangle{
                Layout.fillWidth: true
                //Layout.fillHeight: true
                Layout.preferredHeight: 250
                color: greyColor
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    Text{
                        text: "Последние CDR записи"
                        font.bold: true
                        font.pixelSize: 14
                        color: "#E6E6E6"
                    }

                    // Таблица CDR записей 
                    ListView{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: backend.recentCdr

                        delegate: Rectangle {
                            width: parent.width
                            height: 30
                            color: "#F8F8F8"
                            // Можно попробовать так, но пока визульно - загадка
                            //color: index % 2 === 0 ? "#F8F8F8" : "transparent"

                            RowLayout {
                                anchors.fill: parent

                                Text {
                                    text: model.timestamp
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 70
                                }

                                Text {
                                    text: model.imsi
                                    font.pixelSize: 11
                                    Layout.preferredWidth: 100
                                }

                                Text {
                                    text: model.action
                                    font.pixelSize: 11
                                    color: model.action === "created" ? successColor :
                                           model.action === "rejected" ? errorColor : warningColor
                                }
                            }

                        }
                    }
                }
            }

            // Информация о сервере
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                color: greyColor
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Системная информация"
                        font.bold: true
                        font.pixelSize: 14
                        color: "#E6E6E6"
                    }

                    InfoRow { label: "Версия:"; value: "v1.2.0" }
                    InfoRow { label: "Uptime:"; value: "3д 14ч 22м" }
                    InfoRow {
                        label: "БД статус:"
                        value: backend.dbConnected ? "Connected" : "Disconnected"
                        valueColor: backend.dbConnected ? onlineColor : offlineColor
                    }
                    InfoRow { label: "TCP порт:"; value: "9090" }
                    InfoRow { label: "UDP порт:"; value: "9000" }
                    InfoRow { label: "HTTP порт:"; value: "8080" }
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: backend.requestStats()
    }
}

