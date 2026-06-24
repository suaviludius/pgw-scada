// TcpClient.cpp
#include "TcpClient.h"
#include <QDebug>

TcpClient::TcpClient(QObject* parent)
    : QObject(parent)
{
    // Подключаем к сигналы к слотам
    connect(&m_socket, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(&m_socket, &QTcpSocket::disconnected, this, &TcpClient::onDisconnected);

}

bool TcpClient::connectToServer(const QString& host, quint16 port){
    m_host = host;
    m_port = port;
    m_socket.connectToHost(host,port);
    qDebug() << "Connecting to" << host << port;
    return this->isConnected();
}

void TcpClient::disconnectFromServer(){
    if (m_socket.state() == QAbstractSocket::ConnectedState){
        m_socket.disconnectFromHost();
    }
}

void TcpClient::onConnected() {
    qDebug() << "Connected to server";
    emit connectedChanged();
}

void TcpClient::onDisconnected() {
    emit connectedChanged();
    // Пытаемся переподключиться ?
}

TcpClient::~TcpClient()
{
    // Очистка
}