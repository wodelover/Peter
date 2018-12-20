#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <initfile.h>
#include <QIcon>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon(QLatin1String(":/Image/Image/system.ico")));

    QQmlApplicationEngine engine;

    qRegisterMetaType<QAbstractSocket::SocketState>("QAbstractSocket::SocketState");

    // TcpClientCom
    TcpClientCom tcpClientCom;
    engine.rootContext()->setContextProperty("TcpClientCom", &tcpClientCom);

    // TcpServerCom
    TcpServerCom tcpServerCom;
    engine.rootContext()->setContextProperty("TcpServerCom", &tcpServerCom);

    // TcpServerCom
    HttpCom httpClientCom;
    engine.rootContext()->setContextProperty("HttpClientCom", &httpClientCom);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
