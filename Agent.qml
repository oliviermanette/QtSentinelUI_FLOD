import QtQuick 2.0

Column
{
    property int lintIndex: -1
    property int intWidth: 80
    property int lintIdentifiantUser: -1
    property int lintUserStatus:0
    property int lintColumnStatus: 0 // afin qu'il ne soit visible que s'il est dans la colonne correspondant a son status
    Image
    {
        source: "Image1.jpg"
        width: intWidth
        fillMode: Image.PreserveAspectFit
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                root.identifiantUser = lintIdentifiantUser;
                console.log("Identifiant demandé : "+ root.identifiantUser);

                nom.color = "yellow";
                conteneurGeneral.state = "DetailAgent";

                // Ici il doit vérifier quelle est la session de l'agent en question pour le recopier dans agentstate
                switch (accInfo.getAgentStatus(lintIdentifiantUser))
                {
                    case 1:
                        root.detailAgentState = "Present";
                        state = "Present";
                        break;
                    case 2:
                        root.detailAgentState = "Enregistrant";
                        state = "Enregistrant";
                        break;
                    default:
                        root.detailAgentState = "Inactif";
                        state = "Inactif";
                        break;
                }
                voirdetailAgent.lintUpdate = voirdetailAgent.lintUpdate + 1;
            }
        }
    }
    Text {
        id: nom
        text: qsTr("inconnu")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: intWidth
        height: 20
        color: "#FCFCFC"
    }

    Connections {
        target: myPTMSServer
        onReceivedMessage: {
            //qmlString = signalString
            //voirlistAgents.update();
            //voirdetailAgent.update();
            //voirlistAgents.repeaterToto.itemAt(0).color = "#FFFFFF"
            //kawabonga.lintIndex=1;
            visible = false;

            //infoPopUp.text = message;
            //popup.open();
        }
    }

    onLintIndexChanged:
    {
        nom.text = accInfo.getAgentNomLst(lintIndex);
        lintIdentifiantUser = accInfo.getAgentId(lintIndex);
        lintUserStatus = accInfo.getAgentStatus(lintIndex);
        //console.log("Index : "+lintIndex+" retourne l'Id: "+ lintIdentifiantUser);
        switch (accInfo.getAgentStatus(lintIdentifiantUser))
        {
            case 1:
                state = "Present";
                visible = false;
                if (lintColumnStatus!= 1)
                    visible = false;
                else
                    visible = true;
                break;
            case 2:
                state = "Enregistrant";
                if (lintColumnStatus!= 2)
                    visible = false;
                else
                    visible = true;
                break;
            default:
                state = "Inactif";
                if (lintColumnStatus!= 0)
                    visible = false;
                else
                    visible = true;
                break;
        }
    }
    states: [
        State {
            name: "Present"
        },
        State {
            name: "Enregistrant"
        },
        State {
            name: "Inactif"
        }
    ]
}
