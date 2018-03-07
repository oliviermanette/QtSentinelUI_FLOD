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

    QScopedPointer<getAccInfo> accInfo(new getAccInfo);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;
    engine.rootContext()->setContextProperty("accInfo", accInfo.data());

    bool debug = true;
    int port = 1234;

    PTMServer *server = new PTMServer(port, debug);
    QScopedPointer<PTMServer> myPTMSServer(server);
    //qmlRegisterType<server>("aero.flod.ptms", 1, 0, "Ptmserver");
    //static <myPTMSServer> *closed();
    QObject::connect(server, &PTMServer::closed, &app, &QCoreApplication::quit);

    engine.rootContext()->setContextProperty("myPTMSServer", myPTMSServer.data());

    return app.exec();
}
