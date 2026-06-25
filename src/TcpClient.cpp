// TcpClient.cpp
#include "TcpClient.h"

#include <QDebug>

TcpClient::TcpClient(QObject* parent)
    : QObject(parent)
{
    // Подключаем к сигналы к слотам
    connect(&m_socket, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(&m_socket, &QTcpSocket::disconnected, this, &TcpClient::onDisconnected);
    connect(&m_socket, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);
}

TcpClient::~TcpClient()
{
    disconnectFromServer();
}

bool TcpClient::connectToServer(const QString& host, quint16 port){
    m_host = host;
    m_port = port;
    m_socket.connectToHost(host,port);
    qDebug() << "Connecting to server " << host << port;
    return this->isConnected();
}

void TcpClient::disconnectFromServer(){
    if (m_socket.state() == QAbstractSocket::ConnectedState){
        qDebug() << "Disconnect from server";
        m_socket.disconnectFromHost();
    }
}

void TcpClient::sendData(const QByteArray& data){
    if (m_socket.state() == QAbstractSocket::ConnectedState){
        m_socket.write(data);
        m_socket.flush();
        qDebug() << "Send data to server: " << data.size() << " bytes";
    } else {
        qWarning() << "Cannot send data: not connected";
    }
}

void TcpClient::onConnected() {
    qDebug() << "Connected slot";
    emit connectedChanged();
}

void TcpClient::onDisconnected() {
    qDebug() << "Disconnected slot";
    emit connectedChanged();
    // Пытаемся переподключиться ?
}

void TcpClient::onReadyRead(){
    // Читаем все доступные данные
    QByteArray data = m_socket.readAll();
    qDebug() << "Recieve from server: " << data.size() << " bytes";
    m_readBuffer.append(data);
    emit dataRecieved(m_readBuffer);
}
