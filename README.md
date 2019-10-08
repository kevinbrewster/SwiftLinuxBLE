# SwiftLinuxBLE

SwiftLinuxBLE is a lightweight convenience wrapper for the [PureSwift BluetoothLinux library](https://github.com/PureSwift/BluetoothLinux).

It enables you to very quickly create a BLE peripheral on linux (for example, on the Raspberry Pi).

# Usage

Create a `Service` for each service you want to expose. Use the `@SwiftLinuxBLE.Characteristic` propertyWrapper for each characteristic. The peripheral will automagically track changes to each characteristic and will also write to them.

```
final class TemperatureService : SwiftLinuxBLE.Service {
    let uuid = BluetoothUUID(rawValue: "88d738cc-bdd0-485b-b197-b7186ff534e4")!
    
    // Characteristics
    @SwiftLinuxBLE.Characteristic(uuid: BluetoothUUID(), [.read, .notify])
    var temperature = 7.0
       
    @SwiftLinuxBLE.Characteristic(uuid: BluetoothUUID(), [.write])
    var tx = Data()
    
    @SwiftLinuxBLE.Characteristic(uuid: BluetoothUUID(), [.read, .notify])
    var rx = Data()
}
```

2. Create a `Peripheral` class and add each service. 

```
public final class ThermometerPeripheral : SwiftLinuxBLE.Peripheral {
    
    public let peripheral: GATTPeripheral<HostController, L2CAPSocket>
    let name: GAPCompleteLocalName = "Ferment"
    let iBeaconUUID = UUID(rawValue: "1DC24957-9DDA-46C4-88D4-3D3640CB3FDA")!
    
    public var services: [SwiftLinuxBLE.Service] = []
    public var characteristicsByHandle = [UInt16: CharacteristicType]()
    
    public init(hostController: HostController) throws {
        peripheral = try hostController.newPeripheral()
        
        add(service: TemperatureService())
                
        // Start peripheral
        try peripheral.start()
        print("BLE Peripheral started")
                       
        try advertise(name: name, services: services, iBeaconUUID: iBeaconUUID)
        
        peripheral.didWrite = didWrite
    }
}
```



