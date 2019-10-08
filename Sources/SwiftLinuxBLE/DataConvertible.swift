import Foundation

protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}
extension DataConvertible where Self: ExpressibleByIntegerLiteral{
    init?(data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        self = value
    }

    var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}
extension Int : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }
// add more types here ...



extension String: DataConvertible {
    init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }
    var data: Data {
        // Note: a conversion to UTF-8 cannot fail.
        return Data(self.utf8)
    }
}

extension Data : DataConvertible {
    init?(data: Data) {
        self.init(data)
    }
    var data: Data {
        return self
    }
}
