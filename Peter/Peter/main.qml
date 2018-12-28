import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.3

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 400
    height: 800

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


    property var tittleName: [
        qsTr("TCP Client"),
        qsTr("TCP Server"),
        qsTr("HTTP Client"),
        qsTr("BlueTooth")
    ]

    SupportMePage{
        id: supportme
        anchors.fill: parent
    }

    ListPopupView{
        id: scanListDevice
        anchors.fill: parent
    }

    Pane{
        id: tittle
        width: mainwindow.width
        height: tabBar.height
        contentWidth: mainwindow.width
        contentHeight: tabBar.height
        padding: 0
        Material.elevation: 3
        Rectangle{
            anchors.fill: parent
            color: defaultIconColor
            Button {
                flat: true
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                width: parent.height * 0.8
                Text {
                    anchors.centerIn: parent
                    font.family: defaultIconFamily
                    text: "\uf02d"
                    color: "white"
                    font.pixelSize: parent.height * 0.8
                }
                onClicked: {
                }
            }

            Text {
                id: pageTittle
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: tittleName[swipeView.currentIndex]
                font.pointSize: parent.height / 2
                color: "white"
                font.bold: true
            }

            Button {
                anchors.right: parent.right
                width: parent.height * 0.8
                flat: true
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.centerIn: parent
                    font.family: defaultIconFamily
                    text: "\uf029"
                    color: "white"
                    font.pixelSize: parent.height * 0.8
                }

                onClicked: {
                    supportme.openPopup()
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        width: parent.width
        height: parent.height - tittle.height
        y: tittle.height
        currentIndex: tabBar.currentIndex

        TcpClientPage{
        }
        TcpServerPage{
        }
        HttpClientPage{
        }
        BlueToothPage{
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
        TabButton {
            font.family:  defaultIconFamily
            text: qsTr("\uf293")
            font.pointSize: 20
        }
    }
}
