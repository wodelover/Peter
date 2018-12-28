#include "BluetoothCom.h"

BluetoothCom::BluetoothCom(QObject *parent) : QObject(parent)
{
    m_localDevice = new QBluetoothLocalDevice(this);
    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);
    m_socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);

    connect(m_discoveryAgent,SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this,SLOT(newDeviceDiscovered(QBluetoothDeviceInfo)));

    connect(m_socket,SIGNAL(connected()),
            this,SIGNAL(connected()));

    connect(m_socket,SIGNAL(disconnected()),
            this,SIGNAL(disConnected()));

    connect(m_socket,SIGNAL(readyRead()),
            this,SIGNAL(hasDataComeFromRemoteDevice()));

    connect(m_socket,SIGNAL(stateChanged(QBluetoothSocket::SocketState)),
            this,SIGNAL(stateChanged(QBluetoothSocket::SocketState)));
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

void BluetoothCom::openBluetooth()
{
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    m_localDevice->powerOn();
}

void BluetoothCom::closeBluetooth()
{
    //关闭蓝牙
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);
}

void BluetoothCom::setBluetoothDiscoverd()
{
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
}

void BluetoothCom::searchDevice()
{
    m_discoveryAgent->start();
}

QMap<QString,QString> BluetoothCom::getAvailableDevices()
{
    QList<QBluetoothHostInfo> devs = m_localDevice->allDevices();
    QMap<QString,QString> info;

    for(int i=0; i<devs.size();i++){
        info.insert(devs[i].name(),devs[i].address().toString());
    }
    return info;
}

QStringList BluetoothCom::getAvailableDevicesList()
{
    QList<QBluetoothHostInfo> devs = m_localDevice->allDevices();
    QStringList info;

    for(int i=0; i<devs.size();i++){
        info.append(devs[i].name() + " " + devs[i].address().toString());
    }
    info.append("name address");
    return info;
}

void BluetoothCom::connectDevice(QString addres)
{
    QBluetoothAddress address(addres);
    m_socket->connectToService(address, QBluetoothUuid(m_uuid) ,QIODevice::ReadWrite);
}

void BluetoothCom::disConnectDevice()
{
    m_socket->disconnectFromService();
}

long long BluetoothCom::sendDataToRemoteDevice(QByteArray senddata)
{
    return m_socket->write(senddata);
}

QByteArray BluetoothCom::getDataFromBuffer(long long size)
{
    if(size)
        return m_socket->read(size);
    else
        return m_socket->readAll();
}

void BluetoothCom::newDeviceDiscovered(QBluetoothDeviceInfo device)
{
    emit hasNewDeviceFounded(device.name(),device.address().toString());
}

