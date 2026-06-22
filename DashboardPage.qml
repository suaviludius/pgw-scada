// Dashboard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    id: dashboardPage
    background: Rectangle {
        color: "#123345"
        }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            MetricCard {
                icon: "qrc:/icons/white/users.svg"
                title: "Активные сессии"
                color: greyColor
                Layout.fillWidth: true
            }

            MetricCard {
                icon: "qrc:/icons/white/trello.svg"
                title: "Сессий сегодня"
                color: greyColor
                Layout.fillWidth: true
            }

            MetricCard {
                icon: "qrc:/icons/white/alert-octagon.svg"
                title: "Отклоненные"
                color: greyColor
                Layout.fillWidth: true
            }

            MetricCard {
                icon: "qrc:/icons/white/activity.svg"
                title: "Нагрузка"
                color: greyColor
                Layout.fillWidth: true
            }
        }
    }
}