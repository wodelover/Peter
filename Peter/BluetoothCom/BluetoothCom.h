/*************************************************************************/
/*                          Copyright Notice                             */
/* The code can not be copied or provided to other people without the    */
/* permission of Zhang Hao,otherwise intellectual property infringement  */
/* will be prosecuted.If you have any questions,please send me an email. */
/* My email is kingderzhang@foxmail.com. The final interpretation rights */
/* are interpreted by ZhangHao.                                          */
/*                  Copyright (C) ZhangHao All rights reserved           */
/*************************************************************************/

#ifndef BLUETOOTHCOM_H
#define BLUETOOTHCOM_H

//bluetooth header files
#include <bluetoothcom_global.h>
//#include <QtBluetooth/qbluetoothglobal.h>
#include <QtBluetooth/qbluetoothlocaldevice.h>
#include <QtBluetooth/qbluetoothaddress.h>
#include <QtBluetooth/qbluetoothdevicediscoveryagent.h>
#include <QtBluetooth/qbluetooth.h>
#include <QtBluetooth/qbluetoothsocket.h>

#include <QObject>
#include <QByteArray>
#include <QVariant>
#include <QMap>
#include <QList>

/**
 * @ClassName: BluetoothCom
 * @Description: 蓝牙通信模块,如果配置后不能运行,需要将AndroidManifest.xml
 * 文件删除重新配置
 * 否则将会导致蓝牙模块不可用
 * @Autor: zhanghao kinderzhang@foxmail.com
 * @date: 2018-12-21 09:01:12
 * @Version: 1.0.0
 * @update_autor
 * @update_time
**/
class BLUETOOTHCOMSHARED_EXPORT BluetoothCom : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uuid READ uuid WRITE setUuid NOTIFY uuidChanged)

    // 暂时未实现此功能
    Q_PROPERTY(int protocol READ protocol WRITE setProtocol NOTIFY protocolChanged)

public:
    Q_ENUMS(ComProtocol)
    enum ComProtocol{
        L2capProtocol = 1,
        RfcommProtocol = 2
    };

    explicit BluetoothCom(QObject *parent = nullptr);
    ~BluetoothCom();
    /**
     * @MethodName: uuid
     * @Description: 获取当前的UUID
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 14:26:51
     * @Version: 1.0.0
    **/
    Q_INVOKABLE QString uuid();

    /**
     * @MethodName: setUuid
     * @Description: 设置UUID
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 14:27:16
     * @Version: 1.0.0
     * @Parma: [QString] uuid值
    **/
    Q_INVOKABLE void setUuid(QString uuid);

    /**
     * @MethodName: protocol
     * @Description: 返回通信协议
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 14:44:51
     * @Version: 1.0.0
    **/
    Q_INVOKABLE int protocol();
    /**
     * @MethodName: setProtocol
     * @Description: 设置通信协议
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 14:45:28
     * @Version: 1.0.0
     * @Parma: [ComProtocol]  protocol 通信协议
    **/
    Q_INVOKABLE void setProtocol(int protocol = RfcommProtocol);

    /**
     * @MethodName: openBluetooth
     * @Description: 打开蓝牙
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @Version: 1.0.0
    **/
    Q_INVOKABLE void openBluetooth();

    /**
     * @MethodName: closeBluetooth
     * @Description: 关闭蓝牙
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @Version: 1.0.0
    **/
    Q_INVOKABLE void closeBluetooth();

    /**
     * @MethodName: setBluetoothDiscoverd
     * @Description: 设备蓝牙设备可见
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 14:14:23
     * @Version: 1.0.0
    **/
    Q_INVOKABLE void setBluetoothDiscoverd();

    /**
     * @MethodName: searchDevice
     * @Description: 搜索附近的蓝牙设备
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @Version: 1.0.0
    **/
    Q_INVOKABLE void searchDevice();

    /**
     * @MethodName: getAvailableDevices
     * @Description:  获取当前系统可用的设备[名字,地址]
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-28 09:24:14
     * @Version: 1.0.0
     * @return: [QMap<QString,QString>] [名字,地址]
    **/
    Q_INVOKABLE QMap<QString,QString> getAvailableDevices();
    Q_INVOKABLE QStringList getAvailableDevicesList();

    /**
     * @MethodName: connectDevice
     * @Description: 通过蓝牙地址连接蓝牙设备
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @Version: 1.0.0
     * @Parma: [QString] addres 设备地址
    **/
    Q_INVOKABLE void connectDevice(QString addres);

    /**
     * @MethodName: disConnectDevice
     * @Description: 断开蓝牙设备
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @Version: 1.0.0
    **/
    Q_INVOKABLE void disConnectDevice();

    /**
     * @MethodName: sendDataToRemoteDevice
     * @Description: 发送数据到对端蓝牙设备
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-21 13:32:02
     * @version: 1.0.0
     * @param: [QByteArray] senddata 待发送的数据=
    **/
    Q_INVOKABLE long long sendDataToRemoteDevice(QByteArray senddata);

    /**
     * @MethodName: getDataFromBuffer
     * @Description: 从缓冲区获取数据,默认全部读取数据
     * @Autor: ZhangHao kinderzhang@foxmail.com
     * @date: 2018-12-10 14:09:17
     * @Version: 1.0.0
     * @Parma: [long long] size 获取数据大小
    **/
    Q_INVOKABLE QByteArray getDataFromBuffer(long long size = 0);


private slots:
    void newDeviceDiscovered(QBluetoothDeviceInfo device);//发现设备处理函数

signals:
    void hasDataComeFromRemoteDevice();
    void hasNewDeviceFounded(QString name,QString addr);
    void connected();
    void disConnected();
    void uuidChanged(QString uuid);
    void protocolChanged(int protocol);
    void stateChanged(QBluetoothSocket::SocketState socketState);

private:
    QBluetoothDeviceDiscoveryAgent *m_discoveryAgent;//用于发现周围设备
    QBluetoothLocalDevice *m_localDevice;//用于操作本地蓝牙
    QBluetoothSocket *m_socket;//用于进行数据通信
    //默认使用串口通信UUID，如需使用其他模式，需要指定对应的UUID值
    QString m_uuid = "00001101-0000-1000-8000-00805F9B34FB";
    ComProtocol m_protocol = RfcommProtocol;
};

#endif // BLUETOOTHCOM_H
