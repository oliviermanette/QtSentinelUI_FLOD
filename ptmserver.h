#ifndef PTMSERVER_H
#define PTMSERVER_H

#include <QObject>
#include <QtCore/QList>
#include <QtCore/QByteArray>
#include <QtWebSockets/qwebsocket.h>
#include <QtWebSockets/qwebsocketserver.h>

QT_FORWARD_DECLARE_CLASS(QWebSocketServer)
QT_FORWARD_DECLARE_CLASS(QWebSocket)

class PTMServer : public QObject
{
    Q_OBJECT
   // Q_PROPERTY(closed())
    //Q_PROPERTY(QDateTime creationDate READ creationDate WRITE setCreationDate NOTIFY creationDateChanged)
public:
    explicit PTMServer(quint16 port, bool debug = false, QObject *parent = Q_NULLPTR);
    ~PTMServer();

signals:
    void closed();
    void receivedMessage(QString message);

public slots:
    void onNewConnection();
    void processTextMessage(QString message);
    void processBinaryMessage(QByteArray message);
    void socketDisconnected();

private:
    QWebSocketServer *m_pWebSocketServer;
    QList<QWebSocket *> m_clients;
    bool m_debug;
};

#endif // PTMSERVER_H
