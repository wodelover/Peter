/*************************************************************************/
/*                          Copyright Notice                             */
/* The code can not be copied or provided to other people without the    */
/* permission of Zhang Hao,otherwise intellectual property infringement  */
/* will be prosecuted.If you have any questions,please send me an email. */
/* My email is kingderzhang@foxmail.com. The final interpretation rights */
/* are interpreted by ZhangHao.                                          */
/*                  Copyright (C) ZhangHao All rights reserved           */
/*************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 2.12

/**
 * @ClassName: SupportMePage
 * @Description: 支持我页面
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-24 14:31:09
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
Item {

    function openPage(){
        popue.open()
    }

    Popup{
        id: popue
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        ScrollView{
            anchors.fill: parent
            clip: true
            Image {
                anchors.centerIn: parent
                width: 400
                height: popue.contentHeight
                source: "/Image/Image/supportme.png"
            }
        }
    }
}
