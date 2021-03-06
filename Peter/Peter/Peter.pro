QT += quick
CONFIG += c++11
QT += network bluetooth
# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \

HEADERS += \
    initfile.h \


RESOURCES += qml.qrc \
    font.qrc \
    image.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

#配置win系统显示图标
RC_ICONS = Image/system.ico
#配置Android系统，系统启动自定义入口文件：android:name="an.qt.QtFullscreenActivityAPP.QtFullscreenActivity"
ANDROID_PACKAGE_SOURCE_DIR = $$PWD/AndroidSource

DISTFILES += \
    AndroidSource/AndroidManifest.xml

#Tcp Client
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../TcpClientCom/release/ -lTcpClientCom
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../TcpClientCom/debug/ -lTcpClientCom
else:unix: LIBS += -L$$OUT_PWD/../TcpClientCom/ -lTcpClientCom
INCLUDEPATH += $$PWD/../TcpClientCom
DEPENDPATH += $$PWD/../TcpClientCom

#Tcp Server
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../TcpServerCom/release/ -lTcpServerCom
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../TcpServerCom/debug/ -lTcpServerCom
else:unix: LIBS += -L$$OUT_PWD/../TcpServerCom/ -lTcpServerCom
INCLUDEPATH += $$PWD/../TcpServerCom
DEPENDPATH += $$PWD/../TcpServerCom

#Http
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../HttpCom/release/ -lHttpCom
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../HttpCom/debug/ -lHttpCom
else:unix: LIBS += -L$$OUT_PWD/../HttpCom/ -lHttpCom
INCLUDEPATH += $$PWD/../HttpCom
DEPENDPATH += $$PWD/../HttpCom

#Bluetooth
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../BluetoothCom/release/ -lBluetoothCom
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../BluetoothCom/debug/ -lBluetoothCom
else:unix: LIBS += -L$$OUT_PWD/../BluetoothCom/ -lBluetoothCom
INCLUDEPATH += $$PWD/../BluetoothCom
DEPENDPATH += $$PWD/../BluetoothCom
