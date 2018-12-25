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
 * @ClassName: BlueToothPage
 * @Description: 蓝牙通信页面
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-24 13:39:41
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
Item {
    id: bluetoothPage
    property int rxCnt: 0
    property int txCnt: 0
    property string newData: ""

    Connections{
//        target: TcpClientCom
//        onHasNewDataFromServer:{
//            newData = TcpClientCom.getDataFromBuffer()
//            rxCnt  += newData.length
//            var time = new Date()
//            recvTextArea.insertItem(iptext.text,ipport.text,time.toLocaleTimeString() ,newData)
//        }
//        onConnected:{
//            stateIcon.color = "limegreen"
//            stateText.text = "Connected"
//            connectSwitch.checked = true
//        }
//        onDisconnected:{
//            stateIcon.color = defaultIconColor
//            stateText.text = "UnConnected"
//            connectSwitch.checked = false
//        }
    }

    function sendDataToRemoteDevice(){
        var senddata = sendTextArea.text
        if(enterNextColum.checked){
            senddata += "\r\n"
        }
        var len  = senddata.length
        if(len){
            TcpClientCom.sendDataToRemoteDevice(senddata)
            txCnt += len
        }
    }

    Item{//中间接收数据区域
        id: recvArea
        y: topConfig.height
        width: parent.width
        height: bluetoothPage.height - sendRecv.height - topConfig.height - middleConfig.height - 20
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
        height: uuidText.height
        Frame{
            x: parent.width * 0.01
            y: 2
            width: parent.width * 0.98
            height: parent.height
            TextField{
                id: uuidText
                width: parent.width - scanButton.width - uuidButton.width - 8
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
//                placeholderText: BluetoothCom.uuid
            }

            Button{
                id: uuidButton
                height: uuidText.height
                anchors.right: scanButton.left
                anchors.rightMargin: 5
                highlighted: true
                text: qsTr("SetUUid")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    var uuid = uuidText.text
                    if(uuid.length>10){
//                        BluetoothCom.setUuid(uuid)
                    }
                }
            }

            Button{
                id: scanButton
                height: uuidText.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                highlighted: true
                text: qsTr("Scan")
                onClicked: scanListDevice.openPopup()
            }
        }
    }

    Item{//中间配置区域
        id: middleConfig
        anchors.bottom: sendRecv.top
        anchors.bottomMargin: 8
        width: parent.width
        height: uuidText.height * 2 - 5
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: uuidText.height * 2
            anchors.centerIn: parent
            Item{
                y: -10
                width: parent.width
                height: uuidText.height

                ComboBox{
                    height: uuidText.height
                    width: parent.width - stateIcon.width - stateText.width - openSwitch.width - 30
                    model: ["L2capProtocol","RfcommProtocol"]
                    currentIndex: 1
                    onCurrentIndexChanged: {

                    }
                }

                Text {
                    id: stateIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: stateText.left
                    anchors.rightMargin: 10
                    text: qsTr("\uf1e6")
                    color: defaultIconColor
                    font.family: defaultIconFamily
                }

                Text {
                    id: stateText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: openSwitch.left
                    anchors.rightMargin: 10
                    text: qsTr("UnConeted")
                }

                Switch{
                    id: openSwitch
                    anchors.right: parent.right
                    height: uuidText.height
                    onCheckedChanged: {
                        if(checked){
                            BluetoothCom.openBluetooth()
                        }else{
                            BluetoothCom.closeBluetooth()
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: rX.height
                y: uuidText.height

                Text {
                    id: rX
                    text: qsTr("Rx: ") + rxCnt
                }
                Text {
                    id: tX
                    anchors.horizontalCenter:  parent.horizontalCenter
                    anchors.horizontalCenterOffset: -width / 2
                    text: qsTr("Tx: ") + txCnt
                }
                Button{
                    x: parent.width - width
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    highlighted: true
                    text:  qsTr("Reset")
                    onClicked: {
                        rxCnt = 0
                        txCnt = 0
                        recvTextArea.delAllItem()
                    }
                }
            }
        }
    }

    Item{//底部发送数据区域
        id: sendRecv
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        width: parent.width
        height: sendTextArea.height
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: parent.height
            ScrollView{
                clip: true
                width: parent.width - sendButton.width - 5
                height: sendButton.height
                anchors.verticalCenter: parent.verticalCenter
                TextArea{
                    id: sendTextArea
                    selectByMouse: true
                    wrapMode: TextEdit.WrapAnywhere
                    placeholderText: "Input msg which you want send"
                    onHeightChanged: {
                        if(height>80)
                            height = 80
                    }
                    onTextChanged: {
                        if(sendTextArea.text.length){
                            sendButton.enabled = true
                        }else{
                            sendButton.enabled = false
                        }
                    }
                }
            }
            Button{
                id: sendButton
                x: parent.width - sendButton.width
                height: sendTextArea.height
                text: qsTr("send")
                highlighted: true
                enabled: false
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    sendDataToRemoteDevice()
                }
            }
        }
    }
}
