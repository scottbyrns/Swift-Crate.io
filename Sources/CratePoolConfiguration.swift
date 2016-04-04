import ConnectionPool
import Venice

public class CratePoolConfiguration : PoolConfiguration {

    // Set how long a pool can suffer a continued series of errors before it is removed from the pool.
    public var maxErrorDuration: Duration = 1.minute

    // Set how long to wait before trying to issue a connection to a consumer after finding none available.
    public var retryDelay: Duration = 10.milliseconds

    // How long to wait for a connection to be available before giving up.
    public var connectionWait: Duration = 30.milliseconds

    // How long to keep trying to reconnect a closed socket before removing it from the pool.
    public var maxReconnectDuration: Duration = 5.minutes

}
