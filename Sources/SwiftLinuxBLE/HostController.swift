import Foundation
import Bluetooth
import GATT
import BluetoothLinux

extension HostController {
    public func newPeripheral() throws -> GATTPeripheral<HostController, L2CAPSocket> {
        // Setup peripheral
        let address = try readDeviceAddress()
        let serverSocket = try L2CAPSocket.lowEnergyServer(controllerAddress: address, isRandom: false, securityLevel: .low)
        
        let peripheral = GATTPeripheral<HostController, L2CAPSocket>(controller: self)
        peripheral.log = { print("Peripheral Log: \($0)") }
        peripheral.newConnection = {
           let socket = try serverSocket.waitForConnection()
           let central = Central(identifier: socket.address)
           print("BLE Peripheral: new connection")
           return (socket, central)
        }
        return peripheral
    }
}
