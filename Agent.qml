import QtQuick 2.7

Column
{
    property int lintIndex: -1
    property int intWidth: 60
    property int lintIdentifiantUser: -1
    property int lintUserStatus:0
    property int lintColumnStatus: 0 // afin qu'il ne soit visible que s'il est dans la colonne correspondant a son status
    property int extension: 28 //angle exprimé en pourcentage %
    property int maxValue:50
    property string arCouleur: "#C00000"
    property int epaisseur: 30
    id:rootAgent

    Canvas{
        id: dessin
        width: intWidth
        height: intWidth

        function displayArc(angle)
        {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = dessin.width / 2;
            var centreY = dessin.height / 2;
            var bordurePT = 2.5;
            if (dessin.width<140)
                bordurePT = 3;

            ctx.beginPath();
            ctx.strokeStyle = arCouleur;
            //ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, dessin.width / bordurePT, -0.5*Math.PI, Math.PI * angle, false);
            //ctx.lineTo(centreX, centreY);
            ctx.lineWidth=(dessin.width / bordurePT)*epaisseur/100;
            ctx.lineCap="round";
            ctx.stroke();
            requestPaint();
        }

        function convertExtensionToAngle(valeurExtension)
        {
            return (((valeurExtension/maxValue*100) -25)/50.0)
        }

        onPaint:
        {
            if (rootAgent.state == "Enregistrant"){
                displayArc(convertExtensionToAngle(extension));
            }
            requestPaint();
        }

        Image
        {
            id:centralIMG
            source: "Image1.png"
            width: intWidth/2
            fillMode: Image.PreserveAspectFit
            x: dessin.width/2-width/2
            y:dessin.height/2-height/2
            visible:false
        }

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


    onExtensionChanged:
    {
        dessin.requestPaint();
    }

    Text {
        id: nom
        text: qsTr("inconnu")
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        width: intWidth
        height: 10
        color: "#FCFCFC"
    }

    function updateStatus() {
        lintUserStatus = accInfo.getAgentStatus(lintIndex);
        //console.log("Index : "+lintIndex+" retourne l'Id: "+ lintIdentifiantUser);
        switch (accInfo.getAgentStatus(lintIdentifiantUser))
        {
            case 1:
                state = "Present";
                //console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 1)
                    visible = false;
                else{
                    visible = true;
                    timerAgent.interval = 60000;
                    //extension = 37;
                }
                break;
            case 2:
                state = "Enregistrant";
               //console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 2)
                    visible = false;
                else{
                    extension = accInfo.getSessionRythmeMoyenMVT(accInfo.getCurrentSessionId(lintIdentifiantUser));
                    if (extension<0)
                        extension = 0;
                    dessin.displayArc(dessin.convertExtensionToAngle(extension));
                    dessin.requestPaint();
                    visible = true;
                    timerAgent.interval = 10000;
                    console.log(extension);

                }
                break;
            default:
                state = "Inactif";
                //console.log(state + lintColumnStatus);
                if (lintColumnStatus!= 0)
                    visible = false;
                else{
                    visible = true;
                    timerAgent.interval = 120000;
                }
                break;
        }
    }
    Timer
    {
        interval: 120000
        id:timerAgent
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            updateStatus();
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
    Connections{
        target: myPTMSServer
        onAgentUpdater:{
            updateStatus();
            //console.log("UPDATE tataa")
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
            PropertyChanges {
                target: centralIMG
                width: intWidth
                x: 0
                y:0
                visible:true
            }
        },
        State {
            name: "Enregistrant"
            PropertyChanges {
                target: centralIMG
                width: intWidth/2
                x: dessin.width/2-width/2
                y:dessin.height/2-height/2
                visible:true
            }
        },
        State {
            name: "Inactif"
            PropertyChanges {
                target: centralIMG
                width: intWidth
                x: 0
                y:0
                visible:true
            }
        }
    ]
}
