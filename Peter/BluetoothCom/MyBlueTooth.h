#ifndef MYBLUETOOTH_H
#define MYBLUETOOTH_H

//debug mode will be print some Debuging infomation
#define DebugMode


#include <QObject>
#include <QString>
#include <QDebug>

//bluetooth header
#include <QtBluetooth/qbluetoothglobal.h>
#include <QtBluetooth/qbluetoothlocaldevice.h>
#include <QtBluetooth/qbluetoothaddress.h>
#include <QtBluetooth/qbluetoothdevicediscoveryagent.h>
#include <QtBluetooth/qbluetoothlocaldevice.h>
#include <QtBluetooth/qbluetooth.h>
#include <QtBluetooth/qbluetoothsocket.h>

static const QLatin1String serviceUuid("00001101-0000-1000-8000-00805F9B34FB");

/**
 * @Title: MyBlueTooth
 * @FileName: MyBlueTooth
 * @Description: 自定义蓝牙调用类 QT += bluetooth
 * @author ZhangHao kinderzhang@foxmail.com
 * @date 2018-06-12 14:20:15
 * @update_author
 * @update_time
 * @version V1.0
*/

class MyBlueTooth : public QObject
{
    Q_OBJECT
public:
    explicit MyBlueTooth(QObject *parent = nullptr);
    enum BluetoothStatus{
        PoweredOff,
        Connectable,
        Discoverable,
        DiscoverableLimitedInquiry,
        UnKnownStatus
    };

    //public getter function
    Q_INVOKABLE  BluetoothStatus getBluetoothStatus() const ;
    Q_INVOKABLE QStringList getBluetoothDeviceList() const ;

    //public setter function
    Q_INVOKABLE void setIsCanbeDiscovered(bool discover);

    //public operation funtion
    Q_INVOKABLE void openBluetooth();
    Q_INVOKABLE void closeBluetooth();
    Q_INVOKABLE void disconnectBlutooth();
    Q_INVOKABLE void connectedBlutooth(const QString &bluetoothAddress = "98:D3:32:30:52:CB");
    Q_INVOKABLE qint64 sendDataToBluetooth(const QString &data);


    //signals
signals:
    void onblueToothConnectedEventSignal();
    void onblueToothDisconnectedEventSignal();
    void onreadBluetoothDataEventSignal(QString data);

    //slots
protected slots:
    void blueToothConnectedEventSlot();
    void blueToothDisconnectedEventSlot();
    void readBluetoothDataEventSlot();
    void addbluetoothDeviceTolistSlot(const QBluetoothDeviceInfo &info);

    //class member
private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;//scan blurtooth around
    QBluetoothLocalDevice *localDevice;//control local dev , ep open  dev or close dev
    QBluetoothSocket *socket;//use to bluetoorh touch and data communication
    QStringList m_bluetoothDeveiceList;

};

#endif // MYBLUETOOTH_H
