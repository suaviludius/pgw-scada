// PgwBackend.cpp
#include "PgwBackend.h"

PgwBackend::PgwBackend(QObject* parent)
    : QObject(parent)
{
    // Подключаем к TcpClient сигналы к слотам PgwBackend
    connect(&m_tcpClient, &TcpClient::connectedChanged, this, &PgwBackend::connectedChanged);
}

bool PgwBackend::connectToServer(const QString& host, quint16 port){
    if(!m_tcpClient.isConnected())
    return m_tcpClient.connectToServer(host, port);
}

void PgwBackend::disconnectFromServer() {
    m_tcpClient.disconnectFromServer();
}

PgwBackend::~PgwBackend()
{
    // Очистка
}