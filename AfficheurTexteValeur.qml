import QtQuick 2.7


Row {
    property string txtCaption: "Valeur :"
    property string txtValeurAffiche: "87%"
    property string strCouleur: "green"
    property real rlCoefLargeur: 0.9
    width: parent.width
    Text {
        id: captionTxt
        text: txtCaption
        color: strCouleur
        font.pixelSize: 9
        font.bold: true
        x: (1- rlCoefLargeur)* parent.width

    }
    Text{
        id: valeurAfficheur
        text: txtValeurAffiche
        color: strCouleur
        font.pixelSize: 10
        font.bold: true
        x: rlCoefLargeur * parent.width - width
    }
}
