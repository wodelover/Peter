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
 * @ClassName: HttpClientPage
 * @Description: Http客户端页面
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-17 09:03:12
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
Item {
    id: httpClientPage
    property string newData: ""
    Connections{
        target: HttpClientCom
        onHasDataComeFromServer:{
            newData = data
            var time = new Date()
            recvTextArea.insertItem("","",time.toLocaleTimeString() ,newData)
        }
        onRequestError:{
            // http://home_office.alinejun.com/index/test
            var str = "Error Code: " + errorCode
            var time = new Date()
            recvTextArea.insertItem("Http Error","",time.toLocaleTimeString(),str)
        }
    }

    function sendDataToServerByPost(){
        var senddata = sendTextArea.text
        if(senddata.length>0){
            HttpClientCom.sendDataToServerByPost(sendUrlEdit.text,senddata)
        }
    }

    function getDataFromServerByGet(){
        var url = serverUrl.text
        if(url.length>0){
            HttpClientCom.getDataFromServerByGet(url)
        }
    }

    Item{//中间接收数据区域
        id: recvArea
        y: topConfig.height
        width: parent.width
        height: httpClientPage.height - sendRecv.height - topConfig.height - 5
        Frame{
            width: parent.width * 0.98
            height: parent.height * 0.98
            anchors.centerIn: parent

            Item {
                id: msgArea
                width: parent.width
                height: parent.height - cleanButton.height
                MessageView{
                    id: recvTextArea
                    anchors.fill: parent
                }
            }
            Item {
                y: msgArea.height
                width: parent.width
                height: cleanButton.height
                Button{
                    id: cleanButton
                    width: parent.width
                    font.family: defaultIconFamily
                    highlighted: true
                    font.pointSize: 18
                    flat: true
                    text: "\uf12d"
                    onClicked: {
                       recvTextArea.delAllItem()
                    }
                }
            }
        }
    }

    Item{//顶部配置区域
        id: topConfig
        width: parent.width
        height: serverUrl.height
        Frame{
            x: parent.width * 0.01
            y: 2
            width: parent.width * 0.98
            height: parent.height
            TextField{
                id: serverUrl
                width: parent.width - getButton.width - 5
                anchors.leftMargin: 5
                selectByMouse: true
                anchors.verticalCenter: parent.verticalCenter
                placeholderText: qsTr("Input Server Url(Get Data Server Address)...")
            }
            Button{
                id: getButton
                x: serverUrl.x + serverUrl.width + 5
                height: serverUrl.height
                anchors.verticalCenter: parent.verticalCenter
                font.family: defaultIconFamily
                enabled: serverUrl.text.length ? 1 : 0
                text: "\uf019"
                onClicked: {
                    getDataFromServerByGet()
                }
            }
        }
    }

    Item{//底部发送数据区域
        id: sendRecv
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        width: parent.width
        height: sendTextArea.height + sendUrlEdit.height
        Frame{
            x: parent.width * 0.01
            width: parent.width * 0.98
            height: parent.height

            TextField{ // 发送数据服务器URL
                id: sendUrlEdit
                y: -15
                width: parent.width
                selectByMouse: true
                placeholderText: qsTr("Input Server Url(Post Data Sever Address)...")
            }

            Frame{
                y: sendUrlEdit.y + sendUrlEdit.height
                width: parent.width
                height: sendTextArea.height - 5
                ScrollView{
                    clip: true
                    width: parent.width - sendButton.width - 5
                    height: sendTextArea.height
                    anchors.verticalCenter: parent.verticalCenter
                    TextArea{
                        id: sendTextArea
                        selectByMouse: true
                        wrapMode: TextEdit.WrapAnywhere
                        placeholderText: "Input data which you want post..."
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
                    x: parent.width - sendButton.width + 5
                    height: sendTextArea.height
                    font.family: defaultIconFamily
                    text: "\uf093"
                    highlighted: true
                    anchors.verticalCenter: parent.verticalCenter
                    enabled: sendUrlEdit.text.length ? 1 : 0
                    onClicked: {
                        sendDataToServerByPost()
                    }
                }
            }
        }
    }

}
