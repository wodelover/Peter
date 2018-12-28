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
import QtQuick.Controls 2.7

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
    function openPopup(){
        popue.open()
    }

    function closePopup(){
        popue.close()
    }

    function delAllItem(){
        settingModel.clear()
    }

    Popup{
        id: popue
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        ScrollView{
            anchors.fill: parent
            clip: true
            ListView {
                id: settingListView
                model: settingModel
                delegate: settingDelegate
                highlightFollowsCurrentItem: true
                highlightMoveDuration: 80 // 设置移动选中项的过渡时间
                highlightRangeMode: ListView.NoHighlightRange//设置内容自动滚动的方式
            }
        }
    }

    ListModel{//模型数据
        id: settingModel
        ListElement{
            imgPath: "/Image/Image/supportme.png"
        }
    }

    Component{//单个子项组件
        id: settingDelegate
        Item{
            width: mainwindow.width
            height: image.height
            Image {
                id: image
                source: imgPath
            }
            Component.onCompleted: {
                var oldwidth = image.width
                var oldheight = image.height
                image.width = (mainwindow.width - popue.width * 3)
                image.height = image.width * oldheight / oldwidth
            }
        }
    }

}
