
import SocksCore


public class CrateIO {

    let socket : InternetSocket

  	public init(withHost host: String, onPort port: UInt16) throws {

      let raw = try! RawSocket(protocolFamily: .Inet, socketType: .Stream, protocol: .TCP)
      let addr = InternetAddress(address: .Hostname("google.com"), port: port)
      socket = InternetSocket(rawSocket: raw, address: addr)
      try! socket.connect()

  	}

    deinit {
        try! socket.close()
    }

}
