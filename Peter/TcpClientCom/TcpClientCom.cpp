#include "TcpClientCom.h"
#include <QHostAddress>

TcpClientCom::TcpClientCom()
{
}

TcpClientCom::TcpClientCom(QString ip, int port)
{
    setServerIP(ip);
    setServerPort(port);
}

TcpClientCom::~TcpClientCom()
{
    this->disconnectFromHost();
}

void TcpClientCom::setServerIP(QString ip)
{
    if(m_serverIP!=ip){
        m_serverIP = ip;
        emit serverIPChanged(ip);
    }
}

void TcpClientCom::setServerPort(int port)
{
    if(m_serverPort!=port){
        m_serverPort = port;
        emit serverPortChanged(port);
    }
}

QString TcpClientCom::serverIP()
{
    return m_serverIP;
}

int TcpClientCom::serverPort()
{
    return m_serverPort;
}

void TcpClientCom::ReConectToServer()
{
    // disconneted
    this->disconnectFromHost();

    // reconnected
    this->connectToHost(m_serverIP,static_cast<unsigned short>(m_serverPort));
}

void TcpClientCom::ConectServer()
{
    this->connectToHost(m_serverIP,static_cast<unsigned short>(m_serverPort));
}

void TcpClientCom::DisConectServer()
{
    this->disconnectFromHost();
}

int TcpClientCom::sendDataToServer(QVariant data)
{
    return static_cast<int>(this->write(data.toByteArray()));
}

QByteArray TcpClientCom::getDataFromBuffer(long long size)
{
    if(size)
        return this->read(size);
    else
        return this->readAll();
}

long long TcpClientCom::getDataBufferSize()
{
    return this->readBufferSize();
}

void TcpClientCom::initSignal()
{
    connect(this,SIGNAL(readyRead()),this,SIGNAL(hasNewDataFromServer()));
    connect(this,SIGNAL(stateChanged(SocketState)),
            this,SIGNAL(networkStatusChanged(NetWorkStatus)));
}
