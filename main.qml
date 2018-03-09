import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
//import aero.flod.ptms 1.0

Window
{
    property bool gbolTotal: false
    width: 896
    height: 560
    property int generalPadding: 5//(width*height)/100000
    property int generalSpacing: 5//generalPadding
    property int extendedSpacing: 10//generalSpacing * 3
    property int tailleFLODArc: 80//(width*height)/5500
    property int smallFontSize: 10
    property int fontSize: 14
    property int bigFontSize: 20

    property int identifiantUser: 0 // identifiant de l utilisateur affiche

    property string serialNoG: ""
    property string serialNoD: ""
    property string detailAgentState: ""

    id: root
    visible: true
    title: qsTr("Vauché Prevention des TMS - FLOD")
    color: "#606060"
    //visibility:  Window.FullScreen // <<#*********************** A decommenter
    onDetailAgentStateChanged: {
        voirdetailAgent.state=detailAgentState;
    }

    Item
    {
        id: conteneurGeneral

        DetailAgent
        {
            id: voirdetailAgent
            visible: false
            enabled: false
        }

        Popup{
            id: popup
            x: 100
            y: 100
            width: 200
            height: 200
            Text {
                id: infoPopUp
                text: "toto = " + voirlistAgents.intNbAgents
            }
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            Connections {
                target: myPTMSServer
                onReceivedMessage: {
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


}

