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

    function updateStatus() {
        lintUserStatus = accInfo.getAgentStatus(lintIndex);
        //console.log("Index : "+lintIndex+" retourne l'Id: "+ lintIdentifiantUser);
        switch (accInfo.getAgentStatus(lintIdentifiantUser))
        {
            case 1:
                state = "Present";
                console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 1)
                    visible = false;
                else
                    visible = true;
                break;
            case 2:
                state = "Enregistrant";
                console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 2)
                    visible = false;
                else
                    visible = true;
                break;
            default:
                state = "Inactif";
                console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 0)
                    visible = false;
                else
                    visible = true;
                break;
        }
    }

    Connections {
        target: myPTMSServer
        onReceivedMessage: {
            // traite le message

            // verifie que le numero de serie en question correspond bien a lintIdentifiantUser
            // si oui verifie le contenu du message
            if (lintIdentifiantUser===accInfo.getAgentId(accInfo.getCoreMessage(message,1)))
            {
                // si c est start lagent va passer de deconnecte a 'sur site' donc
                // ==> met a jour agentStatus + popup
                // si cest recording lagent va passer de 'sur site' a 'en poste
                // ==> met a jour agentStatus + popup
                // si c est okstop il faut mettre a jour les status + popup
                // si c est arrecording il faut mettre a jour les status + popup
                var ltxtMsg = accInfo.getCoreMessage(message,0);
                if ((ltxtMsg==='start')||(ltxtMsg==='recording')||(ltxtMsg==='okstop')||(ltxtMsg==='arrecording'))
                    updateStatus();
            }
            // si c est canistop il faut eventuellement mettre une icone
            // et de toute facon un popup pour donner l autorisation

            // si c est msgread : popup mais rien ici a faire
        }
    }

    onLintIndexChanged:
    {
        nom.text = accInfo.getAgentNomLst(lintIndex);
        lintIdentifiantUser = accInfo.getAgentId(lintIndex);

        updateStatus();

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
