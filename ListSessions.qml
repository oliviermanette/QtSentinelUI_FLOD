import QtQuick 2.7
import QtQuick.Controls 2.3

Rectangle{
    width: 245
    height: root.height  - generalSpacing - generalPadding
    id:localList

    color: "#262626"
    radius: root.width/150
    states: [
        State {
            name: "BDD"
            PropertyChanges {
                target: lblAddSession
                text: "Ajout fichier"
            }
            PropertyChanges {
                target: txtTitleSessionList
                text: qsTr("Liste des sessions :")
            }
            PropertyChanges {
                target: btnEdit
                enabled: true
            }
        },
        State {
            name: "Files"
            PropertyChanges {
                target: lblAddSession
                text:"Enregistrés < "
            }
            PropertyChanges {
                target: txtTitleSessionList
                text: qsTr("Liste des fichiers :")
            }
            PropertyChanges {
                target: btnEdit
                enabled: false
            }
        }
    ]
    Column{
        padding: 10//generalPadding
        spacing : 10//extendedSpacing
        Text{
            id: txtTitleSessionList
            text: qsTr("Liste des Sxessions :")
            color: "#FCFCFC"
            font.pixelSize: bigFontSize+4
            font.bold: true
        }
        Repeater{
            id:repeaterSessions
            property int lintOffsetSession: 0
            property int lintNbSessions: detailAgentMain.intNbSessions
            model: intMaxSessions

            SessionRow{
                lintIndex : index + repeaterSessions.lintOffsetSession
                lintIndividu: identifiantUser
                lstrState: localList.state
            }
        }
        Row{
            spacing: 2
            Button{
                text: "Ajout fichier"
                id:lblAddSession
                background: Rectangle {
                    color:"#DCECF2"
                    id:btnAddSession
                    radius: 3
                }
                onPressed:{
                    /*
                    if (localList.state=="BDD" || localList.state==""){
                        repeaterSessions.lintNbSessions = accInfo.readAllSessionFiles();
                        console.log(repeaterSessions.lintNbSessions);
                        if (repeaterSessions.lintNbSessions<intMaxSessions)
                            intMaxSessions = repeaterSessions.lintNbSessions;
                        else
                            intMaxSessions = constMaxSession;
                    }*/
                    btnAddSession.color = "yellow";
                }
                onReleased:{
                    btnAddSession.color = "#DCECF2";
                    if (localList.state=="Files"){
                        localList.state = "BDD";
                        voirdetailAgent.lintUpdate = voirdetailAgent.lintUpdate + 1;
                    }
                    else{
                        localList.state = "Files";
                        repeaterSessions.lintNbSessions = accInfo.readAllSessionFiles();
                        if (repeaterSessions.lintNbSessions<intMaxSessions)
                            intMaxSessions = repeaterSessions.lintNbSessions;
                        else
                            intMaxSessions = constMaxSession;
                    }
                    myPTMSServer.switchSessionFileBDD(localList.state);
                }
            }
            Button{
                text: "  <  "
                background: Rectangle {
                    color:"#DCECF2"
                    id:btnPrevious
                    radius: 3
                }
                onPressed:{
                    btnPrevious.color = "yellow"
                }
                onReleased:{
                    btnPrevious.color = "#DCECF2"
                    repeaterSessions.lintOffsetSession = repeaterSessions.lintOffsetSession - constMaxSession;
                }
            }
            Button{
                text: "  >  "
                background: Rectangle {
                    color:"#DCECF2"
                    id:btnNext
                    radius: 3
                }
                onPressed:{
                    btnNext.color = "yellow"
                }
                onReleased:{
                    btnNext.color = "#DCECF2"
                    repeaterSessions.lintOffsetSession = repeaterSessions.lintOffsetSession + constMaxSession;
                }
            }
            Button{
                text: "Editer - "
                id:btnEdit
                background: Rectangle {
                    color:"#DCECF2"
                    id:lblEdit
                    radius: 3
                }
                onPressed:{
                    lblEdit.color = "yellow"
                }
                onReleased:{
                    lblEdit.color = "#DCECF2"
                    myPTMSServer.switchSessionEdit();
                }
            }
        }
    }
}
