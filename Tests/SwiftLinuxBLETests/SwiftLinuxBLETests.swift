import XCTest
import Bluetooth
import GATT
import BluetoothLinux
import Runtime
@testable import SwiftLinuxBLE

final class TestService : SwiftLinuxBLE.Service {
    let uuid = BluetoothUUID()
    
    // Characteristics
    @SwiftLinuxBLE.Characteristic(uuid: BluetoothUUID(), [.read, .notify])
    var temperature = 7.0
}


final class SwiftLinuxBLETests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print("TEST")
        
        
        let service = try TestService()
        let serviceInfo = try? Runtime.typeInfo(of: type(of: service))
        
        //print("x = \(service._temperature)")
        print("serviceInfo = \(serviceInfo)")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
