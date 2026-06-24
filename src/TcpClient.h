// TcpClient.h
#ifndef TCP_CLIENT_H
#define TCP_CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>

class TcpClient : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected) //NOTIFY connectedChanged)

public:
    explicit TcpClient(QObject* parent = nullptr);
    ~TcpClient() override;

    // Проверка подключения к серверу
    bool isConnected() const { return false; }

signals:
// Все сигналы проперти нужно объявить здесь
private slots:

private:

};

#endif // TCP_CLIENT_H