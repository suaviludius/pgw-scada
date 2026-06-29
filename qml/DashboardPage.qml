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
                value: backend.activeSessions
            }

            MetricCard {
                icon: "qrc:/icons/white/trello.svg"
                title: "Сессий сегодня"
                value: backend.totalSessions
            }

            MetricCard {
                icon: "qrc:/icons/white/alert-octagon.svg"
                title: "Отклоненные"
                value: backend.rejectedSessions
            }

            MetricCard {
                icon: "qrc:/icons/white/activity.svg"
                title: "Просроченные"
                value: backend.expiredSessions
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
                Layout.preferredWidth: 200
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

                    Rectangle {
                        Layout.fillWidth: true
                        height: 25
                        color: "#2a3a4a"
                        radius: 2

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8

                            Text {
                                text: "Timestamp"
                                font.pixelSize: 11
                                font.bold: true
                                color: versionColor
                                Layout.preferredWidth: 200
                            }
                            Text {
                                text: "IMSI"
                                font.pixelSize: 11
                                font.bold: true
                                color: versionColor
                                Layout.preferredWidth: 200
                            }
                            Text {
                                text: "Action"
                                font.pixelSize: 11
                                font.bold: true
                                color: versionColor
                                Layout.preferredWidth: 200
                            }
                        }
                    }

                    // Таблица CDR записей
                    ListView{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredHeight: 180
                        // Обрезаем всё, что выходит за границы
                        // (без него при прокрутке вылезает за рамки ListView)
                        clip: true
                        model: backend.recentCdr

                        delegate: Rectangle {
                            width: parent.width
                            height: 30
                            // Все чередуют цвета, и мы будем!
                            color: index % 2 === 0 ? greyColor : mainDarkColor

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8

                                Text {
                                    text: modelData.timestamp
                                    font.pixelSize: 14
                                    Layout.preferredWidth: 200
                                    color: "#E6E6E6"
                                }

                                Text {
                                    text: modelData.imsi
                                    font.pixelSize: 14
                                    Layout.preferredWidth: 200
                                    color: "#E6E6E6"
                                }

                                Text {
                                    text: modelData.action
                                    font.bold: true
                                    font.pixelSize: 14
                                    Layout.preferredWidth: 200
                                    // color: "#E6E6E6"
                                    color: modelData.action === "CREATED" ? onlineColor : offlineColor
                                }
                            }

                        }
                    }
                }
            }

            // Информация о сервере
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 100
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

                    InfoRow { label: "Версия:\t"; value: "v1.2.0" }
                    InfoRow { label: "Uptime:\t"; value: backend.uptimeSeconds + " cекунд" } // TODO: нужно сделать формат: "3д 14ч 22м"
                    InfoRow {
                        label: "БД статус:\t"
                        value: backend.dbConnected ? "Connected" : "Disconnected"
                        valueColor: backend.dbConnected ? onlineColor : offlineColor
                    }
                    InfoRow { label: "TCP порт:\t"; value: "9090" }
                    InfoRow { label: "UDP порт:\t"; value: "9000" }
                    InfoRow { label: "HTTP порт:\t"; value: "8080" }
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: backend.requestStatistics(), backend.requestCdr()
    }
}

