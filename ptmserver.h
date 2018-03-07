#ifndef PTMSERVER_H
#define PTMSERVER_H

#include <QObject>

class PTMServer : public QObject
{
    Q_OBJECT
public:
    explicit PTMServer(QObject *parent = nullptr);

signals:

public slots:
};

#endif // PTMSERVER_H