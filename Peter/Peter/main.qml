import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 400
    height: 800

    property string defaultIconFamily: font.name
    property string defaultIconColor: Qt.rgba(233/255,30/255,99/255,1)
    FontLoader{
        id: font
        source: "./Font/fontawesome-webfont.ttf"
    }


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        TcpClientPage{

        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Page 1")
        }
        TabButton {
            text: qsTr("Page 2")
        }
        TabButton {
            text: qsTr("Page 3")
        }
    }
}
