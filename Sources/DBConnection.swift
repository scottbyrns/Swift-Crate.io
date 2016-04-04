protocol DBConnection {

    //var connectionInfo: Info { get }

    func open() throws

    func close()

//    var status: StatusType { get }

    //var log: Log? { get set }

    //func execute(statement: QueryComponents) throws -> ResultType

}

protocol Test : DBConnection {
  func jump()
}
