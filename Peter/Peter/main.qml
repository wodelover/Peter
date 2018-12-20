import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 400
    height: 800
//    flags: Qt.FramelessWindowHint | Qt.Window

    Item {//按键处理事件
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            switch(event.key){
                case Qt.Key_Escape:
                    Qt.quit()
                    break;
            }
        }
    }

    property string defaultIconFamily: fontawesome.name
    property string defaultIconColor: Qt.rgba(233/255,30/255,99/255,1)
    FontLoader{
        id: fontawesome
        source: "./Font/fontawesome-webfont.ttf"
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        TcpClientPage{
        }
        TcpServerPage{
        }
        HttpClientPage{
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            font.family:  defaultIconFamily
            text: qsTr("\uf10a")
            font.pointSize: 20
        }
        TabButton {
            font.family:  defaultIconFamily
            text: qsTr("\uf108")
            font.pointSize: 20
        }
        TabButton {
            font.family:  defaultIconFamily
            text: qsTr("\uf26b")
            font.pointSize: 20
        }
    }
}
