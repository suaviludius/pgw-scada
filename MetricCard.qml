// MetricCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle{
    id: root
    height: 120
    color: greyColor
    radius: 8

    property string title: "Метрика"
    property string icon: 'qrc:/icons/white/clipboard.svg'
    property int value: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        RowLayout{
            spacing: 16
            Layout.fillWidth: true
            Image {
                source: root.icon
            }
            Text {
                text: root.title
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }

        RowLayout{
            //Layout.alignment: Qt.AlignHCenter
            Text {
                text: root.value.toString()
                font.pixelSize: 23
                color: mainLightColor
                font.bold: true
            }
            Text {
                // text: 
                // font.pixelSize: 23
                // color: mainLightColor
                // font.bold: true
                // Layout.fillWidth: true
            }
        }
    }
}