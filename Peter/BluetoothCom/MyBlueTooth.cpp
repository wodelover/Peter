#include "MyBlueTooth.h"

MyBlueTooth::MyBlueTooth(QObject *parent) : QObject(parent)
{
    //malloc memery
    localDevice = new QBluetoothLocalDevice(this);
    localDevice->setHostMode( QBluetoothLocalDevice::HostDiscoverable);
    discoveryAgent =new QBluetoothDeviceDiscoveryAgent(this);
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);

    connect(discoveryAgent,SIGNAL(deviceDiscovered( QBluetoothDeviceInfo )),
            this,SLOT(add_bluetoothDeviceTolist(QBluetoothDeviceInfo )));
    // Start a discovery
    discoveryAgent->start();

    connect(socket,SIGNAL(connected()),this,
            SLOT(blueToothConnectedEventSlot()));

    connect(socket,SIGNAL(disconnected()),
            this,SLOT(blueToothDisconnectedEventSlot()));

    connect(socket,SIGNAL(readyRead()),
            this,SLOT(readBluetoothDataEventSlot()));
}

/**
 * @Title: setIsCanbeDiscovered
 * @Class: MyBlueTooth
 * @Description: 设置蓝牙是否能够被发现
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 15:20:38
 * @update_author
 * @update_time
 * @version V1.0
 * @param
 * @param
 * @return
*/
void MyBlueTooth::setIsCanbeDiscovered(bool discover)
{
    switch (discover) {
    case true:
        localDevice->setHostMode( QBluetoothLocalDevice::HostConnectable);//设置可以连接
        break;
    case false:
        localDevice->setHostMode( QBluetoothLocalDevice::HostDiscoverable);//设置不能被发现
        break;
    default:
        localDevice->setHostMode( QBluetoothLocalDevice::HostDiscoverable);//设置不能被发现
        break;
    }
}

/**
 * @Title: openBluetooth
 * @Class: MyBlueTooth
 * @Description: 打开蓝牙
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 15:06:20
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::openBluetooth()
{
    localDevice->powerOn();

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 66: Bluetooth Power On.";
#endif

}

/**
 * @Title: closeBluetooth
 * @Class: MyBlueTooth
 * @Description: 关闭蓝牙
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 15:06:41
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::closeBluetooth()
{
    localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 86: Bluetooth Power Off.";
#endif
}

/**
 * @Title: disconnectBlutooth
 * @Class: MyBlueTooth
 * @Description: 断开蓝牙连接
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:01:54
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::disconnectBlutooth()
{
    socket->disconnectFromService();

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 105: Bluetooth Disconnected From Serivce.";
#endif
}

/**
 * @Title: connectedBlutooth
 * @Class: MyBlueTooth
 * @Description: 连接已经配对好的蓝牙
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:28:01
 * @update_author
 * @update_time
 * @version V1.0
 * @param 蓝牙16位短地址
*/
void MyBlueTooth::connectedBlutooth(const QString &bluetoothAddress)
{
    QBluetoothAddress address(bluetoothAddress);
    socket->connectToService(address, QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 126: Bluetooth connectedToSerivce.";
#endif
}

/**
 * @Title: sendDataToBluetooth
 * @Class: MyBlueTooth
 * @Description: 蓝牙发送数据
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:33:39
 * @update_author
 * @update_time
 * @version V1.0
 * @param 待发送的数据
 * @return 已经发送的字节数
*/
qint64 MyBlueTooth::sendDataToBluetooth(const  QString &data)
{
    QByteArray sendData = data.toUtf8();

#ifndef    DebugMode
     return socket->write(sendData);
#endif

#ifdef DebugMode
     qint64 len = socket->write(sendData);
     qDebug()<<"MyBlueTooth.cpp Line 154: Bluetooth Send length is:"<<len;
     qDebug()<<"MyBlueTooth.cpp Line 154: Bluetooth Send data is:"<<data;
     return len;
#endif

}

/**
 * @Title: blueToothConnectedEventSlot
 * @Class: MyBlueTooth
 * @Description: 蓝牙连接成功触发此函数
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:19:54
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::blueToothConnectedEventSlot()
{
    emit onblueToothConnectedEventSignal();

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 173: BlueToothConnected";
#endif
}

/**
 * @Title: blueToothDisconnectedEventSlot
 * @Class: MyBlueTooth
 * @Description: 蓝牙断开连接触发函数
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:20:25
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::blueToothDisconnectedEventSlot()
{
    emit onblueToothDisconnectedEventSignal();
#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 192: BlueToothDisconnected";
#endif
}

/**
 * @Title: readBluetoothDataEventSlot
 * @Class: MyBlueTooth
 * @Description: 读取蓝牙发送过来的数据
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:18:47
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::readBluetoothDataEventSlot()
{
    QString data(socket->readAll());

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 210: Bluetooth recive data is:"<<data;
#endif
    emit onreadBluetoothDataEventSignal(data);
}

/**
 * @Title: addbluetoothDeviceTolist
 * @Class: MyBlueTooth
 * @Description: 用于将搜索到的蓝牙添加到保存的列表中
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 16:04:50
 * @update_author
 * @update_time
 * @version V1.0
*/
void MyBlueTooth::addbluetoothDeviceTolistSlot(const QBluetoothDeviceInfo &info)
{
    //获取当前发现的蓝牙设备名称和地址
    QString dev = QString("%1 %2").arg(info.name()).arg(info.address().toString());

#ifdef DebugMode
    qDebug()<<"MyBlueTooth.cpp Line 231: Bluetooth Find Device:"<<dev;
#endif

    //判断是否已经在已存在的列表中
    if(!m_bluetoothDeveiceList.contains(dev))
    {
        QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(info.address());
        if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired )
        {
            m_bluetoothDeveiceList.append(dev);
        }
    }
}

/**
 * @Title: getBluetoothStatus
 * @Class: MyBlueTooth
 * @Description: 获取当前蓝牙的开关状态
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 14:29:33
 * @update_author
 * @update_time
 * @version V1.0
 * @return 当前的连接状态
*/
MyBlueTooth::BluetoothStatus MyBlueTooth::getBluetoothStatus() const
{
    switch (localDevice->hostMode()) {
    case QBluetoothLocalDevice::HostPoweredOff:
        return BluetoothStatus::PoweredOff;

    case QBluetoothLocalDevice::HostConnectable:
        return BluetoothStatus::Connectable;

    case QBluetoothLocalDevice::HostDiscoverable:
        return BluetoothStatus::Discoverable;

    case QBluetoothLocalDevice::HostDiscoverableLimitedInquiry:
        return BluetoothStatus::DiscoverableLimitedInquiry;

    default:
        return BluetoothStatus::UnKnownStatus;
    }
    return BluetoothStatus::UnKnownStatus;
}

QStringList MyBlueTooth::getBluetoothDeviceList() const
{
    return m_bluetoothDeveiceList;
}




