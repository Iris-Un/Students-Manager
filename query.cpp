#include "query.h"
#include <QSqlField>
#include <QDebug>

SqlQueryModel::SqlQueryModel(QObject *parent) : QSqlQueryModel(parent){}

void SqlQueryModel::setQuery(const QString &query, const QSqlDatabase &db){
    QSqlQueryModel::setQuery(query, db);
    generateRoleNames();
}

void SqlQueryModel::setQuery(const QSqlQuery & query){
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

void SqlQueryModel::generateRoleNames(){
    roleName.clear();
    for( int i = 0; i < record().count(); i ++) {
        roleName.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
    }
}

QVariant SqlQueryModel::data(const QModelIndex &index, int role) const{
    QVariant value;
    if(role <= Qt::UserRole) {
        value = QSqlQueryModel::data(index, role);
    }
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

QList<QVariant> SqlQueryModel::getData(const int &row){
    QList<QVariant> value;
    for(int i=0;i<record().count();i++){
        QModelIndex modelIndex = this->index(row, i);
        value << QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
void SqlQueryModel::allUsers(){
    QString query=QString("select * from st");
    setQuery(query);
}

void SqlQueryModel::testUser(){
    QVector<QString> users = QVector<QString>{"张三","李四","王五"};
    QVector<QString> genders = QVector<QString>{"男","女"};
    QVector<QString> majors = QVector<QString>{"计算机","数学","师范","土木工程"};
    QVector<QString> adds = QVector<QString>{"北京","上海","郑州"};
    for(int i =0;i<30;++i){
        QString name = users[i%users.length()];
        QString gender = genders[i%2];
        int ages = (i*31)%70;
        QString age = QString("%1").arg(ages);
        QString birthyear = QString("%1").arg(2022-ages);
        QString major = majors[i%majors.length()];
        QString add = adds[i%adds.length()];
        QString query = QString("insert into st(name,gender,age,major,address,birthday) values('%1','%2','%3','%4','%5','%6-1-1')")
               .arg(name,gender,age,major,add,birthyear);
        setQuery(query);
    }
    setQuery("select * from st");
}

void SqlQueryModel::delCurIndexData(const int &row){
    QVariant m_id;
    QModelIndex modelIndex = this->index(row,0);  //对应行的第一列   id
    m_id=QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    QString query1=QString("delete from st where id='%1'").arg(m_id.toString());
    setQuery(query1);
    setQuery("select * from st");
}

void SqlQueryModel::empty(){
    QString query1=QString("delete from st");
    setQuery(query1);
}

void SqlQueryModel::insertData(QString zname,QString zgender,QString zage,
                                QString zaddress,QString zmajor,QString zclass,QString zcredit){
    QString query = QString("insert into st(name,gender,age,address,major,classes,credit) values('%1','%2','%3','%4','%5','%6','%7')")
                            .arg(zname,zgender,zage,zaddress,zmajor,zclass,zcredit);
    setQuery(query);
    setQuery("select * from st");
}
void SqlQueryModel::insertNext(QString y,QString m,QString d,QString yy,
                                QString mm,QString dd,QString zname,QString zaddress){
    QString query = QString("update st set birthday='%1-%2-%3',start_time='%4-%5-%6' where name='%7' and address='%8'")
                            .arg(y,m,d,yy,mm,dd,zname,zaddress);
    setQuery(query);
    setQuery("select * from st");
}
void SqlQueryModel::sel(QString zname,QString age_from,QString age_to){
    QString query;
    if(zname.isEmpty()){
        query = QString("select * from st where age between '%1' and '%2'").arg(age_from,age_to);
    }
    else{
        query = QString("select * from st where name='%1' and age between '%2' and '%3'").arg(zname,age_from,age_to);
    }
    setQuery(query);
}
