import Foundation

public protocol DataConvertible {
    init?(data: Data)
    var data: Data { get }
}
extension DataConvertible where Self: ExpressibleByIntegerLiteral{
    public init?(data: Data) {
        var value: Self = 0
        guard data.count == MemoryLayout.size(ofValue: value) else { return nil }
        _ = withUnsafeMutableBytes(of: &value, { data.copyBytes(to: $0)} )
        self = value
    }

    public var data: Data {
        return withUnsafeBytes(of: self) { Data($0) }
    }
}
extension Int : DataConvertible { }
extension Float : DataConvertible { }
extension Double : DataConvertible { }
// add more types here ...



extension String: DataConvertible {
    public init?(data: Data) {
        self.init(data: data, encoding: .utf8)
    }
    public var data: Data {
        // Note: a conversion to UTF-8 cannot fail.
        return Data(self.utf8)
    }
}

extension Data : DataConvertible {
    public init?(data: Data) {
        self.init(data)
    }
    public var data: Data {
        return self
    }
}
