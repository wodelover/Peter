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
 * @ClassName: ListPopupView
 * @Description: 列表Popup显示
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-25 09:45:04
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

    property int currentValue: 0 //当前选中项索引
    property int duration: 5    //每一项之间的间隔

    function addItem(name,addr){
        settingModel.append({devNameText:name,devAddressText:addr})
//        settingListView.currentIndex = settingModel.count - 1
    }

    function insertItem(name,addr){
        settingModel.insert(0,{devNameText:name,devAddressText:addr})
//        settingListView.currentIndex = 0
    }

    function delAllItem(){
        settingModel.clear()
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
    }

    ListModel{//模型数据
        id: settingModel
    }

    Component{//单个子项组件
        id: settingDelegate
        Item{
            id: delegateItem
            width: parent.width
            height: devName.height + devAddress.height + backLine.height * 2 + duration * 2
            Column{
                anchors.fill: parent
                anchors.topMargin: 5
                spacing: 3

                Text {
                    id: devName
                    x: 5
                    text: "Name:" + devNameText
                }

                Text {
                    id: devAddress
                    x: 5
                    width: parent.width
                    text: "Addr:" + devAddressText
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
                onDoubleClicked: {
                    BluetoothCom.connectDevice(settingListView.model.get(delegateItem.ListView.view.currentIndex).devAddressText)
                    closePopup()
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
}
