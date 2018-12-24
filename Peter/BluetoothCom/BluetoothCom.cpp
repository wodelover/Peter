#include "BluetoothCom.h"

BluetoothCom::BluetoothCom()
{
    m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent;
    m_localDevice = new QBluetoothLocalDevice;
    m_socket = new QBluetoothSocket;

    m_uuid = "00001101-0000-1000-8000-00805F9B34FB";

    //connect signal
    connect(m_discoveryAgent,SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this,SLOT(newDeviceDiscovered(QBluetoothDeviceInfo)));

    connect(m_socket,SIGNAL(connected()),
            this,SLOT(hasconnectDevice()));

    connect(m_socket,SIGNAL(disconnected()),
            this,SIGNAL(disConnectedRemoteDevice()));

    connect(m_socket,SIGNAL(readyRead()),
            this,SLOT(readDataBuf()));

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

BluetoothCom::ComProtocol BluetoothCom::protocol()
{
    return m_protocol;
}

void BluetoothCom::setProtocol(ComProtocol protocol)
{
    if(protocol!=m_protocol){
        m_protocol = protocol;
        emit protocolChanged(m_protocol);
    }
}

void BluetoothCom::openBluetooth()
{
    m_localDevice->powerOn();
}

void BluetoothCom::closeBluetooth()
{
    //关闭发现服务
    m_discoveryAgent->stop();
    //关闭蓝牙
    m_localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);
}

void BluetoothCom::setBluetoothDiscoverd()
{
    m_localDevice->setHostMode( QBluetoothLocalDevice::HostDiscoverable);
}

void BluetoothCom::searchDevice()
{
    m_discoveryAgent->start();
}

void BluetoothCom::connectDevice(QString addres)
{
    m_socket->connectToService(QBluetoothAddress(addres),QBluetoothUuid(m_uuid),QIODevice::ReadWrite);
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
