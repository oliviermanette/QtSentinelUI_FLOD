import QtQuick 2.0

Column
{
    id:rootColumn

    property string generalTitle: "Titre"
    property string flodArcTitle: "Nom"
    property bool blTitre: false // Si c'est vrai ça affiche le texte "flodArcTitle" à la place de la valeur comprise entre 0 et 100
    property int epaisseur: 30
    property int extension: 50 //angle exprimé en pourcentage %
    property int extension2: 20 //angle exprimé en pourcentage %
    property int tailleCarre:200
    property string arCouleur: "#C00000"
    property int maxValue:100
    property bool lblShowDouble: false
    property bool lblShowSingle: true
    property bool blDoubleDisplay: false


    onLblShowDoubleChanged:
    {
        if (lblShowDouble)
            lblShowSingle=false;
    }
    onLblShowSingleChanged:
    {
        if (lblShowSingle)
            lblShowDouble=false;
    }

    Text
    {
        id: titleArc
        text: generalTitle
        font.pixelSize: tailleCarre/9
        horizontalAlignment: Text.AlignHCenter
        width:rootColumn.width
        color: "#FCFCFC"
        //padding: 10
    }
    FLODDrawArc
    {
        id: arcCentral
        tailleCarre: rootColumn.tailleCarre
        extension: rootColumn.extension
        epaisseur: rootColumn.epaisseur
        blTitre: rootColumn.blTitre
        flodArcTitle: rootColumn.flodArcTitle
        arCouleur: rootColumn.arCouleur
        maxValue: rootColumn.maxValue
        visible: lblShowSingle
    }

    FLOD_DoubleArc
    {
        id: arcCentral_Double
        tailleCarre: rootColumn.tailleCarre
        extension: rootColumn.extension
        epaisseur: rootColumn.epaisseur
        blTitre: rootColumn.blTitre
        flodArcTitle: rootColumn.flodArcTitle
        arCouleur: rootColumn.arCouleur
        maxValue: rootColumn.maxValue
        visible: lblShowDouble
        extension2 : rootColumn.extension2
        blDoubleDisplay: rootColumn.blDoubleDisplay

        onBlDoubleDisplayChanged:
        {
            rootColumn.blDoubleDisplay = blDoubleDisplay;
        }


    }
}
