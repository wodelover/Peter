#include "TcpServerCom.h"
#include <QDebug>

TcpServerCom::TcpServerCom()
{
    // init com component
    m_server = new QTcpServer();
    m_socket = new QTcpSocket();
    if(!m_server||!m_socket){//memery error
        printf("TcpServerCom can not be run,no more menmery to use...\n");
        emit netWorkStatusChanged(NoMoreMenmery);
    }else{//connect signal
        connectSignal();
    }
}

TcpServerCom::~TcpServerCom()
{
    disconnectClient("",true);
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

void TcpServerCom::disconnectClient(QString ip,bool all)
{
    if(all){
        for (int i=0;i<m_clients.size();i++) {
            m_clients[i]->disconnectFromHost();
        }
        m_clients.clear();
    }else{
        for(int i=0;i<m_clients.size();i++){
            if(m_clients[i]->localAddress().toString()==ip){
                m_clients[i]->disconnectFromHost();
                m_clients.remove(i);
                return;
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

void TcpServerCom::enAbleHeartPacket(QString ip, QByteArray data, bool all,int time)
{
    qDebug()<<"timer";
    m_timer.setInterval(time);
    connect(&m_timer,&QTimer::timeout,
                [=](){
        if(all){

        }else{

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
//    connect(socket,SIGNAL(stateChanged(SocketState)),this,SLOT(netWorkStatusChanged(NetWorkStatus)));
}

void TcpServerCom::hasNewData()
{
    //handle client data
    for(int i=0;i<m_clients.size();i++){
        QTcpSocket *socket = m_clients[i];
        if(socket->bytesAvailable()){
//            socket->write(socket->readAll());
            emit hasNewDataFromClient(socket);
        }
    }
}

void TcpServerCom::netWorkStatusChanged(TcpServerCom::NetWorkStatus status)
{
    // todo
}

void TcpServerCom::connectSignal()
{
    // new connection
    connect(m_server,SIGNAL(newConnection()),this,SLOT(hasNewConnection()));
    //    connect(m_server,SIGNAL(stateChanged(SocketState)),this,SLOT(netWorkStatusChanged(NetWorkStatus)));
}
