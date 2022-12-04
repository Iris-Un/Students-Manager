#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSqlDatabase>
#include "query.h"
#include <QtDebug>

int main(int argc, char *argv[]){
    QGuiApplication app(argc, argv);
    //DB
    QSqlDatabase mydatabase=QSqlDatabase::addDatabase("QSQLITE");
    QString currentPath;
    currentPath = QCoreApplication::applicationDirPath();	//exe目录
    mydatabase.setDatabaseName(QString("%1/study.db").arg(currentPath));
    qDebug() << (mydatabase.open() ? "DB IS OK" : "DB NOT OK");
    //Model
    SqlQueryModel* model1 = new SqlQueryModel(0);
    model1->setQuery("select * from st");
    //Load
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("myModel",model1);
    engine.load(QUrl(QStringLiteral("qrc:/ZY/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
