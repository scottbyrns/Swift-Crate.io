
import SocksCore


public class CrateIO {

    let socket : InternetSocket

  	public init(withHost host: String, onPort port: UInt16) throws {

      let raw = try! RawSocket(protocolFamily: .Inet, socketType: .Stream, protocol: .TCP)
      let addr = InternetAddress(address: .Hostname(host), port: port)
      socket = InternetSocket(rawSocket: raw, address: addr)
      try! socket.connect()

  	}

    public func sql (statement: String) -> String {
      print("\(statement)")

      let post = "{\"stmt\": \"\(statement)\"}\r\n"
      let postBytes = post.toBytes()

      let request = "POST /_sql HTTP/1.1\r\nContent-Length: \(postBytes.count)\r\nContent-Type: application/json\r\n\r\n\(post)"

      print(request)
      try! socket.send(request.toBytes())


      //receiving data
      let received = try! socket.recv()

      //converting data to a string
      let str = try! received.toString()

      //yay!
      print("Received: \n\(str)")
      return str
    }

    deinit {
        try! socket.close()
    }

}
