/*************************************************************************/
/*                          Copyright Notice                             */
/* The code can not be copied or provided to other people without the    */
/* permission of Zhang Hao,otherwise intellectual property infringement  */
/* will be prosecuted.If you have any questions,please send me an email. */
/* My email is kingderzhang@foxmail.com. The final interpretation rights */
/* are interpreted by ZhangHao.                                          */
/*                  Copyright (C) ZhangHao All rights reserved           */
/*************************************************************************/

#ifndef HTTPCOM_H
#define HTTPCOM_H

#include "httpcom_global.h"
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QByteArray>

/**
 * @Title: HttpCom
 * @FileName: HttpCom
 * @Description: 用于Http通信
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-10-22 21:39:33
 * @update_author
 * @update_time
 * @version V1.0
*/
class HTTPCOMSHARED_EXPORT HttpCom : public QObject
{
    Q_OBJECT //需要引用的模块中添加network模块，否则编译找不到文件
public:
    HttpCom();
    ~HttpCom();
    /**
     * @MethodName: sendDataToServerByPost
     * @ClassName: HttpCom
     * @Description: 通过post发送数据到服务器,获取到数据将通过信号发出
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-10-23 13:13:09
     * @Version: 1.0.0
     * @update_autor
     * @update_time
     * @Parma: [QUrl] url 服务器接收数据API
     * @Parma: [QByteArray] data 需要发送的数据
     * @Return: [void]
    **/
    Q_INVOKABLE void sendDataToServerByPost(QUrl url,QByteArray data);

    /**
     * @MethodName: sendDataToServerByPost
     * @ClassName: HttpCom
     * @Description: 通过post发送数据到服务器,获取到数据将通过信号发出
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-10-23 13:13:09
     * @Version: 1.0.0
     * @update_autor
     * @update_time
     * @Parma: [QString] url 服务器接收数据API
     * @Parma: [QByteArray] data 需要发送的数据
     * @Return: [void]
    **/
    Q_INVOKABLE void sendDataToServerByPost(QString url,QByteArray data);

    /**
     * @MethodName: getDataFromServerByGet
     * @ClassName: HttpCom
     * @Description: 从服务器上获取数据,获取到数据将通过信号发出
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-10-23 13:13:09
     * @Version: 1.0.0
     * @update_autor
     * @update_time
     * @Parma: [QUrl] url 服务器接收数据API
     * @Return: [void]
    **/
    Q_INVOKABLE void getDataFromServerByGet(QUrl url);

    /**
     * @MethodName: getDataFromServerByGet
     * @ClassName: HttpCom
     * @Description: 从服务器上获取数据,获取到数据将通过信号发出
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-10-23 13:13:09
     * @Version: 1.0.0
     * @update_autor
     * @update_time
     * @Parma: [QString] url 服务器接收数据API
     * @Return: [void]
    **/
    Q_INVOKABLE void getDataFromServerByGet(QString url);

    /**
     * @MethodName: setrequestRawHeader
     * @ClassName: HttpCom
     * @Description: 设置访问信息的头部信息
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-10-23 13:16:56
     * @Version: 1.0.0
     * @update_autor
     * @update_time
     * @Parma: [QByteArray] 键名
     * @Parma: [QByteArray] 键值
     * @Return: [void]
    **/
    Q_INVOKABLE void setRequestRawHeader(QByteArray key, QByteArray value);

    Q_INVOKABLE void setRequestHeader(QNetworkRequest::KnownHeaders header,QVariant value);

private slots:
    void requestFinished();
    void slotError(QNetworkReply::NetworkError errCode);

signals:
    void hasDataComeFromServer(QByteArray data);//接收到数据后会通过此信号发送出去
    void requestError(int errorCode);

private:
    QNetworkAccessManager *m_manager;
    QNetworkRequest *m_request;
    QNetworkReply *m_reply;
};

#endif // HTTPCOM_H
