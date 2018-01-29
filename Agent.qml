import QtQuick 2.0

Column
{
    property int lintIndex: -1
    Image
    {
        source: "Image1.jpg"
        width: 50
        fillMode: Image.PreserveAspectFit
    }
    Text {
        id: nom
        text: qsTr("inconnu")
    }
    onLintIndexChanged:
    {
        nom.text = accInfo.getAgentNomLst(lintIndex)
    }

}
