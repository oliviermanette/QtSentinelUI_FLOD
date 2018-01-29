import QtQuick 2.7
import QtQuick.Window 2.2



Window
{
    property bool gbolTotal: false
    width: 896
    height: 560
    property int generalPadding: 5//(width*height)/100000
    property int generalSpacing: 5//generalPadding
    property int extendedSpacing: 10//generalSpacing * 3
    property int tailleFLODArc: 80//(width*height)/5500
    property int smallFontSize: 5
    property int fontSize: 8
    property int bigFontSize: 12
    property int identifiantUser: 1

    property string serialNoG: ""
    property string serialNoD: ""

    id: root
    visible: true
    title: qsTr("Vauché Prevention des TMS - FLOD")
    color: "#606060"
    visibility:  Window.FullScreen // <<#*********************** A decommenter

}

