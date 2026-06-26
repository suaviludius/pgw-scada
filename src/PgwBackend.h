// PgwBackend.h
#ifndef PGW_BACKEND_H
#define PGW_BACKEND_H

#include "TcpClient.h"

#include "protocol.h"

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>

struct CdrRecord {
    QString timestamp;
    QString imsi;
    QString action;
};
// Создаем Qt Meta-Object (даст обращаться к структуре)
Q_DECLARE_METATYPE(CdrRecord)

class PgwBackend : public QObject {
    Q_OBJECT
    // Свойство, создает NOTIFY при вызове сигнала connectedChanged
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectedChanged)
    // Свойства статистики сревера
    Q_PROPERTY(int activeSessions READ activeSessions NOTIFY statsChanged)
    Q_PROPERTY(int createdSessions READ createdSessions NOTIFY statsChanged)
    Q_PROPERTY(int expiredSessions READ expiredSessions NOTIFY statsChanged)
    Q_PROPERTY(int rejectedSessions READ rejectedSessions NOTIFY statsChanged)
    Q_PROPERTY(int totalSessions READ totalSessions NOTIFY statsChanged)
    Q_PROPERTY(int uptimeSeconds READ uptimeSeconds NOTIFY statsChanged)
    Q_PROPERTY(QVariantList recentCdr READ recentCdr NOTIFY cdrChanged)

public:
    explicit PgwBackend(QObject* parent = nullptr);
    ~PgwBackend() override;

    // QML методы
    // Подключение к TCP серверу
    Q_INVOKABLE bool connectToServer(const QString& host, quint16 port);
    // Отключение от TCP сервера
    Q_INVOKABLE void disconnectFromServer();
    // Запрос серверу
    Q_INVOKABLE void requestStatistics();
    Q_INVOKABLE void requestSessions();
    Q_INVOKABLE void requestCdr();
    Q_INVOKABLE void requestStartSession(const QString& sessionId);
    Q_INVOKABLE void requestStopSession(const QString& sessionId);
    Q_INVOKABLE void requestShutdown();

    // Геттеры для Q_PROPERTY
    // Проверка подключения к серверу
    bool isConnected() const { return m_tcpClient.isConnected();}
    // Статистики сревера
    int activeSessions() const { return m_activeSessions; }
    int createdSessions() const { return m_createdSessions; }
    int expiredSessions() const { return m_expiredSessions; }
    int rejectedSessions() const { return m_rejectedSessions; }
    int totalSessions() const { return m_totalSessions; }
    int uptimeSeconds() const { return m_uptimeSeconds; }
    // Записи CDR
    //QList<CdrRecord>recentCdr() const { return m_recentCdr;}
    QVariantList recentCdr() const { return m_recentCdr;}

    // Простые публичные методы
    // void handleResponse();

signals:
    // Сигнал изменения подключения к TcpServer
    // Сигнал служит слотом для сигнала connectedChanged от TcpClient
    void connectedChanged();
    // Сигнал для обновления свойств статистики
    void statsChanged();
    // Сигнал для обновления таблицы CDR записей
    void cdrChanged();

private slots:
    // Слот получении данных (принимаются все данные с сокета)
    void onDataReceived(QByteArray& data);

private:
    // Клиент для подключения к TCP серверу PGW
    TcpClient m_tcpClient;
    // Свойства статистики сревера
    int m_activeSessions = 0;
    int m_createdSessions = 0;
    int m_expiredSessions = 0;
    int m_rejectedSessions = 0;
    int m_totalSessions = 0;
    int m_uptimeSeconds = 0;
    // Список CDR записей
    //QList<CdrRecord> m_recentCdr;
    QVariantList m_recentCdr;

    void sendRequest(pgw::protocol::Command cmd, const QJsonObject& params = QJsonObject());
    void readResponse(QByteArray &buffer);
    void msgHandler(const pgw::protocol::Message &msg);

    // Обработчики ответов сервера
    void responseStatistics(const QJsonObject& data);
    void responseCdr(const QJsonObject& data);
};

#endif // PGW_BACKEND_H
