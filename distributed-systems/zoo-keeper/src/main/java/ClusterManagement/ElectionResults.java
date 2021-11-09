package ClusterManagement;

import org.apache.zookeeper.KeeperException;

import java.net.UnknownHostException;

public interface ElectionResults {
    public void OnElectedLeader() throws InterruptedException, KeeperException;
    public void OnWorker() throws UnknownHostException, InterruptedException, KeeperException;
}
