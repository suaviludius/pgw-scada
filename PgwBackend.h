// PgwBackend.h
#ifndef PGW_BACKEND_H
#define PGW_BACKEND_H

#include <QObject>


class PgwBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool isConnected READ isConnected) //NOTIFY connectedChanged)

public:
    explicit PgwBackend(QObject* parent = nullptr);
    ~PgwBackend() override;

    // Проверка подключения к серверу
    bool isConnected() const { return true; }

signals:
// Все сигналы проперти нужно объявить здесь
private slots:

private:

};

#endif // PGW_BACKEND_H
