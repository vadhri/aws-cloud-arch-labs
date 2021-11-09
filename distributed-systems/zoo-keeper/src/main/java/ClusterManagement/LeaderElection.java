package ClusterManagement;

import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.KeeperException;
import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooDefs;
import org.apache.zookeeper.ZooKeeper;
import org.apache.zookeeper.data.Stat;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.Collections;
import java.util.List;

public class LeaderElection implements Watcher {
    private static final String ZOOKEEPER_ADDR = "localhost:2181";
    private static final int SESSION_TIMEOUT = 3000;
    private static String ELECTION_NAMESPACE = "/election";
    private String currentZnodeName;
    private ZooKeeper zook;
    private RoleChangeManager roleChangeManager;

    public LeaderElection(ZooKeeper mz, RoleChangeManager rcm) {
        this.zook = mz;
        this.roleChangeManager = rcm;
    }

    public void volunteerForLeadership() throws KeeperException, InterruptedException {
        String prefix = ELECTION_NAMESPACE + "/c_";
        String zNodeFullPath = zook.create(prefix, new byte[]{}, ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL_SEQUENTIAL);
        System.out.println("zNodeFullPath =" + zNodeFullPath);

        this.currentZnodeName = zNodeFullPath.replace(ELECTION_NAMESPACE+"/", "");
    }

    public void electLeader() throws KeeperException, InterruptedException, UnknownHostException {
        String predecessorZnodeName = "";
        Stat predecessorStats = null;
        List<String> clist = zook.getChildren(ELECTION_NAMESPACE, false);
        Collections.sort(clist);

        while (predecessorStats == null) {
            String smallestChild = clist.get(0);
            if (smallestChild.equals(this.currentZnodeName)) {
                System.out.println("Current node is the leader");
                roleChangeManager.OnElectedLeader();
                return;
            } else {
                System.out.println("Current node is not the leader. " + smallestChild + " is the laeder");
                int predecessorIndex = Collections.binarySearch(clist, currentZnodeName) - 1;
                predecessorZnodeName = clist.get(predecessorIndex);
                predecessorStats = zook.exists(ELECTION_NAMESPACE + "/" + predecessorZnodeName, this);
            }
        }
        roleChangeManager.OnWorker();
        System.out.println("Watching node..." + predecessorZnodeName);
    }

    @Override
    public void process(WatchedEvent watchedEvent) {
        switch (watchedEvent.getType()) {
            case None:
                if (watchedEvent.getState() == Event.KeeperState.SyncConnected) {
                    System.out.println("Connected to the leader zoo keeper server.....");
                } else {
                    synchronized (zook) {
                        zook.notifyAll();
                    }
                }
                break;
            case NodeDeleted:
                try {
                    electLeader();
                } catch (KeeperException e) {
                    e.printStackTrace();
                } catch (InterruptedException | UnknownHostException e) {
                    e.printStackTrace();
                }

                break;
            default:
                throw new IllegalStateException("Unexpected value: " + watchedEvent.getType());
        }
    }
}
