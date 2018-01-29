import QtQuick 2.0
Canvas
{
    property string flodArcTitle: "Nom"
    property bool cblOnce: true
    property bool blTitre: false
    property int epaisseur: 30
    property int extension: 50 //angle exprimé en pourcentage %
    property int extension2: 80 //angle exprimé en pourcentage %
    property bool blDoubleDisplay: false
    property real gDistance: 10
    property int tailleCarre:200
    property string arCouleur: "#C00000"
    property int maxValue:100
    width: tailleCarre
    height: tailleCarre


    id: dessin
    function displayArc(angle, angle2)
    {
        var ctx = getContext("2d");
        ctx.reset();

        var centreX = dessin.width / 2;
        var centreY = dessin.height / 2;
        var bordurePT = 2.5;
        if (dessin.width<140)
            bordurePT = 3;

        ctx.beginPath();
        ctx.strokeStyle = arCouleur;
        //ctx.moveTo(centreX, centreY);
        ctx.arc(centreX, centreY, dessin.width / bordurePT, -0.5*Math.PI, Math.PI * angle, false);
        //ctx.lineTo(centreX, centreY);
        ctx.lineWidth=(dessin.width / bordurePT)*epaisseur/200;
        ctx.lineCap="round";
        ctx.stroke();
        ctx.beginPath();
        //ctx.moveTo(centreX, centreY);
        ctx.strokeStyle = "black";
        ctx.arc(centreX, centreY, dessin.width / 3.7, -0.5*Math.PI, Math.PI * angle2, false);

        ctx.stroke();

        requestPaint();

        if (blTitre)
            valeurCentrale.text= flodArcTitle;
        else
        {
            if (blDoubleDisplay==false)
                valeurCentrale.text = extension.toString();
            else
                valeurCentrale.text = extension2.toString()+ " (g)";
        }
        return 0;
    }

    function convertExtensionToAngle(valeurExtension)
    {
        return (((valeurExtension/maxValue*100) -25)/50.0)
    }

    onExtensionChanged:
    {
        requestPaint();
    }
    onExtension2Changed:
    {
        //blDoubleDisplay = false;
        valeurCentrale.text = extension.toString();
    }

    onPaint:
    {
        //if (cblOnce)
        //{
            displayArc(convertExtensionToAngle(extension), convertExtensionToAngle(extension2));
            requestPaint();
            cblOnce=false;
        //}
    }

    Text {
        id: valeurCentrale

        x: dessin.width/2-width/2
        y:dessin.height/2-height/2
        font.pixelSize: dessin.width/5
        color: "#FCFCFC"
    }

    MouseArea
    {
        id: mouser1
        anchors.fill: parent
        onClicked:
        {
            dessin.opacity=1;           

            if (blDoubleDisplay==false)
                blDoubleDisplay = true;
            else
                blDoubleDisplay = false;

            displayArc(convertExtensionToAngle(extension),convertExtensionToAngle(extension2));
            requestPaint();
        }

        onPressed: {
            dessin.opacity=0.5;
        }

    }
}
