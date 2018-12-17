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
    Item{//顶部配置区域
        id: topConfig
        width: parent.width
        height: tcpClientPage.height * 0.1
        Rectangle{
            anchors.fill: parent
            color: "red"
        }
    }
    Item{//中间接收数据区域
        id: recvArea
        anchors.top: topConfig.bottom
        width: parent.width
        height: tcpClientPage.height * 0.5
        Rectangle{
            anchors.fill: parent
            color: "green"
        }
    }
    Item{//中间配置区域
        id: middleConfig
        anchors.top: recvArea.bottom
        width: parent.width
        height: tcpClientPage.height * 0.2
        Rectangle{
            anchors.fill: parent
            color: "blue"
        }
    }
    Item{//底部发送数据区域
        id: sendRecv
        anchors.top: middleConfig.bottom
        width: parent.width
        height: tcpClientPage.height * 0.2
        Rectangle{
            anchors.fill: parent
            color: "yellow"
        }
    }
}
