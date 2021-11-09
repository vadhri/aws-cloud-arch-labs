package ClusterManagement;

import org.apache.zookeeper.KeeperException;

import java.net.Inet4Address;
import java.net.UnknownHostException;

public class RoleChangeManager implements ElectionResults {
    private final ServiceRegistry sr;
    private final int port;

    public RoleChangeManager(ServiceRegistry sr, int port) {
        this.sr = sr;
        this.port = port;
    }

    @Override
    public void OnElectedLeader() throws InterruptedException, KeeperException {
        this.sr.unregisterFromServiceRegistry();
    }

    @Override
    public void OnWorker() throws UnknownHostException, InterruptedException, KeeperException {
        String currentServiceUrl = String.format("http://%s:%d", Inet4Address.getLocalHost().getCanonicalHostName(), port);
        this.sr.registryToServiceRegistry(currentServiceUrl);
    }
}
