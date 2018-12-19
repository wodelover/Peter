#include "TcpServerCom.h"
#include <QDebug>

TcpServerCom::TcpServerCom()
{
    // init com component
    m_server = new QTcpServer();
    if(!m_server){//memery error
        printf("TcpServerCom can not be run,no more menmery to use...\n");
    }else{//connect signal
        connectSignal();
    }
}

TcpServerCom::~TcpServerCom()
{
    disconnectedClient("",true);
}

void TcpServerCom::setListenIP(QString ip)
{
    if(ip!=m_listenIP){
        m_listenIP = ip;
        emit listenIPChanged(m_listenIP);
    }
}

void TcpServerCom::setListenPort(int port)
{
    if(port!=m_listenPort){
        m_listenPort = port;
        emit listenPortChanged(m_listenPort);
    }
}

QString TcpServerCom::listenIP()
{
    return m_listenIP;
}

int TcpServerCom::listenPort()
{
    return m_listenPort;
}

bool TcpServerCom::listen(bool status)
{
    if(status){//开启监听
        return m_server->listen(QHostAddress(m_listenIP),static_cast<unsigned short>(m_listenPort));
    }else{
        m_server->close();
        return true;
    }
}

void TcpServerCom::disconnectedClient(int index)
{
    if(index <m_clients.size()){
        m_clients[index]->disconnectFromHost();
        m_clients.remove(index);
    }
}

void TcpServerCom::disconnectedClient(QString ip,int port,bool all)
{
    if(all){
        for (int i=0;i<m_clients.size();i++) {
            //            emit clientDisConnected(m_clients[i]->peerAddress().toString(),m_clients[i]->peerPort());
            qDebug()<<m_clients[i]->peerAddress().toString()<<" "<<m_clients[i]->peerPort();
            m_clients[i]->disconnectFromHost();
        }
        // 等待客户端信号触发自动删除
        m_clients.clear();
    }else{
        for(int i=0;i<m_clients.size();i++){
            if(m_clients[i]->localAddress().toString()==ip&&m_clients[i]->peerPort() == port){
                //                qDebug()<<m_clients[i]->peerAddress().toString()<<" "<<m_clients[i]->peerPort();
                m_clients[i]->disconnectFromHost();
                // 等待客户端信号触发自动删除
                //m_clients.remove(i);
                break;
            }
        }
    }
}

long long TcpServerCom::sendDataToClient(QByteArray &data, QString ip, int port, bool broad)
{
    if(broad){//广播
        long long size = -1;
        for(int i=0;i<m_clients.size();i++){
            size = m_clients[i]->write(data);
        }
        return size;
    }else{//单播
        for(int i=0;i<m_clients.size();i++){
            if(m_clients[i]->localAddress().toString()==ip
                    ||m_clients[i]->localPort()==port){
                return m_clients[i]->write(data);
            }
        }
        qDebug()<<"Send Data to:"+ip+" Error...";
        return -1;
    }
}

long long TcpServerCom::sendDataToClient(QByteArray &data, int index)
{
    if(index <m_clients.size()){
        return m_clients[index]->write(data);
    }
    return -1;
}

QString TcpServerCom::getIPFromVector(int index)
{
    if(index <m_clients.size()){
        return m_clients[index]->peerAddress().toString();
    }
    return "-1:-1:-1:-1";
}

int TcpServerCom::getPortFromVector(int index)
{
    if(index <m_clients.size()){
        return m_clients[index]->peerPort();
    }
    return -1;
}

void TcpServerCom::enableHeartPacket(QString ip, QByteArray data, bool all,int time)
{
    qDebug()<<"timer";
    m_timer.setInterval(time);
    connect(&m_timer,&QTimer::timeout,
            [=](){
        if(all){
            for(int i=0;i<m_clients.size();i++){
                m_clients[i]->write(data);
            }
        }else{
            for (int i=0;i<m_clients.size();i++) {
                if(m_clients[i]->peerAddress().toString() == ip){
                    m_clients[i]->write(data);
                }
            }
        }
    });
    m_timer.start();
}

void TcpServerCom::hasNewConnection()
{
    // get new client socket
    QTcpSocket *socket = m_server->nextPendingConnection();
    m_clients.append(socket);
    connect(socket,SIGNAL(readyRead()),this,SLOT(hasNewData()));
    emit newClientConnected(socket->peerAddress().toString(),socket->peerPort());
    connect(socket,SIGNAL(disconnected()),this,SLOT(clientDisconnect()));
}

void TcpServerCom::hasNewData()
{
    //handle client data
    for(int i=0;i<m_clients.size();i++){
        QTcpSocket *socket = m_clients[i];
        if(socket->bytesAvailable()){
            emit hasNewDataFromClient(socket->peerAddress().toString(),socket->peerPort(),socket->readAll());
        }
    }
}

void TcpServerCom::clientDisconnect()
{
    // 查询当前客户端中有哪些已经断开连接
    for(int i=0;i<m_clients.size();i++){
        if(m_clients[i]->state() == QAbstractSocket::UnconnectedState){
            emit clientDisConnected(m_clients[i]->peerAddress().toString(),m_clients[i]->peerPort());
            m_clients.remove(i);
        }
    }
}

void TcpServerCom::connectSignal()
{
    // new connection
    connect(m_server,SIGNAL(newConnection()),this,SLOT(hasNewConnection()));
}
