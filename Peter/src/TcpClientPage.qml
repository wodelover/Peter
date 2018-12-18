/*************************************************************************/
/*                          Copyright Notice                             */
/* The code can not be copied or provided to other people without the    */
/* permission of Zhang Hao,otherwise intellectual property infringement  */
/* will be prosecuted.If you have any questions,please send me an email. */
/* My email is kingderzhang@foxmail.com. The final interpretation rights */
/* are interpreted by ZhangHao.                                          */
/*                  Copyright (C) ZhangHao All rights reserved           */
/*************************************************************************/

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.12

/**
 * @ClassName: TcpClientPage
 * @Description: Tcp客户端页面
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-17 09:03:12
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
Item {
    id: tcpClientPage
    property int rxCnt: 0
    property int txCnt: 0

    Connections{
        target: TcpClientCom
        onHasNewDataFromServer:{
            console.log("asd")
            var data = TcpClientCom.getDataFromBuffer()
            rxCnt = data.lenth
            var time = new Date()
            recvTextArea.addItem(iptext,ipport,time.toString(),data)
        }
    }


    Item{//中间接收数据区域
        id: recvArea
        y: topConfig.height
        width: parent.width
        height: tcpClientPage.height - sendRecv.height - topConfig.height - middleConfig.height - 20
        Frame{
            width: parent.width * 0.98
            height: parent.height * 0.98
            anchors.centerIn: parent
            MessageView{
                id: recvTextArea
                anchors.fill: parent
            }
        }
    }

    Item{//顶部配置区域
        id: topConfig
        width: parent.width
        height: iptext.height
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: parent.height
            TextField{
                id: iptext
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Enter IP")
            }
            TextField{
                id: ipport
                anchors.left: iptext.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                width: 40
                placeholderText: qsTr("Port")
            }
            Switch{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 5
                onCheckedChanged: {
                    if(checked){
                        TcpClientCom.setServerIP(iptext.text)
                        TcpClientCom.setServerPort(ipport.text)
                        TcpClientCom.conectServer()
                    }else{
                        TcpClientCom.disConectServer()
                    }
                }
            }
        }
    }

    Item{//中间配置区域
        id: middleConfig
        anchors.bottom: sendRecv.top
        anchors.bottomMargin: 8
        width: parent.width
        height: sendDurationTime.height * 2 - 5
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: sendDurationTime.height * 2
            anchors.centerIn: parent
            Item{
                width: parent.width
                height: sendDurationTime.height
                Text {
                    id: sendTextTag
                    text: qsTr("间隔发送(ms)")
                }
                TextField{
                    id: sendDurationTime
                    x: sendTextTag.width
                    anchors.verticalCenter: sendTextTag.verticalCenter
                    width: 40
                }
                CheckBox{
                    id: sendDurationTimeCheck
                    x: sendTextTag.width + sendDurationTime.width
                    anchors.verticalCenter: sendTextTag.verticalCenter
                }
                CheckBox{
                    id: enterNextColum
                    x: enternextTag.x - width
                    anchors.verticalCenter: sendTextTag.verticalCenter
                }
                Text {
                    id: enternextTag
                    x: parent.width - width
                    anchors.verticalCenter: sendTextTag.verticalCenter
                    text: qsTr("回车换行")
                }
            }

            Item {
                width: parent.width
                height: rX.height
                y: sendDurationTime.height
                Text {
                    id: rX
                    text: qsTr("Rx: ") + rxCnt
                }
                Text {
                    id: tX
                    x: parent.width / 2
                    text: qsTr("Tx: ") + txCnt
                }
            }
        }
    }

    Item{//底部发送数据区域
        id: sendRecv
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: parent.width
        height: sendButton.height
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: parent.height
            ScrollView{
                clip: true
                width: parent.width - sendButton.width
                height: sendButton.height
                anchors.verticalCenter: parent.verticalCenter
                TextArea{
                    id: sendTextArea
                }
            }

            Button{
                id: sendButton
                x: parent.width - sendButton.width
                text: qsTr("send")
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    var senddata = sendTextArea.text
                    txCnt = senddata.length
                    TcpClientCom.sendDataToServer(senddata)
                }
            }
        }
    }
}
