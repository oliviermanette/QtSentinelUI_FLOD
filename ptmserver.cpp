#include "ptmserver.h"

#include <QtCore/QDebug>

QT_USE_NAMESPACE

PTMServer::PTMServer(quint16 port, bool debug, QObject *parent) :
    QObject(parent),
    m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Echo Server"),
                       QWebSocketServer::NonSecureMode, this)),
    m_debug(debug)
{
    if (m_pWebSocketServer->listen(QHostAddress::Any, port)) {
        if (m_debug)
            qDebug() << "PTMServer listening on port" << port;
        connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                this, &PTMServer::onNewConnection);
        connect(m_pWebSocketServer, &QWebSocketServer::closed, this, &PTMServer::closed);
    }
}

bool PTMServer::isOKStop(QString lstrSerialNo, QString lstrMontreG, QString lstrMontreD)
{
    if (lstrSerialNo.startsWith("okstop"))
        return (lstrSerialNo.contains(lstrMontreG)||lstrSerialNo.contains(lstrMontreD));
    else
        return false;
}

bool PTMServer::isRecording(QString lstrSerialNo, QString lstrMontreG, QString lstrMontreD)
{
    if (lstrSerialNo.startsWith("recording")|| lstrSerialNo.startsWith("arrecording"))
        return (lstrSerialNo.contains(lstrMontreG)||lstrSerialNo.contains(lstrMontreD));
    else
        return false;
}

bool PTMServer::isCanIStop(QString lstrSerialNo)
{
    return (lstrSerialNo.startsWith("canistop"));
}

PTMServer::~PTMServer()
{
    m_pWebSocketServer->close();

    qDeleteAll(m_clients.begin(), m_clients.end());
}

void PTMServer::onNewConnection()
{
    QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

    connect(pSocket, &QWebSocket::textMessageReceived, this, &PTMServer::processTextMessage);
    connect(pSocket, &QWebSocket::binaryMessageReceived, this, &PTMServer::processBinaryMessage);
    connect(pSocket, &QWebSocket::disconnected, this, &PTMServer::socketDisconnected);
    //connect()

    m_clients << pSocket;
}

void PTMServer::processTextMessage(QString message)
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (m_debug)
    {
        qDebug() << "Message received:" << message;

    }
    if (pClient) {
        pClient->sendTextMessage(message);


        emit receivedMessage(message);
    }
}

void PTMServer::processBinaryMessage(QByteArray message)
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (m_debug)
        qDebug() << "Binary Message received:" << message;
    if (pClient) {
        pClient->sendBinaryMessage(message);
    }
}

void PTMServer::socketDisconnected()
{
    QWebSocket *pClient = qobject_cast<QWebSocket *>(sender());
    if (m_debug)
        qDebug() << "socketDisconnected:" << pClient;
    if (pClient) {
        m_clients.removeAll(pClient);
        pClient->deleteLater();
    }
}
