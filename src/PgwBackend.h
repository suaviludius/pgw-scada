// PgwBackend.h
#ifndef PGW_BACKEND_H
#define PGW_BACKEND_H

#include "TcpClient.h"

#include <QObject>


class PgwBackend : public QObject {
    Q_OBJECT
    // Свойство, создает NOTIFY при вызове сигнала connectedChanged
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectedChanged)

public:
    explicit PgwBackend(QObject* parent = nullptr);
    ~PgwBackend() override;

    // QML методы
    // Подключение к TCP серверу
    Q_INVOKABLE bool connectToServer(const QString& host, quint16 port);
    // Отключение от TCP сервера
    Q_INVOKABLE void disconnectFromServer();

    // Геттеры для Q_PROPERTY
    // Проверка подключения к серверу
    bool isConnected() const { return m_tcpClient.isConnected();  }

signals:
    // Сигнал изменения подключения к TcpServer
    // Данный сигнал служит слотом для сигнала connectedChanged от TcpClient
    void connectedChanged();

private slots:
    // Тут мог быть приемник connectedChanged от TcpClient

private:
    // Клиент для подключения к TCP серверу PGW
    TcpClient m_tcpClient;

};

#endif // PGW_BACKEND_H
