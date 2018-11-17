import QtQuick 2.7

Row {
    property int lintIndex: -1
    property int lintIndividu:-1
    property int lintSessionId: -1
    property string lstrSessionId: ""
    property int lintOffset: -1
    property string lstrState: ""
    property int lintSessiondurationInSec: 0

    id:rootRowSession
    spacing: 15
    states: [
        State {
            name: "Read"
            PropertyChanges {
                target: sessionDuree
                width:40
            }
            PropertyChanges {
                target: imgDeleteSession
                visible:false
                enabled:false
            }
            PropertyChanges {
                target: txtVoir
                visible: true
                enabled: true
            }
            PropertyChanges {
                target: imgAddSession//fileNumber
                visible:false
                enabled:false
            }
            PropertyChanges {
                target: fileNumber//fileNumber
                visible:false
                enabled:false
            }
        },
        State {
            name: "Delete"
            PropertyChanges {
                target: sessionDuree
                width:20
            }
            PropertyChanges {
                target: imgDeleteSession
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: txtVoir
                visible: true
                enabled: true
            }
            PropertyChanges {
                target: imgAddSession//
                visible:false
                enabled:false
            }
            PropertyChanges {
                target: fileNumber//fileNumber
                visible:false
                enabled:false
            }
        },
        State {
            name: "Files"
            PropertyChanges {
                target: sessionDuree
                width:20
            }
            PropertyChanges {
                target: imgDeleteSession//imgAddSession
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: txtVoir
                visible: false
                enabled: false
            }
            PropertyChanges {
                target: imgAddSession//
                visible:true
                enabled:true
            }
            PropertyChanges {
                target: fileNumber//fileNumber
                visible:true
                enabled:true
            }
        }
    ]
    Connections{
        target: myPTMSServer
        onSessionEditSwitch:{
            if (rootRowSession.state=="Delete")
                rootRowSession.state="Read";
            else
                rootRowSession.state="Delete";
        }
    }
    function updateDisplay(){
        if(lstrState=="BDD" || lstrState==""){
            if ((lintIndex<intNbSessions)&(lintIndex>=0)){
                lintOffset = lintIndex;
                sessionText.text = accInfo.getSessiondDate(lintIndividu, lintOffset); //getFileSessionDate
                sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintOffset);//getFileSessionDuration
                lintSessionId = accInfo.getSessionID(lintIndividu, lintOffset);
                rootRowSession.visible = true;
                rootRowSession.enabled = true;
            }
            else{
                rootRowSession.visible = false;
                rootRowSession.enabled = false;
           }
        }
        else{
            //state="Files";
            //met a jour avec les elements de la structure
            if ((lintIndex<repeaterSessions.lintNbSessions)&(lintIndex>=0)){
                lintOffset = lintIndex;
                sessionText.text = accInfo.getFileSessionDate(lintOffset); //getFileSessionDate
                sessionDuree.text = accInfo.getFileSessionDuration(lintOffset);//getFileSessionDuration
                lstrSessionId = accInfo.getFileSessionTimestamp(lintOffset);
                fileNumber.text = accInfo.getFileSessionNumber(lintOffset);
                lintSessiondurationInSec = accInfo.getFileSessionDurationInSec(lintOffset);
                rootRowSession.visible = true;
                rootRowSession.enabled = true;
            }
            else{
                rootRowSession.visible = false;
                rootRowSession.enabled = false;
           }
        }
    }

    Connections{
        target: myPTMSServer
        onSessionFileSwitch:{
            if (lstrState=="BDD"){
                rootRowSession.state="Read";
            }
            else{
                rootRowSession.state="Files";
            }
        }
    }

    function clickSessionLine(){
        columnDetailSessions.lintIndividu = lintIndividu;
        columnDetailSessions.lintIndex = lintIndex;
        columnDetailSessions.lintSessionId = lintSessionId;
    }
    Text {
        id: sessionText
        color: "white"
        width: 80
        text: qsTr("text")
        font.pixelSize:fontSize
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();
          }
        }
    }
    Text{
        id: sessionDuree
        text: "0"
        font.pixelSize:fontSize
        color: "#DCECF2"
        width: 55
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();
          }
        }
    }
    Text{
        id: fileNumber
        text: "0"
        font.underline: true
        font.pixelSize:fontSize
        visible:false
        color: "#becbea"
        width: 15
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();
          }
        }
    }

    onLintIndexChanged:{
        updateDisplay();
    }
    onVisibleChanged:{
        if (lintOffset>-1){
            sessionText.text = accInfo.getSessiondDate(lintIndividu, lintOffset);
            sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintOffset);
            lintSessionId = accInfo.getSessionID(lintIndividu, lintOffset);
        }
    }
    Text {
        id:txtVoir
        text: "Voir ..."
        font.bold: true
        color: "pink"
        font.pixelSize:fontSize
        MouseArea {
          anchors.fill: parent
          onClicked: {
              clickSessionLine();
          }
        }
    }
    Image{
        source: "+.png"
        id:imgAddSession
        width: 15
        fillMode: Image.PreserveAspectFit
        visible: false
        MouseArea {
          anchors.fill: parent
          onClicked: {/*
              add the file*/
              console.log(lstrSessionId);
              accInfo.addSessionFiles(lstrSessionId, lintIndividu, lintSessiondurationInSec);
          }
        }
    }
    Image{
        source: "Export PDF icon60.png"
        id:imgExportPDF
        width:15
        fillMode: Image.PreserveAspectFit
        visible: true
        MouseArea{
            anchors.fill: parent
            onClicked:
                accInfo.generatePDF(lintSessionId);
        }
    }

    Image{
        source: "delete-1-icon.png"
        id:imgDeleteSession
        width: 15
        fillMode: Image.PreserveAspectFit
        visible: false
        MouseArea {
          anchors.fill: parent
          onClicked: {
              if(lstrState=="BDD" || lstrState==""){
                  if (accInfo.deleteSession(lintSessionId)){
                      rootRowSession.visible=false;
                      rootRowSession.enabled = false;
                  }
                  else
                      console.log(lintSessionId);
              }
              else{
                  //delete the file
              }
          }
        }
    }
}
