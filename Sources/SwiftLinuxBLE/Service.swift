import Foundation
import Bluetooth
import GATT
import BluetoothLinux

protocol Service : class {
    var uuid: BluetoothUUID { get }
}


