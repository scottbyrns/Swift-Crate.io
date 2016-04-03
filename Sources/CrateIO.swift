
import TCP
import JSON
import Data
import Digest
import HTTP
import HTTPParser
import HTTPSerializer
import S4

public class CrateIO {

    var socketPool : ConnectionPool<TCPClientSocket>
    var currentSocket = -1
    let hosts: [String]
    let ports: [Int]

    public init(pool connections: [TCPClientSocket], using configuration: CratePoolConfiguration) throws {
		socketPool = ConnectionPool<TCPClientSocket>(pool: connections, using: configuration)
    }

    private func nextSocket() -> TCPClientSocket {
      currentSocket += 1
      if currentSocket >= sockets.count {
        currentSocket = 0
      }
      return sockets[currentSocket]
    }

    public func sql (statement: String) throws -> JSON? {

        // Get a connection from the pool to use.
	    return try pool.with({ connection in
			
	        let post = "{\"stmt\": \"\(statement)\"}\r\n"
	        let postBytes = [UInt8](post.utf8)

	        let headers: Headers = [
	            "Content-Length": HeaderValues("\(postBytes.count)"),
	            "Content-Type": HeaderValues("application/json"),
	            "User-Agent": HeaderValues("Swift-CrateIO")
	        ]

	        let request = try Request(method: .post, uri: "/_sql", headers: headers, body: post)

	        let requestData = Data(try requestToString(request))
	        try! connection.send(requestData)

	        //receiving data
	        let received = try connection.receive(lowWaterMark: 1, highWaterMark: 1024*1024)

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
			
	    })

    }


    public func blob (insert data: Data, into table: String) throws -> String? {

	    // Get a connection from the pool to use.
	    return try pool.with({ connection in

	        let digest = Digest.sha1(try String(data: data))

	        let headers: Headers = [
	            "Content-Length": HeaderValues("\(data.bytes.count)"),
	            "Content-Type": HeaderValues("application/x-www-form-urlencoded"),
	            "User-Agent": HeaderValues("Swift-CrateIO")
	        ]

	        let request = try Request(method: .put, uri: "/_blobs/\(table)/\(digest)", headers: headers, body: data)

	        try! connection.send(Data(requestToString(request)))

	        //receiving data
	        let received = try connection.receive(lowWaterMark: 1, highWaterMark: 1024)
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
			
	    })
		
    }





    public func blob (fetch digest: String, from table: String) throws -> Data {

        // Get a connection from the pool to use.
        return try pool.with({ connection in

	        let headers: Headers = [
	            "User-Agent": HeaderValues("Swift-CrateIO")
	        ]

	        let request = try Request(method: .get, uri: "/_blobs/\(table)/\(digest)", headers: headers)


	        try connection.send(Data(requestToString(request)))


	        //receiving data
	        let received = try connection.receive(lowWaterMark: 1, highWaterMark: 1024)
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
			
        })

    }



    private func requestToString (request : Request) throws -> String {
      var out = ""
      try RequestSerializer().serialize(request) { data in
        out += try String(data: data)
      }
      return out
    }

    deinit {
      for socket in sockets {
        socket.close()
      }
    }

}
