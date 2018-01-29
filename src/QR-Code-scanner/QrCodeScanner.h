// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

#ifndef QRCODESCANNER_H_
#define QRCODESCANNER_H_

#include <QImage>
#include <QVideoFrame>
#include "QrScanThread.h"

class QVideoProbe;
class QCamera;

class QrCodeScanner : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)

public:
    QrCodeScanner(QObject *parent = Q_NULLPTR);
    ~QrCodeScanner();
    void setSource(QCamera*);

    bool enabled() const;
    void setEnabled(bool enabled);

public Q_SLOTS:
    void processCode(int type, const QString &data);
    void processFrame(QVideoFrame);

Q_SIGNALS:
    void enabledChanged();

    void decoded(const QString &address, const QString &payment_id, const QString &amount, const QString &tx_description, const QString &recipient_name, const QVariantMap &extra_parameters);
    void decode(int type, const QString &data);
    void notifyError(const QString &error, bool warning = false);

protected:
    void timerEvent(QTimerEvent *);
    QrScanThread *m_thread;
    int m_processTimerId;
    int m_processInterval;
    int m_enabled;
    QVideoFrame m_curFrame;
    QVideoProbe *m_probe;
};

#endif

