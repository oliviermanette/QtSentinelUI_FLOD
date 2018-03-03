import QtQuick 2.7
import QtQuick.Controls 2.2
import QtCharts 2.2
Row
{
    id:detailAgentMain

    states: [
        State {
            name: "Inactif"
            PropertyChanges {
                target: btnContact
                visible:false
                enabled:false

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
                visible:false
                enabled:false
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
        }
    ]

    padding: generalPadding
    spacing: generalSpacing
    property int lintUpdate: 0
    property int intNbSessions: 0

    onLintUpdateChanged: // ça change au moment où on clique sur l'icone
    {
         console.log("STATUS : "+ state.toString());
         console.log("STATUS : "+conteneurGeneral.state.toString());
        //Initialisation de l affichage
        var lintNbSessions = accInfo.getNombreSessions(identifiantUser);

        serialNoD = accInfo.getMontreSN(identifiantUser,0);//" - "
        serialNoG = accInfo.getMontreSN(identifiantUser);
        lblAge.text = accInfo.getIndividuAge(identifiantUser);
        lblPrenom.text = accInfo.getDBValue("identites","Prenom",identifiantUser);
        lblNom.text = accInfo.getDBValue("identites","Nom",identifiantUser);//"COYOTTE"

        switch (state)
        {
            case "Present":

                if (lintNbSessions>0)
                    intNbSessions = lintNbSessions;
                else
                    intNbSessions = 0;
                break;
            case "Inactif":                
                if (lintNbSessions>0)
                    intNbSessions = lintNbSessions;
                else
                    intNbSessions = 0;
                break;
            case "Enregistrant":

                accInfo.autoreadFile(serialNoG,serialNoD);
                if (gbolTotal)
                    columnDisplay.displayTotalValues();
                else
                    columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                tpsTravail.extension = accInfo.getDureeTotaleEnregistrementEnMinutes();
                break;
        }
    }

    Rectangle
    {
        width: root.width/4.728
        height: root.height - generalSpacing - generalPadding
        id: columIdentite
        color: "#262626"
        radius: root.width/100
        Column
        {
            padding: generalPadding
            spacing : extendedSpacing
            Text
            {
                id: titleID
                text: "Identité"
                font.bold: true
                font.pixelSize: bigFontSize
                horizontalAlignment: Text.AlignHCenter
                color: "#FCFCFC"
            }
            Image
            {
                source: "Image1.jpg"
                width: columIdentite.width /2.5
                fillMode: Image.PreserveAspectFit
            }
            Row
            {
                spacing: extendedSpacing
                Text
                {
                    text: "Nom"
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text
                {
                    id : lblNom
                    text: "Doe"
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }
            Row
            {
                spacing: extendedSpacing
                Text
                {
                    text: "Prénom"
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text
                {
                    id : lblPrenom
                    text: "John"
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }
            Row
            {
                spacing: extendedSpacing
                Text
                {
                    text: "Age : "
                    font.bold: true
                    font.pixelSize: fontSize
                    color: "#FCFCFC"
                }
                Text
                {
                    id: lblAge
                    text: ""
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
            }

            Button
            {
                id:btnContact
                contentItem: Label {
                    color: "white"
                    text: " Contacter "
                    font.bold: true
                    font.pixelSize: smallFontSize
                }
                background: Rectangle {
                    color:"#0F6FC6"
                    id:toto
                    radius: 3
                }
                onPressed:
                {
                    toto.color = "yellow"
                }
                onReleased:
                {
                    toto.color = "#0F6FC6"
                }
            }
            Row{
                spacing: 20
                Text
                {
                    id: lblStatus
                    text: ""
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: fontSize
                }
                Button
                {
                    id:btnStatus
                    contentItem: Label {
                        id:lblbtnStatus
                        color: "white"
                        text: " _ "
                        font.bold: true
                        font.pixelSize: smallFontSize
                    }
                    background: Rectangle {
                        color:"#0F6FC6"
                        id:titi
                        radius: 3
                    }
                    onPressed:
                    {
                        if (accInfo.setSessionMustStart(identifiantUser))
                            lblbtnStatus.text = "Envoye ...";
                        titi.color = "yellow"
                    }
                    onReleased:
                    {
                        titi.color = "#0F6FC6"
                    }
                }

            }


            Row
            {
                spacing: extendedSpacing

                Text
                {
                    text: "Montre Gauche"
                    font.bold: true
                    font.pixelSize: smallFontSize
                    color: "#FCFCFC"
                }
                Text
                {
                    text: serialNoG//"RSAJ303LQAR"
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: smallFontSize
                }
                Light
                {
                    id:lightMontreGauche


                }
            }
            Row
            {
                spacing: extendedSpacing
                Text
                {
                    text: "Montre Droite"
                    font.bold: true
                    font.pixelSize: smallFontSize
                    color: "#FCFCFC"
                }
                Text
                {
                    text: serialNoD
                    font.bold: false
                    color: "#FCFCFC"
                    font.pixelSize: smallFontSize
                }
                Light
                {
                    id:lightMontreDroit

                }
            }
            Timer
            {
                id : onStartFunction
                interval: 10000
                repeat: false
                triggeredOnStart: true
                running: true
                onTriggered: {
         /*           //Initialisation de l affichage
                    serialNoD = accInfo.getMontreSN(identifiantUser,0);//" - "
                    serialNoG = accInfo.getMontreSN(identifiantUser);
                    lblAge.text = accInfo.getIndividuAge(identifiantUser);
                    lblPrenom.text = accInfo.getDBValue("identites","Prenom",identifiantUser);
                    lblNom.text = accInfo.getDBValue("identites","Nom",identifiantUser);//"COYOTTE"
                    accInfo.autoreadFile(serialNoG,serialNoD);
                    if (gbolTotal)
                        columnDisplay.displayTotalValues();
                    else
                        columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                    tpsTravail.extension = accInfo.getDureeTotaleEnregistrementEnMinutes();

                    console.log("STATUS : "+detailAgentMain.status);*/
                }
            }

            Button
            {
               id       : btnTotal
               text     : "Total"
               onClicked:
                   if (gbolTotal)
                   {
                       gbolTotal = false;
                       btnTotal.text = "Total";
                       columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                   }
                   else
                   {
                       gbolTotal = true;
                       btnTotal.text = "Instant";
                       columnDisplay.displayTotalValues();
                   }
               background: Rectangle {
                   color:"#0F6FC6"
                   id:btnBackTotal
                   radius: 3
               }
               onPressed:
               {
                   btnBackTotal.color = "yellow"
               }
               onReleased:
               {
                   btnBackTotal.color = "#0F6FC6"
               }
            }
            Button
            {
                id  : btnBackToList
                text: "list"

                background: Rectangle {
                    color:"#0F6FC6"
                    id:btnBack
                    radius: 3
                }
                onPressed:
                {
                    btnBack.color = "yellow"
                }
                onReleased:
                {
                    btnBack.color = "#0F6FC6"
                    conteneurGeneral.state = "ListAgents";
                }
            }
            Button
            {
               text: "Quitter"
               onClicked:
                   Qt.quit()
            }
        }
    }

    Rectangle
    {
        width: root.width/2.9
        height: root.height  - generalSpacing - generalPadding
        id:columnListSessions
        color: "#262626"
        radius: 15

        Column
        {
            padding: 40//generalPadding
            spacing : 10//extendedSpacing



            Repeater
            {
                model: intNbSessions

                SessionRow {
                    lintIndex : index
                    lintIndividu: identifiantUser
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
        radius: 15
       Column
        {
            padding: 10
            spacing: 20
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
                        id: titleBiomeca
                        text: "Biomécanique"
                        font.bold: true
                        font.pixelSize: bigFontSize
                        horizontalAlignment: Text.AlignHCenter
                        color: "#FCFCFC"
                    }
                    Text
                    {
                        text: "zone d'évolution"
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
                        width: affichageNombreExtension.width  /3.15
                        fillMode: Image.PreserveAspectFit
                        x: (parent.width - width) /2
                    }
                    AfficheurTexteValeur
                    {
                        id: nbPas
                        strCouleur: "grey"
                        txtValeurAffiche: "252"
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
                        }//*/
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
        radius: 15
        function displayInstantValues(lblMontre)
        {
            var lintNombre = accInfo.getNbDonnees();
            var lintMaxGraph = 0, lintMinGraph=0;
            valeursAccX.name= "X";
            valueAxisX.max = lintNombre;

            //console.log("La montre affichee : "+chrtViewSmall.blWatch +" ; lblMontre= " + lblMontre);

            valeursAccX.clear();
            valeursAccY.clear();
            valeursAccZ.clear();
            for (var i=0;i<lintNombre;i++)
            {
                valeursAccX.append(Number(i),accInfo.getValueX(i,lblMontre));
                valeursAccY.append(Number(i),accInfo.getValueY(i,lblMontre));
                valeursAccZ.append(Number(i),accInfo.getValueZ(i,lblMontre));
            }

            nbActions.extension = accInfo.getNbMouvements(0);
            nbActions.extension2 = accInfo.getNbMouvements(1);
            nbActions.maxValue = 10;//*/
            rythme.extension = accInfo.getFltRythmeInstantMVT(0);
            rythme.extension2 = accInfo.getFltRythmeInstantMVT(1);

            niveauDeRisques.extension = accInfo.getNiveauRisque(identifiantUser);

            nbDechetsTriés.extension = accInfo.getNbDechets(0)+accInfo.getNbDechets(1);
            //nbDechetsTriés.extension2 = accInfo.getNbDechets(1);

            combinaisonAcc.clear();
            for (i=0;i<lintNombre;i++)
                combinaisonAcc.append(Number(i),accInfo.getCombinaison(i,lblMontre));
            valueAxisY.min = accInfo.getGeneralMin(lblMontre)-2;
            valueAxisY.max = accInfo.getGeneralMax(lblMontre)+2;
            return 0;
        }
        function displayTotalValues()
        {
            var lintNombre = accInfo.getIntNbTotalTransmission();
            valueAxisX.max = lintNombre+1;
            accInfo.getNbMouvements();
            accInfo.getNbMouvements(1);
            //nombre total de mouvemement
            nbActions.extension = accInfo.getIntNbTotalMVT();
            nbActions.extension2 = accInfo.getIntNbTotalMVT(1);
            nbActions.maxValue = 200;//*/
            //rythme moyen depuis le début
            rythme.extension = accInfo.getFltRythmeMoyenMVT(0);
            rythme.extension2 = accInfo.getFltRythmeMoyenMVT(1);
            //nb total de dechets triees depuis le debut
            nbDechetsTriés.extension = accInfo.getNbDechetsTotal(0) + accInfo.getNbDechetsTotal(1);

            // graphique
            valeursAccX.clear();
            valeursAccY.clear();
            valeursAccZ.clear();
            valeursAccX.name="Droite";
            valeursAccY.name="Gauche";
            combinaisonAcc.clear();
            for (var i=0;i<lintNombre;i++)
            {
                valeursAccX.append(Number(i),accInfo.getTblIntNbMVT(i,0));
                valeursAccY.append(Number(i),accInfo.getTblIntNbMVT(i,1));
            }
            valueAxisY.min = 0;
            valueAxisY.max = 15;
            return 0;
        }
        Row
        {
            padding: generalPadding
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

                ChartView
                {
                    property bool blWatch: false
                    y: affichageNombreExtension.y
                    id: chrtViewSmall
                    width: 150
                    height: 130
                    theme: ChartView.ChartThemeDark
                    antialiasing: true
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
                                btnTotal.text = "Total";
                                columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                            }
                            else
                            {
                                gbolTotal = true;
                                btnTotal.text = "Instant";
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
                        switch (state)
                        {
                            case "Enregistrant":
                                accInfo.autoreadFile(serialNoG,serialNoD);
                                if (gbolTotal)
                                    columnDisplay.displayTotalValues();
                                else
                                    columnDisplay.displayInstantValues(chrtViewSmall.blWatch);
                                tpsTravail.extension = accInfo.getDureeTotaleEnregistrementEnMinutes();
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
                        color:"#0F6FC6"
                        id:btnBackChange
                        radius: 3
                    }
                    onPressed:
                    {
                        btnBackChange.color = "yellow"
                    }
                    onReleased:
                    {
                        btnBackChange.color = "#0F6FC6"
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
