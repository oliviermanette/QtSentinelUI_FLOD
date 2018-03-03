import QtQuick 2.0

Column
{
    property int lintIndex: -1
    property int intWidth: 80
    property int lintIdentifiantUser: -1
    property int lintUserStatus:0
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

                nom.color = "yellow"; // This is available in all editors.
                conteneurGeneral.state = "DetailAgent";

                // Ici il doit vérifier quelle est la session de l'agent en question pour le recopier dans agentstate
                switch (accInfo.getAgentStatus(lintIdentifiantUser))
                {
                    case 1:
                        root.detailAgentState = "Present";
                        break;
                    case 2:
                        root.detailAgentState = "Enregistrant";
                        break;
                    default:
                        root.detailAgentState = "Inactif";
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
    }
    onLintIndexChanged:
    {
        nom.text = accInfo.getAgentNomLst(lintIndex);
        lintIdentifiantUser = accInfo.getAgentId(lintIndex);
        lintUserStatus = accInfo.getAgentStatus(lintIndex);
        //console.log("Index : "+lintIndex+" retourne l'Id: "+ lintIdentifiantUser);
    }
}
