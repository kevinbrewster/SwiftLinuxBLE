import Foundation
import Bluetooth
import GATT
import BluetoothLinux

public protocol Service : class {
    var uuid: BluetoothUUID { get }
}


