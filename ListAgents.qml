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

        Repeater
        {
            model:["En poste","Sur site","Deconnecte"]
            id:repeaterToto
            Rectangle
            {
                width: root.width/3- 100
                height: root.height - generalSpacing - generalPadding
                id: rctgEnregistrant
                color: "#262626"
                //visible: false
                radius: root.width/100
                property int idxStatus: 2-index
                Column
                {
                    Text {
                        id: txtTrie
                        text: qsTr(modelData)
                        color: "#FCFCFC"
                        font.pixelSize: bigFontSize
                        padding: 10
                    }
                    Grid
                    {
                        columns: 3
                        spacing: 6

                        Repeater
                        {
                            model: intNbAgents
                            id:repeaterAgent
                            Agent
                            {
                                id:kawabonga
                                lintIndex : index
                                lintColumnStatus: idxStatus
                            }
                        }
                    }
                }
            }
        }
        Timer
        {
            interval: 2000
            repeat: true
            triggeredOnStart: false

            running: true
            onTriggered:
            {
                //repeaterToto.itemAt(0).reload() ="#FFFFFF";
                repeaterToto.update();

                //repeaterToto.itemAt(2).repeaterAgent.itemAt(0).visible=false;
            }

        }


    }
}

