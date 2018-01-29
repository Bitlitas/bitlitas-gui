// Copyright (c) 2018, Bitlitas
// All rights reserved. Based on Monero.

#include "clipboardAdapter.h"

clipboardAdapter::clipboardAdapter(QObject *parent) :
    QObject(parent)
{
    m_pClipboard = QGuiApplication::clipboard();
}

void clipboardAdapter::setText(const QString &text) {
    m_pClipboard->setText(text, QClipboard::Clipboard);
    m_pClipboard->setText(text, QClipboard::Selection);
}
