package results;

import java.util.HashMap;
import java.util.Map;

public class Results {
    private Map<String, Double> termFrequency = new HashMap();

    public void putFrequency(String term, Double freq) {
        termFrequency.put(term, freq);
    }

    public Double getFrequency(String term) {
        return termFrequency.get(term);
    }

    public void printAllContents() {
        for (String k: termFrequency.keySet()) {
            System.out.println(k + " " + termFrequency.get(k));
        }
    }
}
