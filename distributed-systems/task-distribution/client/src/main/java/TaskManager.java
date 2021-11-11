import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class TaskManager {
    private WebClient webClient;

    public TaskManager() {
        this.webClient = new WebClient();
    }

    public List<String> sendTasksToWorkers(List<String> workerAddresses, List<String> tasks) {
        CompletableFuture<String>[] futures = new CompletableFuture[workerAddresses.size()];

        for (int i = 0; i < tasks.size(); i++) {
            String workerAddress = workerAddresses.get(i);
            String task = tasks.get(i);

            byte [] requestPayload = task.getBytes();

            futures[i] = webClient.sendTask(workerAddress, requestPayload);
        }

        List<String> results = Stream.of(futures).map(CompletableFuture::join).collect(Collectors.toList());
        return results;
    }
}
