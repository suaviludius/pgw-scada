// PgwBackend.cpp
#include "PgwBackend.h"

#include "TcpSerializer.h"

PgwBackend::PgwBackend(QObject* parent)
    : QObject(parent)
{
    // Подключаем к сигналы к слотам
    connect(&m_tcpClient, &TcpClient::connectedChanged, this, &PgwBackend::connectedChanged);
    connect(&m_tcpClient, &TcpClient::dataRecieved, this, &PgwBackend::onDataReceived);
}

PgwBackend::~PgwBackend()
{
    // Очистка
}

bool PgwBackend::connectToServer(const QString& host, quint16 port){
    if(!m_tcpClient.isConnected())
    return m_tcpClient.connectToServer(host, port);
}

void PgwBackend::disconnectFromServer() {
    m_tcpClient.disconnectFromServer();
}

void PgwBackend::requestStatistics() {
    sendRequest(pgw::protocol::Command::GET_STATS);
}
void PgwBackend::requestSessions() {
    sendRequest(pgw::protocol::Command::GET_SESSIONS);
}
void PgwBackend::requestCdr() {
    QJsonObject data;
    data["limit"] = 100;
    sendRequest(pgw::protocol::Command::GET_CDR, data);
}
void PgwBackend::requestStartSession(const QString& imsi) {
    QJsonObject data;
    data["imsi"] = imsi;
    sendRequest(pgw::protocol::Command::START_SESSION, data);
}
void PgwBackend::requestStopSession(const QString& imsi) {
    QJsonObject data;
    data["imsi"] = imsi;
    sendRequest(pgw::protocol::Command::STOP_SESSION, data);
}
void PgwBackend::requestShutdown(){
    sendRequest(pgw::protocol::Command::SHUTDOWN);
}


void PgwBackend::responseStatistics(const QJsonObject& data){
    m_activeSessions = data["active_sessions"].toInt(0);
    m_createdSessions = data["created_sessions"].toInt(0);
    m_expiredSessions = data["expired_sessions"].toInt(0);
    m_rejectedSessions = data["rejected_sessions"].toInt(0);
    m_totalSessions = data["total_sessions"].toInt(0);
    m_uptimeSeconds = data["uptime_seconds"].toInt(0);
    emit statsChanged();
}

void PgwBackend::responseCdr(const QJsonObject& data){
    m_recentCdr.clear();
    m_recentCdr = data["records"].toArray().toVariantList();

    // auto records = data["records"].toArray();
    // for(const auto& item : records){
    //     const auto obj = item.toObject();
    //     CdrRecord record;
    //     record.timestamp = obj["timestamp"].toString();
    //     record.imsi = obj["imsi"].toString();
    //     record.action = obj["action"].toString();
    //     qDebug() << record.timestamp << " " << record.imsi << " " << record.action;
    //     m_recentCdr.append(record);
    // }

    emit cdrChanged();
}

void PgwBackend::sendRequest(pgw::protocol::Command cmd, const QJsonObject& params){
    auto msg = pgw::TcpSerializer::createJsonMsg(cmd, pgw::protocol::Status::OK, params);
    auto data = pgw::TcpSerializer::serializer(msg);
    m_tcpClient.sendData(data);
}

void PgwBackend::msgHandler(const pgw::protocol::Message &msg){
    if (msg.header.status != pgw::protocol::Status::OK){
        qWarning() << "Command status error";
        return;
    }
    switch(msg.header.command){
        case pgw::protocol::Command::GET_STATS:
            responseStatistics(pgw::TcpSerializer::getJsonData(msg));
            break;
        // case pgw::protocol::Command::GET_SESSIONS:
         case pgw::protocol::Command::GET_CDR:
            responseCdr(pgw::TcpSerializer::getJsonData(msg));
            break;
        // case pgw::protocol::Command::START_SESSION:
        // case pgw::protocol::Command::STOP_SESSION:
        // case pgw::protocol::Command::SHUTDOWN:
        default: break;
    }
}

void PgwBackend::readResponse(QByteArray &buffer){
    // Циклично ищем, передаем и удаляем сообщения из буффера
    while(true){
        // Сериализуем данные сообщения
        auto msg = pgw::TcpSerializer::deserializer(buffer);
        if (!msg.has_value()) {
            break;  // Недостаточно данных
        }
        // Удаляем сообщение из буффера
        buffer.remove(0, msg->totalSize());
        // Передаем сигнал обработчику сообщений
        msgHandler(*msg);
    }
}

void PgwBackend::onDataReceived(QByteArray& data){
    readResponse(data);
}