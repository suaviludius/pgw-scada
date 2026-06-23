#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "PgwBackend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Создаём бэкенд и экспортируем его в графическую часть
    PgwBackend backend;
    engine.rootContext()->setContextProperty("backend", &backend);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("main", "Main");

    // Запуск приложения
    return app.exec();
}
