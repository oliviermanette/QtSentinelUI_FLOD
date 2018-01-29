import QtQuick 2.0

Column
{
    property int lintIndex: -1
    property int intWidth: 80
    Image
    {
        source: "Image1.jpg"
        width: intWidth
        fillMode: Image.PreserveAspectFit
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
        nom.text = accInfo.getAgentNomLst(lintIndex)
    }


}
