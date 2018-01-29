import QtQuick 2.7

Rectangle {
    property alias mouseArea: mouseArea
    property alias textEdit: textEdit

    width: 360
    height: 360
    color: "yellow"


    Path {
        startX: 0; startY: 100
        PathLine { x: 200; y: 100 }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent


        Item {
            id: item1
            x: 86
            y: 102
            width: 200
            height: 200
            transformOrigin: Item.Center
            rotation: 0



        }




    }

    TextEdit {
        id: textEdit
        color: "#f11b1b"
        text: qsTr("Enter some text...")
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        Rectangle {
            anchors.fill: parent
            anchors.margins: -10
            color: "transparent"
            border.width: 1
        }
    }



}
