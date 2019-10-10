import Foundation
import Bluetooth
import GATT
import BluetoothLinux


public protocol CharacteristicType {
    var uuid: BluetoothUUID { get }
    var properties: BitMaskOptionSet<GATT.Characteristic.Property> { get }
    var permissions: BitMaskOptionSet<GATT.Permission> { get }
    var descriptors: [GATT.Characteristic.Descriptor] { get }
    
    var data: Data { get set }
    //var didSet: (Data) -> Void { get set }
    
    func didSet(_ observer: @escaping (Data) -> Void)
}

@propertyWrapper
public class Characteristic<Value: DataConvertible> : CharacteristicType {
    var value: Value
    public let uuid: BluetoothUUID
    public var properties: BitMaskOptionSet<GATT.Characteristic.Property> = [.read, .write]
    public var permissions: BitMaskOptionSet<GATT.Permission> = [.read, .write]
    public let descriptors: [GATT.Characteristic.Descriptor]
    
    /*
     // Default arguments cause segfault in swift 5.1
    public init(wrappedValue value: Value, uuid: BluetoothUUID, _ properties: BitMaskOptionSet<GATT.Characteristic.Property>, _ permissions: BitMaskOptionSet<GATT.Permission>? = nil, _ descriptors: [GATT.Characteristic.Descriptor]? = nil) {
        self.value = value
        self.uuid = uuid
        self.properties = properties
        self.permissions = permissions ?? properties.inferredPermissions
        // we need this special descriptor to enable notifications!
        self.descriptors = descriptors ?? (properties.contains(.notify) ? [GATTClientCharacteristicConfiguration().descriptor] : [])
    }*/
    
    public init(wrappedValue value: Value, uuid: BluetoothUUID, _ properties: BitMaskOptionSet<GATT.Characteristic.Property>) {
        self.value = value
        self.uuid = uuid
        self.properties = properties
        self.permissions = properties.inferredPermissions
        // we need this special descriptor to enable notifications!
        self.descriptors = (properties.contains(.notify) ? [GATTClientCharacteristicConfiguration().descriptor] : [])
    }
    
    public var wrappedValue: Value {
        get { value }
        set {
            value = newValue;
            for observer in observers {
                observer(newValue)
            }
        }
    }
    
    public var data: Data {
        get { return wrappedValue.data }
        set { wrappedValue = Value(data: newValue) ?? wrappedValue }
    }
    
    private var observers: [(Value) -> Void] = []
    public func didSet(_ observer: @escaping (Value) -> Void) {
        observers += [observer]
    }
    public func didSet(_ observer: @escaping (Data) -> Void) {
        observers += [{ observer($0.data) }]
    }
}


extension BitMaskOptionSet where Element == GATT.Characteristic.Property {
    var inferredPermissions: BitMaskOptionSet<GATT.Permission> {
        let mapping: [GATT.Characteristic.Property: ATTAttributePermission] = [
            .read: .read,
            .notify: .read,
            .write: .write
        ]
        var permissions = BitMaskOptionSet<GATT.Permission>()
        for (property, permission) in mapping {
            if contains(property) {
                permissions.insert(permission)
            }
        }
        return permissions
    }
}
