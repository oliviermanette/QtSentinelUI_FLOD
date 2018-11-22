import QtQuick 2.7
import QtQuick.Controls 2.3
import QtCharts 2.2
Row
{
    id:detailAgentMain
    states: [
        State {
            name: "Inactif"
            PropertyChanges {
                target: btnContact
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: btnStatus
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:columIdentite
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:affichageNombreExtension
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:columnDisplay
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:lblStatus
                text:"non connecté"
                font.bold: false
                color: "white"
            }
            PropertyChanges {
                target:lightMontreGauche
                color: "red"
            }
            PropertyChanges {
                target:lightMontreDroit
                color: "red"
            }
            PropertyChanges {
                target:columnListSessions
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:columnDetailSessions
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: btnTotal
                visible:false
                enabled: false
            }
        },
        State {
            name: "Present"
            PropertyChanges {
                target: btnContact
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: btnStatus
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: lblbtnStatus
                text: "Commencer"
            }
            PropertyChanges {
                target:columIdentite
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:columnListSessions
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:columnDetailSessions
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:affichageNombreExtension
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:columnDisplay
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:lblStatus
                text:"Connecté"
                font.bold: true
                color: "green"
            }
            PropertyChanges {
                target: btnTotal
                visible:false
                enabled: false
            }
        },
        State {
            name: "Enregistrant"
            PropertyChanges {
                target: btnContact
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: btnStatus
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: lblbtnStatus
                text: "Arreter !"
            }
            PropertyChanges {
                target:columIdentite
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:affichageNombreExtension
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:columnDisplay
                visible:true
                enabled:true
            }
            PropertyChanges {
                target:lblStatus
                text:"Enregistrement ..."
                font.bold: true
                color: "red"
            }
            PropertyChanges {
                target:columnListSessions
                visible:false
                enabled:false
            }
            PropertyChanges {
                target:columnDetailSessions
                visible:false
                enabled:false
            }
            PropertyChanges {
                target: btnTotal
                visible:true
                enabled: true
            }
        }
    ]

    padding: generalPadding
    spacing: generalSpacing
    property int lintUpdate: 0
    property int intNbSessions: 0
    property int intMaxSessions: 0
    property int constMaxSession:12

    ListModel{
        id: mnuDroitModel
    }

    onLintUpdateChanged: {// ça change au moment où on clique sur l'icone
        switch (accInfo.getAgentStatus(identifiantUser)){
            case 0:
                detailAgentMain.state = "Inactif";
                break;
            case 1:
                detailAgentMain.state = "Present";
                break;
            case 2:
                detailAgentMain.state = "Enregistrant";
                break;
            default:
                detailAgentMain.state = "Inactif";
        }

        //detailAgentMain.state = "Present";
        // Initialisation de l affichage
        var lintNbSessions = accInfo.getNombreSessions(identifiantUser);
        console.log("Mise a jour du nombre de sessions :")
        console.log(lintNbSessions);
        intNbSessions = lintNbSessions;
        columnDetailSessions.visible = false;

        serialNoD = accInfo.getMontreSN(identifiantUser,0);//" - "
        serialNoG = accInfo.getMontreSN(identifiantUser);
        if (serialNoD=="-9999")
            lightMontreDroit.color = "red";
        else if (accInfo.getWatchStatus(serialNoD))
            lightMontreDroit.color = "lime";
        else
            lightMontreDroit.color = "red";
        if (serialNoG=="-9999")
            lightMontreGauche.color = "red";
        else if (accInfo.getWatchStatus(serialNoG))
            lightMontreGauche.color = "lime";
        else
            lightMontreGauche.color = "red";

        //Ajoute la liste des montres de la BDD
        var textMenu="";

        mnuDroitModel.clear();
        for (var i=0;i<accInfo.getNbMontres();i++) {
            textMenu = accInfo.getNextWatch();
            //console.log("Menu = "+textMenu);
            mnuDroitModel.append({"name":textMenu});
        }
        //console.log(identifiantUser);

        lblAge.text = accInfo.getIndividuAge(identifiantUser);
        lblPrenom.text = accInfo.getDBValue("identites","Prenom",identifiantUser);
        lblNom.text = accInfo.getDBValue("identites","Nom",identifiantUser);//"COYOTTE"

        switch (state){
            case "Present":
                if (lintNbSessions>0){
                    intNbSessions = lintNbSessions;
                    if (lintNbSessions>=constMaxSession)
                        intMaxSessions = constMaxSession
                    else
                        intMaxSessions = intNbSessions;
                }
                else{
                    intNbSessions = 0;
                    intMaxSessions = 0;
                }
                break;
            case "Inactif":
                if (lintNbSessions>0){
                    intNbSessions = lintNbSessions;
                    if (lintNbSessions>=constMaxSession)
                        intMaxSessions = constMaxSession
                    else
                        intMaxSessions = intNbSessions;
                    //console.log(intNbSessions);
                }
                else{
                    intNbSessions = 0;
                    intMaxSessions = 0;
                }
                break;
            case "Enregistrant":

                //accInfo.autoreadFile(serialNoG,serialNoD);
                if (gbolTotal)
                    columnDisplay.displayTotalValues();
                else
                    columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                tpsTravail.extension = accInfo.getDureeTotaleEnregistrementEnMinutes();
                break;
        }
    }

    Rectangle{
        width: root.width/4.728
        height: root.height - generalSpacing - generalPadding
        id: columIdentite
        color: "#262626"
        radius: root.width/150
        Column{
            padding: generalPadding
            spacing : extendedSpacing
            Row{
                Text{
                    id: titleID
                    text: "Identité"
                    font.bold: true
                    font.pixelSize: 0
                    horizontalAlignment: Text.AlignHCenter
                    color: "#FCFCFC"
                }
                Rectangle{
                    height: 14
                    width: 20
                    color: "#262626"
                }
                Button{
                    id  : btnBackToList
                    text: "< Retour "

                    background: Rectangle {
                        color:"#DCECF2"
                        id:btnBack
                        radius: 3
                    }
                    onPressed:{
                        btnBack.color = "yellow"
                    }
                    onReleased:{
                        btnBack.color = "#DCECF2"
                        conteneurGeneral.state = "ListAgents";
                        identifiantUser = 0;
                    }
                }
            }
            Image{
                source: "Image1.png"
                width: columIdentite.width /2.5
                fillMode: Image.PreserveAspectFit
            }
            Row{
                spacing: extendedSpacing
                Text{
                    text: "Nom"
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text{
                    id : lblNom
                    text: "Doe"
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }
            Row{
                spacing: extendedSpacing
                Text {
                    text: "Prénom"
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text{
                    id : lblPrenom
                    text: "John"
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }
            Row{
                spacing: extendedSpacing
                Text{
                    text: "Age : "
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text{
                    id: lblAge
                    text: ""
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }

            Button{
                id:btnContact
                contentItem: Label {
                    //color: "white"
                    text: " Contacter "
                    font.bold: true
                    font.pixelSize: smallFontSize
                }

                background: Rectangle {
                    color:"#DCECF2"
                    id:toto
                    radius: 3
                }
                onPressed:{
                    toto.color = "yellow"
                    accInfo.controlEngine(1);
                }
                onReleased:{
                    toto.color = "#DCECF2"
                    console.log(accInfo.controlEngine(0));
                }
            }
            Column{
                spacing: 20
                Text{
                    id: lblStatus
                    text: ""
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
                Button{
                    id:btnStatus
                    contentItem: Label {
                        id:lblbtnStatus
                        //color: "white"
                        text: " _ "
                        font.bold: true
                        font.pixelSize: smallFontSize
                    }
                    background: Rectangle {
                        color:"#DCECF2"
                        id:titi
                        radius: 3
                    }
                    onPressed:{
                        switch (detailAgentMain.state){
                            case "Inactif":
                                //console.log("here inactive");
                                //si la montre n'est pas branche on ne peut rien faire
                                break;
                            case "Present":
                                //console.log("here present");
                                if (accInfo.setSessionMustStart(identifiantUser))//setSessionWouldStop
                                    lblbtnStatus.text = "Envoye ...";
                                break;
                            case "Enregistrant":
                                //console.log("here enregistrant");
                                if (accInfo.setSessionWouldStop(identifiantUser))//
                                    lblbtnStatus.text = "Envoye ...";
                                break;
                        }
                        titi.color = "yellow";
                    }
                    Connections {
                        target: myPTMSServer
                        onReceivedMessage: {
                            // infoPopUp.text = message;
                            // popup.open();
                            // if (message==)
                            // var lblbtnStatusMSG = message;
                            // lblbtnStatusMSG
                            // lblbtnStatus.text.toString()
                            if (myPTMSServer.isOKStop(message,serialNoD,serialNoG )){
                                lblbtnStatus.text = "Demarre !";
                                detailAgentMain.state = "Present";
                            }
                            else if (myPTMSServer.isRecording(message,serialNoD,serialNoG )){
                                lblbtnStatus.text = "Arrete !";
                                detailAgentMain.state = "Enregistrant";
                            }
                        }
                    }
                    onReleased:{
                        titi.color = "#DCECF2"
                    }
                }
            }

            Column{
                spacing: extendedSpacing
                Text{
                    text: "Montre Gauche : "+serialNoG
                    font.bold: true
                    font.pixelSize: smallFontSize
                    color: "#FCFCFC"
                }
                Row{
                    spacing: 40
                    Button {
                        id: btnMnuMontreGauche
                        text: serialNoG
                        background: Rectangle {
                            color:"#DCECF2"
                            radius: 3
                        }
                        onPressed:{
                            toto.color = "yellow"
                        }
                        onReleased:{
                            toto.color = "#DCECF2"
                        }
                        onClicked: {
                            montreGaucheSelection.addItem(qsTr("item3"));
                            montreGaucheSelection.open();
                        }

                        Menu{
                            id: montreGaucheSelection
                            title: serialNoG
                            Repeater {
                                id: idInstGauche
                                    model: mnuDroitModel
                                    MenuItem {
                                        text: model.name
                                        onTriggered: {
                                            accInfo.setAgentWatch(identifiantUser,model.name,true);
                                            serialNoG = accInfo.getMontreSN(identifiantUser);
                                        }
                                    }
                                }
                        }
                    }
                    Light{
                        id:lightMontreGauche
                    }
                }
            }
            Column{
                spacing: extendedSpacing
                Text{
                    text: "Montre Droite : "+ serialNoD
                    font.bold: true
                    font.pixelSize: smallFontSize
                    color: "#FCFCFC"
                }
                Row{
                    spacing: 40
                    Button {
                        id: btnMnuMontreDroite
                        text: serialNoD
                        background: Rectangle{
                            color:"#DCECF2"
                            radius: 3
                        }
                        onPressed:{
                            toto.color = "yellow"
                        }
                        onReleased:{
                            toto.color = "#DCECF2"
                        }
                        onClicked:{
                            montreDroiteSelection.open();
                        }

                        Menu{
                            id: montreDroiteSelection
                            title: serialNoD

                            Repeater {
                                id: idInstDroit
                                    model: mnuDroitModel
                                    MenuItem {
                                        text: model.name

                                        onTriggered: {
                                            accInfo.setAgentWatch(identifiantUser,model.name,false);
                                            serialNoD = accInfo.getMontreSN(identifiantUser,0);
                                        }
                                    }
                                }
                        }
                    }
                    Light{
                        id:lightMontreDroit
                    }
                }
            }

            Button
            {
               id       : btnTotal
               text     : "Moyenne"
               onClicked:
                   if (gbolTotal)
                   {
                       gbolTotal = false;
                       btnTotal.text = "Moyenne";
                       columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                   }
                   else
                   {
                       gbolTotal = true;
                       btnTotal.text = "Detail";
                       columnDisplay.displayTotalValues();
                   }
               background: Rectangle {
                   color:"#DCECF2"
                   id:btnBackTotal
                   radius: 3
               }
               onPressed:
               {
                   btnBackTotal.color = "yellow"
               }
               onReleased:
               {
                   btnBackTotal.color = "#DCECF2"
               }
            }
/*          Button
            {
               text: "Quitter"
               onClicked:
                   Qt.quit()
            }*/
        }
    }

    ListSessions{
        id:columnListSessions
    }

    Rectangle{
        id: columnDetailSessions
        width: root.width/2.68
        height: root.height - generalSpacing - generalPadding
        color: "#262626"
        radius: root.width/150
        property int lintSessionId: -2
        property int lintIndex: -1
        property int lintIndividu:-1
        property int lintConvenientTemp: 0

        onLintSessionIdChanged: {
            columnDetailSessions.visible = true;
            dtlSessionDate.text = accInfo.getSessiondDate(lintIndividu, lintIndex);
            dtlSessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintIndex);
            sumATSession.text = accInfo.getSessionTotalMVT(lintSessionId);
            sumATSessionG.text = accInfo.getSessionTotalMVT(lintSessionId, 1);
            //var lfltRythmeMvt = accInfo.getSessionRythmeMoyenMVT(lintSessionId)
            lintConvenientTemp = accInfo.getSessionRythmeMoyenMVT(lintSessionId);
            rythmATSession.text = " ("+lintConvenientTemp.toString()+" at/min) ";
            lintConvenientTemp = accInfo.getSessionRythmeMoyenMVT(lintSessionId,1);
            rythmATSessionG.text = " ("+lintConvenientTemp.toString()+"/min) ";
            nbobjettriesSession.extension = accInfo.getSessionTotalObjets(lintSessionId);

            nbchargesLourdesSession.extension = accInfo.getSessionTotalCharges(lintSessionId);
            repetitiviteSession.extension = accInfo.getSessionMeanRepetitivite(lintSessionId);
            lintConvenientTemp = accInfo.getSessionMeanOCRA(lintSessionId)*10;
            meanOCRASession.text = lintConvenientTemp / 10.0;
            lintConvenientTemp = accInfo.getSessionMeanOCRA(lintSessionId,1)*10;
            meanOCRASessionG.text = "(G: "+lintConvenientTemp / 10.0 +")";
            /*
            Vert    :   < 2,2       Pas de risque
            Jaune   :   2,3 - 3,5   Risque faible, moins du double que pour la case verte
            Rouge   :   > 3,5       Risque plus de deux fois plus grand que pour la case verte */
            if ((lintConvenientTemp / 10.0)<2.2){
                meanOCRASession.color = "green";
                meanOCRASessionG.color = "green";
               // valeursOCRA.color =  "green";
                //axisYOCRA.color=  "green";
            }
            else if ((lintConvenientTemp / 10.0)<3.5){
                meanOCRASession.color = "orange";
                meanOCRASessionG.color = "orange";
                //valeursOCRA.color =  "orange";
                //axisYOCRA.color=  "orange";
            }
            else{
                meanOCRASession.color = "red";
                meanOCRASessionG.color = "red";
                //valeursOCRA.color =  "red";
                //axisYOCRA.color=  "red";
            }
            axisYOCRA.color=  "blue";
            valeursOCRA.color = "blue";

            lintConvenientTemp = accInfo.getSessionMeanRisque(lintSessionId)*10;
            meanRiskSession.text = lintConvenientTemp / 10.0;
            lintConvenientTemp = accInfo.getSessionMeanRisque(lintSessionId,1)*10;
            meanRiskSessionG.text = "(G: "+lintConvenientTemp / 10.0+")";
            if ((lintConvenientTemp / 10.0)<33){
                avisRisque.color= "green";
                meanRiskSession.color = "green";
                meanRiskSessionG.color = "green";
                avisRisque.text = " Risque nul ou tres faible ";
                axisYtms.max = 33;
                valeursTMS.color= "green";
                valeursAccAT.color = "green";
                axisYtms.color= "green";
            }
            else if ((lintConvenientTemp / 10.0)<67){
                meanRiskSession.color = "orange";
                meanRiskSessionG.color = "orange";
                avisRisque.color= "orange";
                avisRisque.text = " Risque moderé ";
                axisYtms.max = 67;
                valeursTMS.color= "orange";
                valeursAccAT.color = "orange";
                axisYtms.color= "orange";
            }
            else{
                meanRiskSession.color = "red";
                meanRiskSessionG.color = "red";
                avisRisque.color= "red";
                avisRisque.text = " Risque important, prendre des mesures ";
                axisYtms.max = 100;
                valeursTMS.color= "red";
                valeursAccAT.color = "red";
                axisYtms.color= "red";
            }
            valeursAccATG.style=  2;
            meanRiskSession.text = meanRiskSession.text + "%";

            valeursAccAT.clear();
            valeursAccATG.clear();
            valeursOCRA.clear();
            valeursTMS.clear();
            lintConvenientTemp = accInfo.getSessionNbEnregistrementsMinutes(lintSessionId);
            if (lintConvenientTemp<accInfo.getSessionNbEnregistrementsMinutes(lintSessionId,1))
                lintConvenientTemp=accInfo.getSessionNbEnregistrementsMinutes(lintSessionId,1);
            axisXOCRA.max = lintConvenientTemp;
            axisXat.max = lintConvenientTemp;
            axisXtms.max = lintConvenientTemp;
            var iNb = 0;
            for (var i=0;i<lintConvenientTemp;i++)
            {
                valeursAccAT.append(Number(i),accInfo.getSessionValueATParMinute(lintSessionId,i));
                valeursAccATG.append(Number(i),accInfo.getSessionValueATParMinute(lintSessionId,i,1));
                valeursOCRA.append(Number(i),accInfo.getSessionValueOCRAParMinute(lintSessionId,i));
                valeursTMS.append(Number(i),accInfo.getSessionValueRiskParMinute(lintSessionId,i));
            }
        }

        Column{
            id: contenuDetailSession
            padding: 4
            Row{
                Text{
                    text:"Session du "
                    color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    id: dtlSessionDate
                    text: "-11"//columnDetailSessions.lintSessionId.toString()
                    color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    //font.bold: true
                }
                Text{
                    text:" Durée : "
                    color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    id: dtlSessionDuree
                    text: qsTr("45 min.")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                }
            }
            Rectangle{
                height: 4
                width: 100
                color: "#262626"
            }
            Row{
                Text {
                    text: qsTr("Nombre d'Actions Techniques :")
                    color: "#DCECF2"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
            }

            ChartView{
                //y: affichageNombreExtension.y
                id: chrtViewNbActions
                width: 230
                height: 100
                theme: ChartView.ChartThemeDark
                antialiasing: true
                margins.top: 0
                margins.left:0
                margins.right:0
                margins.bottom: 0
                legend.visible:false/**/

                ValueAxis
                {
                    id: axisYat
                    min:0
                    max:20
                }
                ValueAxis
                {
                    id:axisXat
                    min:0
                    max:10
                }
                LineSeries
                {
                    id: valeursAccAT
                    axisY: axisYat
                    axisX:axisXat
                    name: "AT"
                }
                LineSeries
                {
                    id: valeursAccATG
                    axisY: axisYat
                    axisX:axisXat
                    name: "ATG"

                }
            }
            Row{
                Text {
                    text: qsTr("Total : ")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                    //font.bold: true
                }
                Text {
                    id: sumATSession
                    text: qsTr("892")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize+2
                    font.bold: true
                }
                Text {
                    id: rythmATSession
                    text: qsTr(" (20/min)")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize+2
                    font.bold: true
                }
                Text {
                    text: qsTr("Gauche : ")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                    //font.bold: true
                }
                Text {
                    id: sumATSessionG
                    text: qsTr("892")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize+2
                    font.bold: true
                }
                Text {
                    id: rythmATSessionG
                    text: qsTr(" (20/min)")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize+2
                    font.bold: true
                }
            }
            Rectangle{
                height: 4
                width: 100
                color: "#262626"
            }
            Text {
                text: qsTr("Risques TMS et indice OCRA :")
                color: "#DCECF2"
                font.pixelSize: fontSize//bigFontSize
                font.bold: true
            }
            ChartView{
                //y: affichageNombreExtension.y
                id: chrtViewRisquesTMS
                width: 230
                height: 100
                theme: ChartView.ChartThemeDark
                antialiasing: true
                margins.top: 0
                margins.left:0
                margins.right:0
                margins.bottom: 0
                legend.visible:false

                ValueAxis
                {
                    id: axisYtms
                    min:0
                    max:33
                }
                ValueAxis
                {
                    id:axisXtms
                    min:0
                    max:10
                }
                ValueAxis
                {
                    id: axisYOCRA
                    min:0
                    max:10
                }
                ValueAxis
                {
                    id:axisXOCRA
                    min:0
                    max:10
                }
                LineSeries
                {
                    id: valeursOCRA
                    axisY: axisYOCRA
                    axisX:axisXOCRA
                    name: "OCRA"

                }
                LineSeries
                {
                    id: valeursTMS
                    axisY: axisYtms
                    axisX:axisXOCRA
                    name: "Risque"
                }
            }
            Row{
                Text {
                    text: qsTr("OCRA : ")
                    //color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                    color: "#5a6fd7"
                }
                Text {
                    id: meanOCRASession
                    text: qsTr("2.8 ")
                    color: "red"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }

                Text {
                    id: meanOCRASessionG
                    text: qsTr("2.8 ")
                    color: "red"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    text: qsTr("    ")
                    //color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                    color: "#5a6fd7"
                }

                Text {
                    text: qsTr("  Risque : ")
                    color: "#FCFCFC"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    id: meanRiskSession
                    text: qsTr("72% ")
                    color: "pink"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    id: meanRiskSessionG
                    text: qsTr("72% ")
                    color: "pink"
                    font.pixelSize: fontSize//bigFontSize
                    font.bold: true
                }
            }
            Row{
                Text {
                    text: qsTr("AVIS : ")
                    color: "#FCFCFC"
                    font.pixelSize: smallFontSize//bigFontSize
                    font.bold: true
                }
                Text {
                    id: avisRisque
                    text: qsTr("Attention, ajouter un agent a la chaine")
                    color: "pink"
                    font.pixelSize: smallFontSize//bigFontSize
                    font.bold: true
                }
            }

            Rectangle{
                height: 2
                width: 100
                color: "#262626"
            }
            Text {
                text: qsTr("Evaluation objets triés :")
                color: "#DCECF2"
                font.pixelSize: fontSize//bigFontSize
                font.bold: true
            }
            Row{
                FlodDrawArcTitle
                {
                    id: nbobjettriesSession
                    tailleCarre: 60
                    extension: 358
                    epaisseur: 40
                    arCouleur: "gold"
                    generalTitle: "Objets"
                    maxValue: 150
                }
                Rectangle{
                    height: 7
                    width: 4
                    color: "#262626"
                }
                FlodDrawArcTitle
                {
                    id: nbchargesLourdesSession //getSessionTotalCharges
                    tailleCarre: 60
                    extension: 12
                    epaisseur: 40
                    arCouleur: "brown"
                    generalTitle: "Charges"
                    maxValue: 100
                }
                Rectangle{
                    height: 2
                    width: 4
                    color: "#262626"
                }
                FlodDrawArcTitle
                {
                    id: repetitiviteSession //getSessionMeanRepetitivite
                    tailleCarre: 60
                    extension: 85
                    epaisseur: 40
                    arCouleur: "gray"
                    generalTitle: "Répétitivité"
                    maxValue: 100
                }

            }
            Button{
                text: "Plus d'informations >> "
                background: Rectangle {
                    id:btnCloud
                    color:"#DCECF2"
                    radius: 3
                }
                onPressed:
                {
                    btnCloud.color = "yellow"
                }
                onReleased:
                {
                    btnCloud.color = "#DCECF2"
                }
            }

        }
    }

    Rectangle
    {
        width: root.width/2.9
        height: root.height  - generalSpacing - generalPadding
        id: affichageNombreExtension
        color: "#262626"
        radius: root.width/150
       Column
        {
            padding: 5
            spacing: 5
            Text
            {
                id: titleBiomeca
                text: "Biomécanique"
                font.bold: true
                font.pixelSize: bigFontSize
                horizontalAlignment: Text.AlignHCenter
                color: "#FCFCFC"
            }
             Row
            {
                id: rowBiomeca
                spacing: extendedSpacing
                padding: generalPadding
                Column
                {
                    id:columnGaucheBiomeca
                    spacing: generalSpacing

                    Text
                    {
                        text: "zone d'évolution"
                        id:lblZone
                        color: "#FCFCFC"
                        font.pixelSize: smallFontSize
                        x: (columnGaucheBiomeca.width - width)/2
                    }
                    AfficheurTexteValeur
                    {
                       id: evolVert
                       txtValeurAffiche: "97%"
                       txtCaption: "Vert :"
                    }
                    AfficheurTexteValeur
                    {
                        id: evolJaune
                        strCouleur: "yellow"
                        txtValeurAffiche: "2%"
                        txtCaption: "Jaune :"
                    }
                    AfficheurTexteValeur
                    {
                        id: evolRouge
                        strCouleur: "red"
                        txtValeurAffiche: "1%"
                        txtCaption: "Rouge :"
                    }
                    Image
                    {
                        source: "Image2.jpg"
                        id:imgShowBody
                        width: affichageNombreExtension.width  /3.15
                        fillMode: Image.PreserveAspectFit
                        x: (parent.width - width) /2
                    }
                    AfficheurTexteValeur
                    {
                        id: nbPas
                        strCouleur: "grey"
                        txtValeurAffiche: "19"
                        txtCaption: "Pas :"
                    }
                    FlodDrawArcTitle
                    {
                        id: vibrations
                        tailleCarre: tailleFLODArc
                        extension: 8
                        epaisseur: 50
                        arCouleur: "yellow"
                        generalTitle: "Vibrations"
                        maxValue: 100
                    }
                }
                Column
                {
                    id: columnDroiteBiomeca
                    y: titleBiomeca.height + titleBiomeca.y
                    anchors.topMargin: 2
                    padding: generalPadding*2
                    spacing: extendedSpacing*2.5
                    FlodDrawArcTitle
                    {
                        id: niveauDeRisques
                        tailleCarre: tailleFLODArc
                        extension: 80
                        epaisseur: 50
                        arCouleur: "red"
                        generalTitle: "Niveau de Risques"
                        maxValue: 100
                    }
                    ChartView{
                        //y: affichageNombreExtension.y
                        id: chrtVwCurrentRisk
                        visible: false
                        width: 200
                        height: 120
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        margins.top: 10
                        margins.left:0
                        margins.right:0
                        margins.bottom: 0
                        legend.visible:true

                        ValueAxis
                        {
                            id: axisYriskC
                            min:0
                            max:70
                        }
                        ValueAxis
                        {
                            id:axisXriskC
                            min:0
                            max:10
                        }
                        LineSeries
                        {
                            id: valeursRiskC
                            axisY: axisYriskC
                            axisX:axisXriskC
                            color: "red"
                            name: "Niveau de Risques"
                        }

                        LineSeries
                        {
                            id: valeursRiskCG
                            axisY: axisYriskC
                            axisX:axisXriskC
                            color: "red"
                            style: Qt.DashLine
                            name: "Niveau de Risques"
                        }}

                    FlodDrawArcTitle
                    {
                        id: nbActions
                          tailleCarre: tailleFLODArc
                       extension: 4800
                        epaisseur: 50
                        arCouleur: "purple"
                        generalTitle: "Nombre d'actions"
                        maxValue: 10
                        lblShowDouble: true

                        onBlDoubleDisplayChanged:
                        {
                            if (gbolTotal==false)
                            {
                                chrtViewSmall.blWatch = blDoubleDisplay;
                                //console.log("changement de montre : "+chrtViewSmall.blWatch);
                                columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                            }
                            //rythme.blDoubleDisplay = blDoubleDisplay
                        }
                    }
                    ChartView{
                        //y: affichageNombreExtension.y
                        id: chrtViewNbActionsC
                        visible: false
                        width: 200
                        height: 120
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        margins.top: 10
                        margins.left:0
                        margins.right:0
                        margins.bottom: 0
                        legend.visible:true

                        ValueAxis
                        {
                            id: axisYatC
                            min:0
                            max:15
                        }
                        ValueAxis
                        {
                            id:axisXatC
                            min:0
                            max:10
                        }
                        LineSeries
                        {
                            id: valeursAccATC
                            axisY: axisYatC
                            axisX:axisXatC
                            color: "purple"
                            name: "Nombre d'actions"
                        }
                        LineSeries
                        {
                            id: valeursAccATCG
                            axisY: axisYatC
                            axisX:axisXatC
                            color: "purple"
                            style: Qt.DashLine
                            name: "Nombre d'actions Gauche"
                        }
                    }
                    FlodDrawArcTitle
                    {
                        id: repetitivite
                        tailleCarre: tailleFLODArc
                        extension: 99
                        epaisseur: 50
                        arCouleur: "gray"
                        generalTitle: "Répétitivité"
                        maxValue: 100
                        //lblShowDouble: true
                    }
                }
            }
        }
    }

    Rectangle
    {
        id: columnDisplay
        width: 264
        height: root.height - generalSpacing - generalPadding
        color: "#262626"
        radius: root.width/150
        function displayInstantValues(lblMontre)
        {
            //Affiche la derniere valeur du tableau et met a jour regulierement
            var lintSessionId = accInfo.getCurrentSessionId(identifiantUser);
            var lintNombre = accInfo.getNbDonnees();//accInfo.getSessionNbEnregistrements(lintSessionId)
            var lintMaxGraph = 0, lintMinGraph=0;
            valeursAccX.name= "X";
            valueAxisX.max = lintNombre;

            //console.log("La montre affichee : "+chrtViewSmall.blWatch +" ; lblMontre= " + lblMontre);
/*
            valeursAccX.clear();
            valeursAccY.clear();
            valeursAccZ.clear();
            for (var i=0;i<lintNombre;i++)
            {
                valeursAccX.append(Number(i),accInfo.getValueX(i,lblMontre));
                valeursAccY.append(Number(i),accInfo.getValueY(i,lblMontre));
                valeursAccZ.append(Number(i),accInfo.getValueZ(i,lblMontre));
            }
*/
            chrtViewNbActionsC.visible = false;
            chrtVwCurrentRisk.visible = false;
            nbActions.visible = true;
            niveauDeRisques.visible = true;

            nbDechetsTriés.visible = true;
            chrtVwNbDechetsC.visible = false;
            chrtVwNbChargesC.visible = false;

            imgShowBody.visible = true;
            nbPas.visible = true;
            vibrations.visible = true;
            evolJaune.visible=true;
            evolRouge.visible = true;
            evolVert.visible = true;
            lblZone.visible = true;
            columnDroiteBiomeca.spacing = extendedSpacing*2.5;
            clmnTempsRythme.spacing = extendedSpacing*1.5;

            columnGaucheBiomeca.visible = true;
            columnGaucheBiomeca.enabled = true;
            nbChargesLourdes.visible = true;

            nbActions.extension = accInfo.getCurrentSessionLastAT(lintSessionId,0);
            nbActions.extension2 = accInfo.getCurrentSessionLastAT(lintSessionId,1);
            nbActions.maxValue = 10;//*/
            rythme.extension = accInfo.getSessionLastRyhtm(lintSessionId,0);
            rythme.extension2 = accInfo.getSessionLastRyhtm(lintSessionId,1);

            niveauDeRisques.extension = (accInfo.getSessionLastRisk(lintSessionId,0)+accInfo.getSessionLastRisk(lintSessionId,1))/2; //TRES MAUVAISE IDEE Cette moyenne ca n'a aucun sens !!!!!
            //Faire extension2 pour niveau de risque

            nbDechetsTriés.extension = accInfo.getSessionLastObjets(lintSessionId,0)+accInfo.getSessionLastObjets(lintSessionId,1);
            //nbDechetsTriés.extension2 = accInfo.getNbDechets(1);
            nbChargesLourdes.extension = accInfo.getSessionLastCharges(lintSessionId,0)+accInfo.getSessionLastCharges(lintSessionId,1);
            /*
            combinaisonAcc.clear();
            for (i=0;i<lintNombre;i++)
                combinaisonAcc.append(Number(i),accInfo.getCombinaison(i,lblMontre));
            valueAxisY.min = accInfo.getGeneralMin(lblMontre)-2;
            valueAxisY.max = accInfo.getGeneralMax(lblMontre)+2;
            */
            return 0;
        }
        function displayTotalValues()
        {
            //identifiantUser
            var lintSessionId = accInfo.getCurrentSessionId(identifiantUser);
            var lintNombre = accInfo.getSessionNbEnregistrements(lintSessionId);//accInfo.getIntNbTotalTransmission();
            if (lintNombre<accInfo.getSessionNbEnregistrements(lintSessionId,1))
                lintNombre=accInfo.getSessionNbEnregistrements(lintSessionId,1);


            chrtViewNbActionsC.visible = true;
            chrtVwCurrentRisk.visible = true;
            nbActions.visible = false;
            niveauDeRisques.visible=false;
            nbDechetsTriés.visible = false;
            chrtVwNbDechetsC.visible = true;

            imgShowBody.visible = false;
            nbPas.visible = false;
            vibrations.visible = false;
            evolJaune.visible=false;
            evolRouge.visible = false;
            evolVert.visible = false;
            lblZone.visible =false;
            columnGaucheBiomeca.visible =false;
            columnGaucheBiomeca.enabled = false;
            nbChargesLourdes.visible = false;
            chrtVwNbChargesC.visible = true;

            if (lintNombre<1){
                return 0;
            }

            columnDroiteBiomeca.spacing = extendedSpacing*0.9;
            clmnTempsRythme.spacing = extendedSpacing*0.7;
            //Affiche les valeurs moyennes
            valeursAccATC.clear();
            valeursAccATCG.clear();
            //valeursOCRA.clear();
            valeursRiskC.clear();
            valeursRiskCG.clear();
            valeursDechetsC.clear();
            valeursDechetsCG.clear();
            //lintConvenientTemp = accInfo.getSessionNbEnregistrements(lintSessionId)
            //axisXOCRA.max = lintConvenientTemp;
            axisXatC.max = lintNombre;
            axisXriskC.max = lintNombre;
            axisXDechetsC.max = lintNombre;
            axisXChargesC.max = lintNombre;
            //axisXtms.max = lintConvenientTemp;
            for (var i=0;i<lintNombre;i++)
            {
                valeursAccATC.append(Number(i),accInfo.getSessionValueAT(lintSessionId,i));
                valeursAccATCG.append(Number(i),accInfo.getSessionValueAT(lintSessionId,i,1));
                //valeursOCRA.append(Number(i),accInfo.getSessionValueOCRA(lintSessionId,i));
                valeursRiskC.append(Number(i),accInfo.getSessionValueRisk(lintSessionId,i));
                valeursRiskCG.append(Number(i),accInfo.getSessionValueRisk(lintSessionId,i,1));
                valeursDechetsC.append(Number(i),accInfo.getSessionValueObjets(lintSessionId,i));
                valeursDechetsCG.append(Number(i),accInfo.getSessionValueObjets(lintSessionId,i,1));
                //valeursChargesC
            }
            rythme.extension =accInfo.getSessionRythmeMoyenMVT(lintSessionId);
            rythme.extension2 =accInfo.getSessionRythmeMoyenMVT(lintSessionId,1);

            return 0;
        }
        Column{
            Row
            {
                padding: 0//generalPadding
                spacing: extendedSpacing
                Column
                {
                    padding: generalPadding
                    spacing: generalSpacing * 1.73
                    Text
                    {
                        text: "Poste de Travail"
                        font.bold: true
                        font.pixelSize: bigFontSize
                        horizontalAlignment: Text.AlignHCenter
                        color: "#FCFCFC"
                    }
                    Row
                    {
                        Text
                        {
                            text: "Localisation : "
                            font.bold: true
                            font.pixelSize: fontSize
                            horizontalAlignment: Text.AlignHCenter
                            color: "#FCFCFC"
                        }
                        Text
                        {
                            id: titlePoste
                            text: "Cabine Papiers"
                            font.pixelSize: fontSize
                            horizontalAlignment: Text.AlignHCenter
                            color: "#FCFCFC"
                        }
                    }
                    Image
                    {
                        source: "Image3.jpg"
                        width: columnDisplay.width /4.6
                        fillMode: Image.PreserveAspectFit
                        x : 20
                    }
                    ChartView{
                        //y: affichageNombreExtension.y
                        id: chrtVwNbDechetsC
                        visible: false
                        width: 180
                        height: 120
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        margins.top: 10
                        margins.left:0
                        margins.right:0
                        margins.bottom: 0
                        legend.visible:true

                        ValueAxis
                        {
                            id: axisYDechetsC
                            min:0
                            max:15
                        }
                        ValueAxis
                        {
                            id:axisXDechetsC
                            min:0
                            max:10
                        }
                        LineSeries
                        {
                            id: valeursDechetsC
                            axisY: axisYDechetsC
                            axisX: axisXDechetsC
                            color: "gold"
                            name: "Nb Déchets triés"
                        }
                        LineSeries
                        {
                            id: valeursDechetsCG
                            axisY: axisYDechetsC
                            style: Qt.DashLine
                            axisX: axisXDechetsC
                            color: "gold"
                            name: "Nb Déchets triés"
                        }
                    }
                    ChartView{
                        //y: affichageNombreExtension.y
                        id: chrtVwNbChargesC
                        visible: false
                        width: 180
                        height: 120
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        margins.top: 10
                        margins.left:0
                        margins.right:0
                        margins.bottom: 0
                        legend.visible:true

                        ValueAxis
                        {
                            id: axisYChargesC
                            min:0
                            max:10
                        }
                        ValueAxis
                        {
                            id:axisXChargesC
                            min:0
                            max:10
                        }
                        LineSeries
                        {
                            id: valeursChargesC
                            axisY: axisYChargesC
                            axisX: axisXChargesC
                            color: "brown"
                            name: "Nb Charges Lourdes"
                        }
                    }

                    ChartView
                    {
                        property bool blWatch: false
                        y: affichageNombreExtension.y
                        id: chrtViewSmall
                        width: 150
                        height: 130
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        visible: false

                        margins.top: 0
                        margins.left:0
                        margins.right:0
                        margins.bottom: 0
                        legend.visible:false

                        onBlWatchChanged:
                        {

                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:
                                if (gbolTotal)
                                {
                                    gbolTotal = false;
                                    btnTotal.text = "Moyenne";
                                    columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                                }
                                else
                                {
                                    gbolTotal = true;
                                    btnTotal.text = "Detail";
                                    columnDisplay.displayTotalValues();
                                }
                        }
                        ValueAxis
                        {
                            id: valueAxisY
                            min:-20
                            max:10
                        }
                        ValueAxis
                        {
                            id:valueAxisX
                            min:0
                            max:10
                        }
                        LineSeries
                        {
                            id: valeursAccX
                            axisY: valueAxisY
                            axisX:valueAxisX
                            name: "X"
                        }
                        LineSeries
                        {
                            id: valeursAccY
                            axisY: valueAxisY
                            axisX:valueAxisX
                            name: "Y"
                        }
                        LineSeries
                        {
                            id: valeursAccZ
                            axisY: valueAxisY
                            axisX:valueAxisX
                            name: "Z"
                        }
                        LineSeries
                        {
                            id: combinaisonAcc
                            axisY: valueAxisY
                            axisX: valueAxisX
                            name: "R"
                        }
                    }

                    Timer
                    {
                        interval: 10000
                        repeat: true
                        triggeredOnStart: true
                        running: true
                        onTriggered: {
                            montreGaucheSelection.addItem(qsTr("item3"));
                            switch (state)
                            {
                                case "Enregistrant":
                                    //accInfo.autoreadFile(serialNoG,serialNoD);
                                    if (gbolTotal)
                                        columnDisplay.displayTotalValues();
                                    else
                                        columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                                    //var lintSessionId = accInfo.getCurrentSessionId(identifiantUser);
                                    tpsTravail.extension = accInfo.getCurrentSessionDuration(accInfo.getCurrentSessionId(identifiantUser))/60;//accInfo.getDureeTotaleEnregistrementEnMinutes();
                                    break;
                            }
                        }
                    }
                    FlodDrawArcTitle
                    {
                        id: nbChargesLourdes
                        tailleCarre: tailleFLODArc
                        extension: 45
                        epaisseur: 50
                        arCouleur: "brown"
                        generalTitle: "Nb Charges Lourdes"
                        maxValue: 70 // On définit ici le nombre de charges max
                        x : (parent.width - width) /2
                    }
                }
                Column
                {
                    id : clmnTempsRythme
                    spacing: extendedSpacing*1.5
                    Button
                    {
                        contentItem: Label {
                            color: "white"
                            text: " Changer "
                            font.bold: true
                            font.pixelSize: smallFontSize
                        }

                        background: Rectangle {
                            color:"#DCECF2"
                            id:btnBackChange
                            radius: 3
                        }
                        onPressed:
                        {
                            btnBackChange.color = "yellow"
                        }
                        onReleased:
                        {
                            btnBackChange.color = "#DCECF2"
                        }
                    }
                    y:titlePoste.y //+ titlePoste.parent.y + titlePoste.width
                    FlodDrawArcTitle
                    {
                        id: tpsTravail
                        tailleCarre: tailleFLODArc
                        extension: 110
                        epaisseur: 50
                        arCouleur: "blue"
                        generalTitle: "Temps de travail"
                        maxValue: 120
                    }
                    FlodDrawArcTitle
                    {
                        id: rythme
                        tailleCarre: tailleFLODArc
                        extension: 41
                        epaisseur: 50
                        arCouleur: "green"
                        generalTitle: "Rythme / minutes"
                        maxValue: 90
                        lblShowDouble: true
                    }
                    FlodDrawArcTitle
                    {
                        id: nbDechetsTriés
                        tailleCarre: tailleFLODArc
                        extension: 1450
                        epaisseur: 50
                        arCouleur: "gold"
                        generalTitle: "Nb Déchets triés"
                        maxValue: 1900
                    }
                }

            }

        }


    }
}
