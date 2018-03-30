import QtQuick 2.7

Row {
    property int lintIndex: -1
    property int lintIndividu:-1
    spacing: 20
    Text {
        id: sessionText
        color: "white"
        text: qsTr("text")
    }
    Text{
        id: sessionDuree
        text: "0"
        color: "light blue"
    }

    onLintIndexChanged:
    {
        sessionText.text = accInfo.getSessiondDate(lintIndividu, lintIndex);
        sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintIndex);
    }

    onVisibleChanged:
    {
        sessionText.text = accInfo.getSessiondDate(lintIndividu, lintIndex);
        sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintIndex);

    }

    MouseArea{
       // anchors.fill: parent

    }

}
