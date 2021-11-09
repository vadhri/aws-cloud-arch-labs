package ClusterManagement;

import org.apache.zookeeper.*;
import org.apache.zookeeper.data.Stat;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ServiceRegistry implements Watcher {
    private ZooKeeper zook;
    private String SRV_NAMESPACE = "/service_registry";
    private String serviceRegistry;
    private String currentZnode;
    private List<String> allNodesInCluster;

    public ServiceRegistry(ZooKeeper zook) throws InterruptedException, KeeperException {
        this.zook = zook;
        createServiceRegistry();
        updateNodesInCluster();
    }

    private void createServiceRegistry() throws InterruptedException, KeeperException {
        try {
            if (zook.exists(SRV_NAMESPACE, false) == null) {
                this.serviceRegistry = zook.create(SRV_NAMESPACE, new byte[]{}, ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
                System.out.println("Service registry created =" + SRV_NAMESPACE);
            }
        } catch (KeeperException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void registryToServiceRegistry(String metadata) throws InterruptedException, KeeperException {
        try {
            this.currentZnode = zook.create(SRV_NAMESPACE+"/srv_", metadata.getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.EPHEMERAL_SEQUENTIAL);
        } catch (KeeperException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void unregisterFromServiceRegistry() throws InterruptedException, KeeperException {
        try {
            if (currentZnode != null && zook.exists(currentZnode, false) != null) {
                zook.delete(currentZnode, -1);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (KeeperException e) {
            e.printStackTrace();
        }
    }

    public synchronized void updateNodesInCluster() throws InterruptedException, KeeperException {
        List<String> workerNodes = zook.getChildren(SRV_NAMESPACE, this);
        List<String> peerAddresses = new ArrayList<String>(workerNodes.size());

        for(String peer: workerNodes) {
            String peerAddress = SRV_NAMESPACE + "/" + peer;
            Stat stat = zook.exists(peerAddress, false);

            if (stat == null) {
                continue;
            }

            byte [] peerdata = zook.getData(peerAddress, false, stat);
            peerAddresses.add(new String(peerdata));
        }
        this.allNodesInCluster = Collections.unmodifiableList(peerAddresses);
        System.out.println("Nodes in the cluster =" + this.allNodesInCluster + "workerNodes = " + workerNodes);
    }

    @Override
    public void process(WatchedEvent event) {
        try {
            updateNodesInCluster();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (KeeperException e) {
            e.printStackTrace();
        }
    }
}
