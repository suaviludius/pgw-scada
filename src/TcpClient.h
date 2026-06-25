// TcpClient.h
#ifndef TCP_CLIENT_H
#define TCP_CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QTimer>

class TcpClient : public QObject {
    Q_OBJECT
    // Свойство, создает NOTIFY при вызове сигнала connectedChanged
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectedChanged)

public:
    explicit TcpClient(QObject* parent = nullptr);
    ~TcpClient() override;

    // QML методы
    // Подключение к TCP серверу
    Q_INVOKABLE bool connectToServer(const QString& host, quint16 port);
    // Отключение от TCP сервера
    Q_INVOKABLE void disconnectFromServer();

    // Геттеры для Q_PROPERTY
    // Проверка подключения к TCP серверу
    bool isConnected() const { return (m_socket.state() == QAbstractSocket::ConnectedState); }

    // Обычные методы
    // Передача данных серверу
    void sendData(const QByteArray& data);

signals:
    // Сигнал изменения подключения к TcpServer
    void connectedChanged();
    // Сигнал при получении данных (читаются все данные с сокета и передаются)
    void dataRecieved(QByteArray& data);

private slots:
    // Слот подключения с генерацией connectedChanged
    void onConnected();
    // Слот отключения с генерацией connectedChanged
    void onDisconnected();
    // Слот разрешения чтения данных TCP сокета
    void onReadyRead();

private:
    // Соккет для подключения к TCP серверу
    QTcpSocket m_socket;
    // Подключение по хостнейму
    QString m_host;
    // Порт подключения к TCP серверу
    quint16 m_port;
    // Буффер чтения данных с сокета
    QByteArray m_readBuffer;

};

#endif // TCP_CLIENT_H