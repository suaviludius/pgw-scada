#include "TcpSerializer.h"

#include <cstring> // memcpy

namespace pgw {

QByteArray TcpSerializer::serializer(const protocol::Message& msg){
    // Создаем бинарный буффер
    QByteArray buffer;

    // Указатель для побайтного чтения заголовка
    const char* header = reinterpret_cast<const char*>(&msg.header);

    // Вставляем данные в буффер
    buffer.append(header, protocol::HEADER_SIZE);

    // Читаем длину
    const size_t length = msg.header.length;
    if(length){
        // Читаем данные в буффер
        const char* data = reinterpret_cast<const char*>(&msg.data);
        buffer.append(data, length);
    }

    return buffer;
}

// TODO: можно сделать enum с кодами ошибок, чтобы классифицировать
// по какой причине не получилось считать TCP сообщение
std::optional<protocol::Message> TcpSerializer::deserializer(const QByteArray& buffer){
    if(buffer.size() <  protocol::HEADER_SIZE){
        return std::nullopt;
    }

    protocol::Message msg;

    // Копируем заголовок
    std::memcpy(&msg.header, buffer.constData(),  protocol::HEADER_SIZE);

    // Проверяем версию
    if(msg.header.version != protocol::PROTOCOL_VERSION){
        return std::nullopt;
    }

    // Проверяем размер буффера
    if(buffer.size() < protocol::HEADER_SIZE + msg.header.length){
        return std::nullopt;
    }

    // Копируем данные в структуру
    msg.data.resize(msg.header.length);
    if(msg.header.length > 0){
        std::memcpy(msg.data.data(), buffer.constData() + protocol::HEADER_SIZE, msg.header.length);
    }

    return msg;
}

protocol::Message TcpSerializer::createJsonMsg(protocol::Command command,
                                               protocol::Status status,
                                               const QJsonObject& jsonData){

    protocol::Message msg;
    msg.header.version = protocol::PROTOCOL_VERSION;
    msg.header.command = command;
    msg.header.status = status;

    if (!jsonData.isEmpty()) {
        // Преобразуем объект QJsonObject в QByteArray
        QJsonDocument jsonDoc(jsonData);
        QByteArray jsonBytes = jsonDoc.toJson(QJsonDocument::Compact);
        // Так как char это байт, то он легко кладется в буффер
        msg.data.resize(jsonBytes.size());
        std::memcpy(msg.data.data(), jsonBytes.constData(), jsonBytes.size());
        msg.header.length = static_cast<protocol::length_t>(jsonBytes.size());
    } else {
        msg.header.length = 0;
        msg.data.clear();
    }

    return msg;
}

QJsonObject TcpSerializer::getJsonData(const protocol::Message& msg) {
    if (msg.data.empty()) {
        return QJsonObject();  // Пустой объект
    }

    // Преобразуем данные в QByteArray
    QByteArray jsonData(reinterpret_cast<const char*>(msg.data.data()),static_cast<int>(msg.data.size()));
    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    return doc.object();
}

} // namespace pgw
