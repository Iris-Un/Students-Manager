#ifndef SQLQUERYMODEL_H
#define SQLQUERYMODEL_H

#include <QSqlQueryModel>
#include <QSqlRecord>
#include <iostream>

class SqlQueryModel : public QSqlQueryModel{
    Q_OBJECT
private:
    void generateRoleNames();
    QHash<int, QByteArray> roleName;
public:
    explicit SqlQueryModel(QObject *parent = 0);
    void setQuery(const QString &query, const QSqlDatabase &db = QSqlDatabase());
    void setQuery(const QSqlQuery &query);
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {	return roleName;	}
public:
    Q_INVOKABLE void insertData(QString zname,QString zgender,QString zage,QString zaddress,
                                 QString zmajor,QString zclass,QString zcredit);
    Q_INVOKABLE void insertNext(QString y,QString m,QString d,QString yy,
                                 QString mm,QString dd,QString zname,QString zaddress);
    Q_INVOKABLE void delCurIndexData(const int &index);//删除行
    Q_INVOKABLE void empty();

    Q_INVOKABLE void allUsers();
    Q_INVOKABLE QList<QVariant> getData(const int &index);//行数据
    Q_INVOKABLE void testUser();//生成测试数据
    Q_INVOKABLE void sel(QString zname,QString age_from,QString age_to);
};
#endif // SQLQUERYMODEL_H
