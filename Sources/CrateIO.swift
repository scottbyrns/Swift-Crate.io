
import TCP
import JSON
import Data
import Digest
import HTTP
import HTTPParser
import HTTPSerializer
import S4

public class CrateIO {

    let socket : TCPClientSocket
    let host: String
    let port: Int

  	public init(withHost host: String, onPort port: Int) throws {
      self.host = host
      self.port = port
      socket = try TCPClientSocket(ip: IP(remoteAddress: host, port: port))
  	}

    public func sql (statement: String) throws -> JSON? {

      let post = "{\"stmt\": \"\(statement)\"}\r\n"
      let postBytes = [UInt8](post.utf8)

      let headers: Headers = [
          "Content-Length": HeaderValues("\(postBytes.count)"),
          "Content-Type": HeaderValues("application/json"),
          "User-Agent": HeaderValues("Swift-CrateIO")
      ]

      let request = try Request(method: .post, uri: "/_sql", headers: headers, body: post)

      let requestData = Data(try requestToString(request))
      try! socket.send(requestData)

      //receiving data
      let received = try socket.receive(lowWaterMark: 1, highWaterMark: 1024*1024)

      //converting data to a string
      let str = try String(data: received)

      // print("received: \(str)")

      let parser = ResponseParser()

      do {
        if let response = try parser.parse(str) {
          switch response.body {
            case .buffer(let data):
              return try JSONParser().parse(data)
            default:
              break
          }
        }
      }
      catch {

      }
      return nil

    }


    public func blob (insert data: Data, into table: String) throws -> String? {

      let digest = Digest.sha1(try String(data: data))

      let headers: Headers = [
          "Content-Length": HeaderValues("\(data.bytes.count)"),
          "Content-Type": HeaderValues("application/x-www-form-urlencoded"),
          "User-Agent": HeaderValues("Swift-CrateIO")
      ]

      let request = try Request(method: .put, uri: "/_blobs/\(table)/\(digest)", headers: headers, body: data)

      try! socket.send(Data(requestToString(request)))

      //receiving data
      let received = try socket.receive(lowWaterMark: 1, highWaterMark: 1024)
      //converting data to a string
      let str = try String(data: received)

      let parser = ResponseParser()

      do {
        if let response = try parser.parse(str) {
          if response.statusCode == 201 {
            return digest
          }
        }
      }
      catch {

      }
      return nil
    }





    public func blob (fetch digest: String, from table: String) throws -> Data {


      let headers: Headers = [
          "User-Agent": HeaderValues("Swift-CrateIO")
      ]

      let request = try Request(method: .get, uri: "/_blobs/\(table)/\(digest)", headers: headers)


      try socket.send(Data(requestToString(request)))


      //receiving data
      let received = try socket.receive(lowWaterMark: 1, highWaterMark: 1024)
      //converting data to a string
      let str = try String(data: received)


      let parser = ResponseParser()

      do {
        if let response = try parser.parse(str) {
          if response.statusCode == 200 {
            switch response.body {
              case .buffer(let data):
                return data
              default:
                break
            }
          }
        }
      }
      catch {

      }
      return nil


    }



    private func requestToString (request : Request) throws -> String {
      var out = ""
      try RequestSerializer().serialize(request) { data in
        out += try String(data: data)
      }
      return out
    }

    deinit {
        socket.close()
    }

}
