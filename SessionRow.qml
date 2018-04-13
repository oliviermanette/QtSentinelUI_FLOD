import QtQuick 2.7

Row {
    property int lintIndex: -1
    property int lintIndividu:-1
    property int lintSessionId: -1

    function clickSessionLine()
    {
        columnDetailSessions.lintIndividu = lintIndividu;
        columnDetailSessions.lintIndex = lintIndex;
        columnDetailSessions.lintSessionId = lintSessionId;
    }

    spacing: 20
    Text {
        id: sessionText
        color: "white"
        text: qsTr("text")
        font.pixelSize:fontSize
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();

          }
        }
    }
    Text{
        id: sessionDuree
        text: "0"
        font.pixelSize:fontSize
        color: "#DCECF2"
        width: 55
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();

          }
        }
    }

    onLintIndexChanged:
    {
        sessionText.text = accInfo.getSessiondDate(lintIndividu, lintIndex);
        sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintIndex);
        lintSessionId = accInfo.getSessionID(lintIndividu, lintIndex);
    }

    onVisibleChanged:
    {
        sessionText.text = accInfo.getSessiondDate(lintIndividu, lintIndex);
        sessionDuree.text = accInfo.getSessionDuration(lintIndividu, lintIndex);
        lintSessionId = accInfo.getSessionID(lintIndividu, lintIndex);
    }

    Text {
        text: "Voir ..."
        font.bold: true
        color: "pink"
        font.pixelSize:fontSize
        MouseArea{
          anchors.fill: parent
          onClicked: {
              clickSessionLine();

          }
        }
    }
}
