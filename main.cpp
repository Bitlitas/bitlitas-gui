// Copyright (c) 2018, Bitlitas 
// All rights reserved. Based on Monero.

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QStandardPaths>
#include <QDebug>
#include <QObject>
#include <QDesktopWidget>
#include <QScreen>
#include "clipboardAdapter.h"
#include "filter.h"
#include "oscursor.h"
#include "oshelper.h"
#include "WalletManager.h"
#include "Wallet.h"
#include "QRCodeImageProvider.h"
#include "PendingTransaction.h"
#include "UnsignedTransaction.h"
#include "TranslationManager.h"
#include "TransactionInfo.h"
#include "TransactionHistory.h"
#include "model/TransactionHistoryModel.h"
#include "model/TransactionHistorySortFilterModel.h"
#include "AddressBook.h"
#include "model/AddressBookModel.h"
#include "wallet/api/wallet2_api.h"
#include "MainApp.h"

// IOS exclusions
#ifndef Q_OS_IOS
#include "daemon/DaemonManager.h"
#endif

#ifdef WITH_SCANNER
#include "QrCodeScanner.h"
#endif

void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    // Send all message types to logger
    Bitlitas::Wallet::debug(msg.toStdString());
}

int main(int argc, char *argv[])
{
    Bitlitas::Utils::onStartup();
//    // Enable high DPI scaling on windows & linux
//#if !defined(Q_OS_ANDROID) && QT_VERSION >= 0x050600
//    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    qDebug() << "High DPI auto scaling - enabled";
//#endif

    // Log settings
    Bitlitas::Wallet::init(argv[0], "bitlitas-wallet-gui");
//    qInstallMessageHandler(messageHandler);

    MainApp app(argc, argv);

    qDebug() << "app startd";

    app.setApplicationName("bitlitas-core");
    app.setOrganizationDomain("bitlitas.lt");
    app.setOrganizationName("bitlitas-project");

    filter *eventFilter = new filter;
    app.installEventFilter(eventFilter);

    // registering types for QML
    qmlRegisterType<clipboardAdapter>("bitlitasComponents.Clipboard", 1, 0, "Clipboard");

    qmlRegisterUncreatableType<Wallet>("bitlitasComponents.Wallet", 1, 0, "Wallet", "Wallet can't be instantiated directly");


    qmlRegisterUncreatableType<PendingTransaction>("bitlitasComponents.PendingTransaction", 1, 0, "PendingTransaction",
                                                   "PendingTransaction can't be instantiated directly");

    qmlRegisterUncreatableType<UnsignedTransaction>("bitlitasComponents.UnsignedTransaction", 1, 0, "UnsignedTransaction",
                                                   "UnsignedTransaction can't be instantiated directly");

    qmlRegisterUncreatableType<WalletManager>("bitlitasComponents.WalletManager", 1, 0, "WalletManager",
                                                   "WalletManager can't be instantiated directly");

    qmlRegisterUncreatableType<TranslationManager>("bitlitasComponents.TranslationManager", 1, 0, "TranslationManager",
                                                   "TranslationManager can't be instantiated directly");



    qmlRegisterUncreatableType<TransactionHistoryModel>("bitlitasComponents.TransactionHistoryModel", 1, 0, "TransactionHistoryModel",
                                                        "TransactionHistoryModel can't be instantiated directly");

    qmlRegisterUncreatableType<TransactionHistorySortFilterModel>("bitlitasComponents.TransactionHistorySortFilterModel", 1, 0, "TransactionHistorySortFilterModel",
                                                        "TransactionHistorySortFilterModel can't be instantiated directly");

    qmlRegisterUncreatableType<TransactionHistory>("bitlitasComponents.TransactionHistory", 1, 0, "TransactionHistory",
                                                        "TransactionHistory can't be instantiated directly");

    qmlRegisterUncreatableType<TransactionInfo>("bitlitasComponents.TransactionInfo", 1, 0, "TransactionInfo",
                                                        "TransactionHistory can't be instantiated directly");
#ifndef Q_OS_IOS
    qmlRegisterUncreatableType<DaemonManager>("bitlitasComponents.DaemonManager", 1, 0, "DaemonManager",
                                                   "DaemonManager can't be instantiated directly");
#endif
    qmlRegisterUncreatableType<AddressBookModel>("bitlitasComponents.AddressBookModel", 1, 0, "AddressBookModel",
                                                        "AddressBookModel can't be instantiated directly");

    qmlRegisterUncreatableType<AddressBook>("bitlitasComponents.AddressBook", 1, 0, "AddressBook",
                                                        "AddressBook can't be instantiated directly");

    qRegisterMetaType<PendingTransaction::Priority>();
    qRegisterMetaType<TransactionInfo::Direction>();
    qRegisterMetaType<TransactionHistoryModel::TransactionInfoRole>();

#ifdef WITH_SCANNER
    qmlRegisterType<QrCodeScanner>("bitlitasComponents.QRCodeScanner", 1, 0, "QRCodeScanner");
#endif

    QQmlApplicationEngine engine;

    OSCursor cursor;
    engine.rootContext()->setContextProperty("globalCursor", &cursor);
    OSHelper osHelper;
    engine.rootContext()->setContextProperty("oshelper", &osHelper);

    engine.rootContext()->setContextProperty("walletManager", WalletManager::instance());

    engine.rootContext()->setContextProperty("translationManager", TranslationManager::instance());

    engine.addImageProvider(QLatin1String("qrcode"), new QRCodeImageProvider());
    const QStringList arguments = QCoreApplication::arguments();

    engine.rootContext()->setContextProperty("mainApp", &app);

// Exclude daemon manager from IOS
#ifndef Q_OS_IOS
    DaemonManager * daemonManager = DaemonManager::instance(&arguments);
    engine.rootContext()->setContextProperty("daemonManager", daemonManager);
#endif

//  export to QML bitlitas accounts root directory
//  wizard is talking about where
//  to save the wallet file (.keys, .bin), they have to be user-accessible for
//  backups - I reckon we save that in My Documents\Bitlitas Accounts\ on
//  Windows, ~/Bitlitas Accounts/ on nix / osx
    bool isWindows = false;
    bool isIOS = false;
    bool isMac = false;
    bool isAndroid = false;
#ifdef Q_OS_WIN
    isWindows = true;
    QStringList bitlitasAccountsRootDir = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
#elif defined(Q_OS_IOS)
    isIOS = true;
    QStringList bitlitasAccountsRootDir = QStandardPaths::standardLocations(QStandardPaths::DocumentsLocation);
#elif defined(Q_OS_UNIX)
    QStringList bitlitasAccountsRootDir = QStandardPaths::standardLocations(QStandardPaths::HomeLocation);
#endif
#ifdef Q_OS_MAC
    isMac = true;
#endif
#ifdef Q_OS_ANDROID
    isAndroid = true;
#endif

    engine.rootContext()->setContextProperty("isWindows", isWindows);
    engine.rootContext()->setContextProperty("isIOS", isIOS);
    engine.rootContext()->setContextProperty("isAndroid", isAndroid);

    // screen settings
    // Mobile is designed on 128dpi
    qreal ref_dpi = 128;
    QRect geo = QApplication::desktop()->availableGeometry();
    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qreal physicalDpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    qreal calculated_ratio = physicalDpi/ref_dpi;

    engine.rootContext()->setContextProperty("screenWidth", geo.width());
    engine.rootContext()->setContextProperty("screenHeight", geo.height());
#ifdef Q_OS_ANDROID
    engine.rootContext()->setContextProperty("scaleRatio", calculated_ratio);
#else
    engine.rootContext()->setContextProperty("scaleRatio", 1);
#endif

    qDebug() << "available width: " << geo.width();
    qDebug() << "available height: " << geo.height();
    qDebug() << "devicePixelRatio: " << app.devicePixelRatio();
    qDebug() << "screen height: " << height;
    qDebug() << "screen width: " << width;
    qDebug() << "screen logical dpi: " << dpi;
    qDebug() << "screen Physical dpi: " << physicalDpi;
    qDebug() << "screen calculated ratio: " << calculated_ratio;


    if (!bitlitasAccountsRootDir.empty()) {
        QString bitlitasAccountsDir = bitlitasAccountsRootDir.at(0) + "/Bitlitas/wallets";
        engine.rootContext()->setContextProperty("bitlitasAccountsDir", bitlitasAccountsDir);
    }


    // Get default account name
    QString accountName = qgetenv("USER"); // mac/linux
    if (accountName.isEmpty()){
        accountName = qgetenv("USERNAME"); // Windows
    }
    if (accountName.isEmpty()) {
        accountName = "My bitlitas Account";
    }

    engine.rootContext()->setContextProperty("defaultAccountName", accountName);
    engine.rootContext()->setContextProperty("applicationDirectory", QApplication::applicationDirPath());

    bool builtWithScanner = false;
#ifdef WITH_SCANNER
    builtWithScanner = true;
#endif
    engine.rootContext()->setContextProperty("builtWithScanner", builtWithScanner);

    // Load main window (context properties needs to be defined obove this line)
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));
    QObject *rootObject = engine.rootObjects().first();

#ifdef WITH_SCANNER
    QObject *qmlCamera = rootObject->findChild<QObject*>("qrCameraQML");
    if( qmlCamera ){
        qDebug() << "QrCodeScanner : object found";
        QCamera *camera_ = qvariant_cast<QCamera*>(qmlCamera->property("mediaObject"));
        QObject *qmlFinder = rootObject->findChild<QObject*>("QrFinder");
        qobject_cast<QrCodeScanner*>(qmlFinder)->setSource(camera_);
    } else {
        qDebug() << "QrCodeScanner : something went wrong !";
    }
#endif

    QObject::connect(eventFilter, SIGNAL(sequencePressed(QVariant,QVariant)), rootObject, SLOT(sequencePressed(QVariant,QVariant)));
    QObject::connect(eventFilter, SIGNAL(sequenceReleased(QVariant,QVariant)), rootObject, SLOT(sequenceReleased(QVariant,QVariant)));
    QObject::connect(eventFilter, SIGNAL(mousePressed(QVariant,QVariant,QVariant)), rootObject, SLOT(mousePressed(QVariant,QVariant,QVariant)));
    QObject::connect(eventFilter, SIGNAL(mouseReleased(QVariant,QVariant,QVariant)), rootObject, SLOT(mouseReleased(QVariant,QVariant,QVariant)));

    return app.exec();
}
