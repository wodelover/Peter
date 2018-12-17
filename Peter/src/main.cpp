#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QString path = QCoreApplication::applicationDirPath();
    // 注册字体矢量图标库
    QFontDatabase::addApplicationFont(path + "/Font/fontawesome-webfont.ttf");
    QFontDatabase::addApplicationFont(path + "/Font/Imoon.ttf");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
