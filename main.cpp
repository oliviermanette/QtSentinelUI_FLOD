#include <QCoreApplication>
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>

#include "getaccinfo.h"

#include <QtCore/QCommandLineParser>
#include <QtCore/QCommandLineOption>
#include "ptmserver.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    bool debug = true;
    quint16 port = 1234;
    PTMServer *server = new PTMServer(port, debug);

    QScopedPointer<getAccInfo> accInfo(new getAccInfo);
    QScopedPointer<PTMServer> myPTMSServer(server);
    QObject::connect(server, &PTMServer::closed, &app, &QCoreApplication::quit);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("accInfo", accInfo.data());
    engine.rootContext()->setContextProperty("myPTMSServer", myPTMSServer.data());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    return app.exec();
}
