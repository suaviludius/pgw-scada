// InfoRow.qml
import QtQuick
import QtQuick.Layouts

RowLayout{
    id: root
    //height: 20
    Layout.fillWidth: true

    property string label: "Параметр"
    property string icon: ""
    property string value: "значение"
    property color valueColor: mainLightColor

    spacing: 8
    //Layout.alignment: Qt.AlignVCenter

    Text {
        text: root.label
        font.pixelSize: 14
        //Layout.preferredWidth: 120
        //font.bold: true
        color: "white"
    }

    Image {
        source: root.icon
        width: 20
        height: 20
        fillMode: Image.PreserveAspectFit
        visible: root.icon !== ""
    }

    Item {
        //Layout.preferredWidth: 20
        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
    }

    Text {
        text: root.value
        font.pixelSize: 14
        color: valueColor
        font.bold: true
    }
}
