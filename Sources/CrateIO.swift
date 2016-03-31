
import SocksCore
import JSON
import Foundation
import Data
import Digest

public class CrateIO {

    let socket : InternetSocket
    let host: String
    let port: UInt16

  	public init(withHost host: String, onPort port: UInt16) throws {
      self.host = host
      self.port = port
      let raw = try! RawSocket(protocolFamily: .Inet, socketType: .Stream, protocol: .TCP)
      let addr = InternetAddress(address: .Hostname(host), port: port)
      socket = InternetSocket(rawSocket: raw, address: addr)
      try! socket.connect()

  	}

    public func sql (statement: String) -> JSON? {
      print("\(statement)")

      let post = "{\"stmt\": \"\(statement)\"}\r\n"
      let postBytes = post.toBytes()

      let request = "POST /_sql HTTP/1.1\r\nContent-Length: \(postBytes.count)\r\nContent-Type: application/json\r\n\r\n\(post)"

//      print(request)
      try! socket.send(request.toBytes())


      //receiving data
      let received = try! socket.recv()

      //converting data to a string
      let str = try! received.toString()

      //yay!
      print("Received: \n\(str)")
      // let NSUTF8StringEncoding = 8
      do {
        return try  JSONParser().parse(Data(NSString(string: str).componentsSeparatedByString("\r\n\r\n")[1]))
      }
      catch {
        return nil
      }
    }




    public func blob (insert data: String, into table: String) -> String? {

      let digest = Digest.sha1(data)

      // let post = "{\"stmt\": \"\(statement)\"}\r\n"
      let postBytes = data.toBytes()

      let request = "PUT /_blobs/\(table)/\(digest) HTTP/1.1\r\nHost: \(self.host):\(self.port)\r\nUser-Agent: curl/7.43.0\r\nAccept: */*\r\nContent-Length: \(postBytes.count)\r\nContent-Type: application/x-www-form-urlencoded\r\n\r\n"

      print(request)
      try! socket.send(request.toBytes())
      try! socket.send(data.toBytes())

      //receiving data
      let received = try! socket.recv()

      //converting data to a string
      let str = try! received.toString()

      //yay!
      print("Received: \n\(str)")
      // let NSUTF8StringEncoding = 8


      if NSString(string: str).componentsSeparatedByString("201 Created").count > 1 {
        return digest
      }

      return nil
    }



    public func blob (fetch digest: String, from table: String) -> String? {


      let request = "GET /_blobs/\(table)/\(digest) HTTP/1.1\r\n\r\n"

//      print(request)
      try! socket.send(request.toBytes())


      //receiving data
      let received = try! socket.recv()

      //converting data to a string
      let str = try! received.toString()

      print(str)
      if NSString(string: str).componentsSeparatedByString("200").count > 1 {

      }
      else {
        return nil
      }
      //
      // //receiving data
      // let receivedBlob = try! socket.recv()
      //
      // //converting data to a string
      // let blob = try! receivedBlob.toString()
      //
      //

      //yay!
      // print("Received: \n\(blob)")
      return NSString(string: str).componentsSeparatedByString("\r\n\r\n")[1]

    }


    deinit {
        try! socket.close()
    }

}
