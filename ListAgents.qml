import QtQuick 2.7

Item
{
    property int intNbAgents: 0
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
            var lintNbAgents = accInfo.getNombreAgents();
            if (lintNbAgents>0)
                intNbAgents = lintNbAgents;
            else
                intNbAgents = 0;
        }
    }

    Row
    {
        spacing: 6
        padding: 3
        Rectangle
        {
            width: root.width/3
            height: root.height - generalSpacing - generalPadding
            id: rctgEnregistrant
            color: "#262626"
            radius: root.width/100
            Grid
            {

                columns: 3
                spacing: 6
                anchors.fill: parent

                Repeater
                {
                    model: intNbAgents
                    Agent {
                        lintIndex : index
                        lintColumnStatus: 2
                    }
                }
            }
        }
        Rectangle
        {
            width: root.width/3
            height: root.height - generalSpacing - generalPadding
            id: rctgPresent
            color: "#262626"
            radius: root.width/100
            Grid
            {

                columns: 3
                spacing: 6
                anchors.fill: parent

                Repeater
                {
                    model: intNbAgents
                    Agent {
                        lintIndex : index
                        lintColumnStatus: 1
                    }
                }
            }
        }
        Rectangle
        {
            width: root.width/3
            height: root.height - generalSpacing - generalPadding
            id: rctgInactif
            color: "#262626"
            radius: root.width/100
            Grid
            {

                columns: 3
                spacing: 6
                anchors.fill: parent

                Repeater
                {
                    model: intNbAgents
                    Agent {
                        lintIndex : index
                        lintColumnStatus: 0
                    }
                }
            }
        }
        Image {
            id: addNewAgent
            source: "+.jpg"
        }
    }






}

