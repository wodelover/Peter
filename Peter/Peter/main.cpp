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

    // TcpClientCom
    TcpClientCom tcpClientCom;
    // TcpServerCom
    TcpServerCom tcpServerCom;
    // HttpCom
    HttpCom httpClientCom;
    // BluetoothCom
    BluetoothCom blueToothCom;

    QQmlApplicationEngine engine;

    qRegisterMetaType<QAbstractSocket::SocketState>("QAbstractSocket::SocketState");

    engine.rootContext()->setContextProperty("TcpClientCom",&tcpClientCom);
    engine.rootContext()->setContextProperty("TcpServerCom",&tcpServerCom);
    engine.rootContext()->setContextProperty("HttpClientCom",&httpClientCom);
    engine.rootContext()->setContextProperty("BluetoothCom",&blueToothCom);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
