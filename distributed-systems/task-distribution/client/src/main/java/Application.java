import java.util.Arrays;
import java.util.List;

public class Application {
    private static final String Worker1 = "http://localhost:8080/task";
    private static final String Worker2 = "http://localhost:8081/task";

    public static void main(String[] args) {
        TaskManager mgr = new TaskManager();
        String task1 = "1023,100";
        String task2 = "5000,40000";

        List<String> results = mgr.sendTasksToWorkers(Arrays.asList(Worker1, Worker2), Arrays.asList(task1, task2));

        for(String result: results) {
            System.out.println(result);
        }
    }
}
