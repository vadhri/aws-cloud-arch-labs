package com.LeaderElection;

import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;

import java.io.IOException;

public class LeaderElection implements Watcher {
    private static final String ZOOKEEPER_ADDR = "localhost:2181";
    private static final int SESSION_TIMEOUT = 3000;
    private static ZooKeeper zook;

    public void connectToZooKeeper() throws IOException {
        zook = new ZooKeeper(ZOOKEEPER_ADDR, SESSION_TIMEOUT, this);
    }
    public static void main(String [] args) throws IOException, InterruptedException {
        LeaderElection le = new LeaderElection();
        le.connectToZooKeeper();
        le.run();
        le.close();
        System.out.println("Exited the zookeeper app....");
    }

    private void run() throws InterruptedException {
        synchronized (zook) {
            zook.wait();
        }
    }

    private void close() throws InterruptedException {
        zook.close();
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

        }
    }
}
