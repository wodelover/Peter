#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <initfile.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    TcpClientCom tcpClientCom;
    engine.rootContext()->setContextProperty("TcpClientCom", &tcpClientCom);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
