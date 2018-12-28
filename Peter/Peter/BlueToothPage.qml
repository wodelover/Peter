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
    property var devices: []

    Connections{
        target: BluetoothCom

        onHasNewDeviceFounded:{
            scanListDevice.insertItem(name,addr)
        }

        onHasDataComeFromRemoteDevice:{
            newData = BluetoothCom.getDataFromBuffer()
            var time = new Date()
            recvTextArea.insertItem("","",time.toLocaleTimeString() ,newData)
            rxCnt += newData.length
        }

        onConnected:{
            stateTimer.stop()
            stateIcon.color = "limegreen"
            stateText.text = "Connected"
        }
        onDisConnected:{
            stateTimer.stop()
            stateIcon.color = defaultIconColor
            stateText.text = "UnConnected"
        }

        onStateChanged:{
            if(socketState == 2){
                stateText.text = "Connecting"
                stateTimer.start()
            }else if(socketState == 0){
                stateTimer.stop()
                stateIcon.color = defaultIconColor
                stateText.text = "UnConnected"
            }
        }
    }

    Component.onCompleted: {
        // 暂时无法做到对蓝牙当前的状态进行获取，后续升级改进
        BluetoothCom.closeBluetooth()
    }

    function sendDataToRemoteDevice(){
        var senddata = sendTextArea.text
        if(enterNextColum.checked){
            senddata += "\r\n"
        }
        var len  = senddata.length
        if(len){
            len = BluetoothCom.sendDataToRemoteDevice(senddata)
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
                width: parent.width - openSwitch.width - uuidButton.width - 8
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: BluetoothCom.uuid
            }

            Button{
                id: uuidButton
                height: uuidText.height
                anchors.right: openSwitch.left
                anchors.rightMargin: 5
                highlighted: true
                text: qsTr("SetUUid")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    var uuid = uuidText.text
                    if(uuid.length>10){
                        BluetoothCom.setUuid(uuid)
                    }
                }
            }
            Switch{
                id: openSwitch
                height: uuidText.height
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    if(checked){
                        BluetoothCom.openBluetooth()
                    }else{
                        BluetoothCom.closeBluetooth()
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

                Timer{
                    id: stateTimer
                    running: false
                    interval: 300
                    repeat: true
                    property bool cnn: false
                    onTriggered: {
                        if(cnn){
                            stateIcon.color = defaultIconColor
                        }else{
                            stateIcon.color = "limegreen"
                        }
                        cnn = !cnn
                    }
                }

                Text {
                    id: stateIcon
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("\uf1e6")
                    color: defaultIconColor
                    font.family: defaultIconFamily
                }

                Text {
                    id: stateText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: stateIcon.right
                    anchors.leftMargin: 10
                    text: qsTr("UnConeted")
                }

                Button{
                    id: disconectButton
                    anchors.right: enterNextColum.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: 35
                    highlighted: true
                    text: qsTr("\uf127")
                    font.family: defaultIconFamily
                    onClicked: {
                        BluetoothCom.disConnectDevice()
                    }
                }

                CheckBox{
                    id: enterNextColum
                    anchors.right: enternextTag.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: enternextTag
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("回车换行")
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
                    anchors.right: resetButton.left
                    anchors.rightMargin: 10
                    text: qsTr("Tx: ") + txCnt
                }
                Button{
                    id: resetButton
                    height: 35
                    anchors.right: scanButton.left
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    highlighted: true
                    text: qsTr("Reset")
                    onClicked: {
                        rxCnt = 0
                        txCnt = 0
                        recvTextArea.delAllItem()
                    }
                }
                Button{
                    id: scanButton
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: 35
                    highlighted: true
                    text: qsTr("Scan")
                    onClicked: {
                        scanListDevice.delAllItem()
                        BluetoothCom.searchDevice()
                        scanListDevice.openPopup()
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
