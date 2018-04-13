import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
//import aero.flod.ptms 1.0

Window
{
    property bool gbolTotal: false
    width: 896
    height: 560
    property int generalPadding: 4//(width*height)/100000
    property int generalSpacing: 4//generalPadding
    property int extendedSpacing: 8//generalSpacing * 3
    property int tailleFLODArc: 60//(width*height)/5500
    property int smallFontSize: 8
    property int fontSize: 11
    property int bigFontSize: 16

    property int identifiantUser: 0 // identifiant de l utilisateur affiche

    property string serialNoG: ""
    property string serialNoD: ""
    property string detailAgentState: ""

    id: root
    visible: true
    title: qsTr("Vauché Prevention des TMS - FLOD")
    color: "#606060"
    visibility:  Window.FullScreen // <<#*********************** A decommenter
    onDetailAgentStateChanged: {
        voirdetailAgent.state=detailAgentState;
    }
    Item
    {
        id: conteneurGeneral
        onStateChanged: {
            if (state=="ListAgents")
                myPTMSServer.setAgentUpdateAll();
        }

        DetailAgent
        {
            id: voirdetailAgent
            visible: false
            enabled: false
        }

        Popup{
            property int lintUser: 0
            id: popup
            x: 100
            y: 100
            width: 200
            height: 200
            Column
            {
                Text {
                    id: infoPopUp
                    text: "toto = " + voirlistAgents.intNbAgents
                }
                Button
                {
                    id:btnInfoPopup
                    visible: false
                    text: "OK"
                    onPressed:
                    {
                        //Envoie wouldstop a l'utilisateur concerne
                        accInfo.setSessionWouldStop(popup.lintUser);
                        btnInfoPopup.visible = false;
                        popup.close();
                    }
                }
            }

            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            Connections {
                target: myPTMSServer
                onReceivedMessage: {
                    if (myPTMSServer.isCanIStop(message))
                    {
                        infoPopUp.text = "Autorisez - vous la pause de :\n" +accInfo.getAgentNom(message) +" ?";
                        //console.log(accInfo.getAgentIdFromMessage(message));
                        popup.lintUser = accInfo.getAgentIdFromMessage(message);
                        btnInfoPopup.visible = true;
                    }
                    else
                        infoPopUp.text = message;
                    popup.open();
                }
            }
        }
        ListAgents
        {
            id: voirlistAgents
            visible: true
            enabled: true
        }
        states: [
            State {
                name: "ListAgents"
                PropertyChanges {
                    target: voirlistAgents
                    visible:true
                    enabled:true
                }
                PropertyChanges {
                    target: voirdetailAgent
                    visible:false
                    enabled:false
                }
            },
            State {
                name: "DetailAgent"
                PropertyChanges {
                    target: voirlistAgents
                    visible:false
                    enabled:false
                }
                PropertyChanges {
                    target: voirdetailAgent
                    visible:true
                    enabled:true
                }
            }
        ]
    }
    Timer
    {
        interval: 10000
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            accInfo.readSessionFiles();
        }
    }
}

