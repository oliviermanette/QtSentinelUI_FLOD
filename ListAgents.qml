import QtQuick 2.0

Grid
{
    property int intNbAgents: 0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    columns: 6
    spacing: 6

    Text {
        id: txtNbAgents
        text: qsTr("Cannot open database !")
    }

    Timer
    {
        id : onStartFunction
        interval: 10
        repeat: false
        triggeredOnStart: true
        running: true
        onTriggered:
        {
            //Initialisation de l affichage
            intNbAgents = accInfo.getNombreAgents();
        }
    }

    Repeater
    {
        model: intNbAgents
        Agent {
            lintIndex : index
        }

    }


}

