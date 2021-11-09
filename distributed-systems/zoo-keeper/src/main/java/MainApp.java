import ClusterManagement.LeaderElection;
import ClusterManagement.RoleChangeManager;
import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;
import ClusterManagement.LeaderElection;
import ClusterManagement.ServiceRegistry;

import java.io.IOException;

public class MainApp implements Watcher {
    private static final String ZOOKEEPER_ADDR = "localhost:2181";
    private static final int SESSION_TIMEOUT = 3000;
    private static ZooKeeper zook;
    private static final int DEFAULT_PORT = 9999;

    public static void main(String [] args) throws IOException, InterruptedException, KeeperException {
        MainApp mAppInstance = new MainApp();

        int currentServicePort = args.length == 1 ? Integer.parseInt(args[0]) : DEFAULT_PORT;

        ZooKeeper instance = mAppInstance.connectToZooKeeper();
        ServiceRegistry sr = new ServiceRegistry(instance);
        RoleChangeManager rcm = new RoleChangeManager(sr, currentServicePort);
        LeaderElection le = new LeaderElection(instance, rcm);

        le.volunteerForLeadership();
        le.electLeader();

        mAppInstance.run();
        mAppInstance.close();

        System.out.println("Exited the zookeeper app....");
    }
    public ZooKeeper connectToZooKeeper() throws IOException {
        this.zook = new ZooKeeper(ZOOKEEPER_ADDR, SESSION_TIMEOUT, this);
        return this.zook;
    }

    @Override
    public void process(WatchedEvent event) {

    }

    private void run() throws InterruptedException {
        synchronized (zook) {
            zook.wait();
        }
    }

    private void close() throws InterruptedException {
        zook.close();
    }
}
