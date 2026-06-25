#ifndef TCP_SERIALIZER_H
#define TCP_SERIALIZER_H

#include "protocol.h"

#include <QObject>
#include <QJsonObject>

#include <optional>


namespace pgw {

class TcpSerializer{
public:
    // Из сообщения получаем бинарный буффер
    static QByteArray serializer(const protocol::Message& msg);

    // Из бинарного буффера получаем сообщение
    // Так как в зпросах меньше данных, чем в ответах,
    // то можно данные вначале считывать в msg и не стесняться
    // а потом данные из msg.data перевести в JSON формат методом getJsonData(msg)
    static std::optional<protocol::Message> deserializer(const QByteArray& buffer);

    // Из заголовка и json данных получаем сообщение
    static protocol::Message createJsonMsg(protocol::Command command,
                                           protocol::Status status,
                                           const QJsonObject& jsonData = QJsonObject());

    // Из сообщения извлекаем json данные
    static QJsonObject getJsonData(const protocol::Message& msg);
};

} // namespace pgw

#endif // TCP_SERIALISER_H