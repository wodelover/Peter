#include "BluetoothCom.h"

BluetoothCom::BluetoothCom(QObject *parent) : QObject(parent)
{
    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    m_localDevice = new QBluetoothLocalDevice(this);
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);

    connect(m_discoveryAgent,SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this,SLOT(newDeviceDiscovered(QBluetoothDeviceInfo)));

    connect(m_socket,SIGNAL(connected()),
            this,SIGNAL(connected()));

    connect(m_socket,SIGNAL(disconnected()),
            this,SIGNAL(disConnected()));

    connect(m_socket,SIGNAL(readyRead()),
            this,SLOT(readDataBuf()));

//    m_localDevice->powerOn();

//    m_discoveryAgent->start();
}

BluetoothCom::~BluetoothCom()
{

}

QString BluetoothCom::uuid()
{
    return m_uuid;
}

void BluetoothCom::setUuid(QString uuid)
{
    if(uuid != m_uuid){
        m_uuid = uuid;
        emit uuidChanged(uuid);
    }
}

int BluetoothCom::protocol()
{
    return static_cast<int>(m_protocol);
}

void BluetoothCom::setProtocol(int protocol)
{
    if(protocol!=m_protocol){
        m_protocol = static_cast<ComProtocol>(protocol);
        emit protocolChanged(m_protocol);
    }
}

int BluetoothCom::blueToothStatus()
{
    setBlueToothStatus(m_localDevice->hostMode());
    return m_blueToothStatus;
}

void BluetoothCom::setBlueToothStatus(int status)
{
    if(status!=m_blueToothStatus){
        m_blueToothStatus = status;
        emit blueToothStatusChanged(m_blueToothStatus);
    }
}

void BluetoothCom::openBluetooth()
{
    m_localDevice->powerOn();
}

void BluetoothCom::closeBluetooth()
{
    //关闭发现服务
//    m_discoveryAgent->stop();

    //关闭蓝牙
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);

//    disconnect(m_discoveryAgent,SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
//            this,SLOT(newDeviceDiscovered(QBluetoothDeviceInfo)));
}

void BluetoothCom::setBluetoothDiscoverd()
{
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
}

void BluetoothCom::searchDevice()
{
    m_discoveryAgent->start();
}

void BluetoothCom::connectDevice(QString addres)
{
//    QBluetoothAddress address(addres);
//    socket->connectToService(address, QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);

//    m_socket = new QBluetoothSocket(static_cast<QBluetoothServiceInfo::Protocol>(m_protocol));

    m_socket->connectToService(QBluetoothAddress(addres),QBluetoothUuid(m_uuid),QIODevice::ReadWrite);

//    connect(m_socket,SIGNAL(connected()),
//            this,SLOT(hasconnectDevice()));

//    connect(m_socket,SIGNAL(disconnected()),
//            this,SIGNAL(disConnectedRemoteDevice()));

//    connect(m_socket,SIGNAL(readyRead()),
//            this,SLOT(readDataBuf()));

    //关闭发现服务
//    m_discoveryAgent->stop();
}

void BluetoothCom::disConnectDevice()
{
    m_socket->disconnectFromService();
}

long long BluetoothCom::sendDataToRemoteDevice(QByteArray senddata,long long size)
{
    if(0 ==size){
        return 0;
    }
    else if(size){
        return m_socket->write(senddata,size);
    }else{
       return m_socket->write(senddata);
    }
}

void BluetoothCom::newDeviceDiscovered(QBluetoothDeviceInfo device)
{
    emit hasNewDeviceFounded(device.name(),device.address().toString());
}

void BluetoothCom::hasconnectDevice()
{
    m_discoveryAgent->stop();
}

void BluetoothCom::readDataBuf()
{
    emit hasDataComeFromRemoteDevice(m_socket->readAll());
}
