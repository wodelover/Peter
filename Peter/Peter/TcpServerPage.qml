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
 * @ClassName: TcpServerPage
 * @Description: Tcp服务器页面
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-17 09:03:12
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
Item {
    id: tcpServerPage
    property int rxCnt: 0
    property int txCnt: 0
    property int devCnt: clientModel.count - 1
    property string newData: ""
    Connections{
        target: TcpServerCom
        onHasNewDataFromClient:{
            newData = data
            rxCnt  += newData.length
            var time = new Date()
            recvTextArea.insertItem(ip,port,time.toLocaleTimeString(),newData)
        }
        onNewClientConnected:{
            var str = ip + " : " + port
            clientModel.append({text:str})
            stateIcon.color = "limegreen"
        }
        onClientDisConnected:{
            var str = ip + " : " + port
//            console.log(str)
            var index = clientBox.find(str)
//            console.log("index:"+index)
            if(index > 0)
            clientModel.remove(index)
            if(devCnt===0)
            stateIcon.color = defaultIconColor
        }
    }

    function sendDataToClient(){
        var senddata = sendTextArea.text
        if(enterNextColum.checked){
            senddata += "\r\n"
        }
        var len  = senddata.length
        if(len){

            if(clientBox.currentIndex===0){//send all
                TcpServerCom.sendDataToClient(senddata,"",1,true)
            }else{
                var str = clientBox.currentText.split(" : ")
                TcpServerCom.sendDataToClient(senddata,str[0],str[1])
            }
            txCnt += len
        }
    }

    Item{//中间接收数据区域
        id: recvArea
        y: topConfig.height
        width: parent.width
        height: tcpServerPage.height - sendRecv.height - topConfig.height - middleConfig.height - 20
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
            y: 2
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

            Text {
                id: stateIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: ipport.right
                anchors.leftMargin: 10
                text: qsTr("\uf10a")
                color: "grey"
                font.pixelSize: 25
                font.family: defaultIconFamily
            }

            Text {
                id: stateText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: stateIcon.right
                anchors.leftMargin: 10
                text: devCnt + qsTr(" Conected")
            }

            Switch{
                anchors.right: parent.right
                anchors.rightMargin: -15
                anchors.verticalCenter: parent.verticalCenter
                onCheckedChanged: {
                    if(checked){
                        TcpServerCom.setListenIP(iptext.text)
                        TcpServerCom.setListenPort(ipport.text)
                        TcpServerCom.listen(true)
                        TcpClientCom.conectServer()
                        iptext.enabled = false
                        ipport.enabled = false
                    }else{
                        TcpServerCom.listen(false)
                        TcpServerCom.disconnectedClient("",true)
                        iptext.enabled = true
                        ipport.enabled = true
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
                    onCheckedChanged: {
                        if(checked)
                        {
                            timer.start()
                        }else{
                            timer.stop()
                        }
                    }
                    Timer{
                        id: timer
                        running: false
                        repeat: true
                        interval: parseInt(sendDurationTime.text)
                        onTriggered: sendDataToClient()
                    }
                }

                Text {
                    id: rX
                    anchors.verticalCenter: sendTextTag.verticalCenter
                    x: sendDurationTimeCheck.x + sendDurationTimeCheck.width
                    text: qsTr("Rx: ") + rxCnt
                }

                Text {
                    id: tX
                    anchors.verticalCenter: sendTextTag.verticalCenter
                    x: enternextTag.x - width - 30
                    text: qsTr("Tx: ") + txCnt
                }

                CheckBox{
                    id: enterNextColum
                    x: parent.width - width + 10
                    anchors.verticalCenter: sendTextTag.verticalCenter
                }
                Text {
                    id: enternextTag
                    x: enterNextColum.x - width
                    anchors.verticalCenter: sendTextTag.verticalCenter
                    text: qsTr("回车换行")
                }
            }

            Item {
                width: parent.width
                height: rX.height
                y: sendDurationTime.height
                ComboBox {
                    id: clientBox
                    width: parent.width - resetButton.width - disconnectButton.width - 20
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    model: ListModel{
                        id: clientModel
                        ListElement{text:"All Connections"}
                    }
                }
                Button{//Disconnection Button
                    id: disconnectButton
                    x: resetButton.x - width - 5
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    highlighted: true
                    text: qsTr("\uf127")
                    font.family: defaultIconFamily
                    onClicked: {
                        if(clientBox.currentIndex===0){//colse all
                            TcpServerCom.disconnectedClient("",1,true)
                        }else{
                            var str = clientBox.currentText.split(" : ")
                            TcpServerCom.disconnectedClient(str[0],str[1])
                        }
                    }
                }
                Button{//Reset Button
                    id: resetButton
                    x: parent.width - width
                    height: 35
                    anchors.verticalCenter: parent.verticalCenter
                    highlighted: true
                    text: qsTr("Reset")
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
                    placeholderText: "Input msg data which you want to send"
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
                    sendDataToClient()
                }
            }
        }
    }
}
