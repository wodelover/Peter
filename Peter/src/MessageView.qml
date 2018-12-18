/***************************************************************************************************************/
/*                                             Copyright Notice                                               */
/* The code can not be copied or provided to other people without the      */
/* permission of Zhang Hao,otherwise intellectual property infringement  */
/* will be prosecuted.If you have any questions,please send me an email.   */
/* My email is kingderzhang@foxmail.com. The final interpretation rights */
/* are interpreted by ZhangHao.                                                                     */
/*                  Copyright (C) ZhangHao All rights reserved                              */
/***************************************************************************************************************/

import QtQuick 2.7
import QtQuick.Controls 2.3

/**
 * @Title: MessageAreaPage
 * @FileName: MessageAreaPage
 * @Description: 消息提示区域
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-10-28 21:02:39
 * @update_author
 * @update_time
 * @version V1.0
*/
Item {
    property int currentValue: 0 //当前选中项索引
    property int duration: 5    //每一项之间的间隔

    function addItem(ip,port,time,data){
        settingModel.append({recvMessageIP:ip,recvMessagePort:port,
                            recvMessageTime:time,recvMessageData:data})
    }

    function delAllItem(){
        settingModel.clear()
    }

    ListModel{//模型数据
        id: settingModel
//        ListElement{
//            recvMessageIP: qsTr("1111111")
//            recvMessagePort: qsTr("1234")
//            recvMessageTime: "下午5:10"
//            recvMessageData: "/Image/123132333333333333333333333333333333333.png"
//        }
    }

    Component{//单个子项组件
        id: settingDelegate
        Item{
            id: delegateItem
            width: parent.width
            height: data.height + baseinfo.height + backLine.height * 2 + duration * 2
            Column{
                anchors.fill: parent
                anchors.topMargin: 5
                spacing: 5
                Row{
                    id: baseinfo
                    spacing: 5
                    Text {
                        text: recvMessageTime
                    }
                    Text {
                        text: recvMessageIP
                    }
                    Text {
                        text: recvMessagePort
                    }
                }
                Text {
                    id: data
                    width: parent.width
                    text: recvMessageData
                    wrapMode: Text.WrapAnywhere
                }
            }

            Rectangle{
                id: backLine
                y: parent.height
                width: parent.width
                height: 1
                color: "grey"
            }

            MouseArea{ //单独一项鼠标处理事件
                anchors.fill: parent
                onClicked: {
                    delegateItem.ListView.view.currentIndex = index
                }
            }
        }
    }
    Component{//高亮背景组件
        id: settingHightLight
        Rectangle {
            id: idBackGrdImg
            radius: 5
            color: "grey"
            opacity: 0.3
        }
    }
    ScrollView {
        id: settingScrollView
        anchors.fill: parent
        clip: true
        ListView {
            id: settingListView
            anchors.fill: parent
            model: settingModel
            delegate: settingDelegate
            highlight: settingHightLight
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 80 // 设置移动选中项的过渡时间
            highlightRangeMode: ListView.NoHighlightRange//设置内容自动滚动的方式
        }
    }

}
