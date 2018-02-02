import QtQuick 2.0

Column
{
    property int lintIndex: -1
    property int intWidth: 80
    property int lintIdentifiantUser: -1
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
                voirdetailAgent.lintUpdate = voirdetailAgent.lintUpdate + 1;
                nom.color = "yellow"; // This is available in all editors.
                conteneurGeneral.state = "DetailAgent";

            }

            layer.enabled: true
            layer.effect: OpacityMask
            {
                maskSource: mask
            }
        }
    }
    Rectangle
    {
        id: mask
        width: 500
        height: 500
        radius: 250
        visible: false
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
        console.log("Index : "+lintIndex+" retourne l'Id: "+ lintIdentifiantUser);
    }


}
