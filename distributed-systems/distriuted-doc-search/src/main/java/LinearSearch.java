import results.Results;
import search.TFIDF;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LinearSearch {
    public static final String searchQuery = "The best detective that catches many criminals";
    public static final String searchQuery1 = "The girl that falls through a rabbit hole into wonder land.";
    public static final String searchQuery2 = "A war between Russia and france in cold winter.";

    public static void main(String [] args) throws IOException {
        File booksDir = new File("./src/main/resources/files/");

        Charset charset = StandardCharsets.UTF_8;

        List<String> queryWords = TFIDF.getWordsFromLine(Collections.singletonList(searchQuery2));
        Map<String, Results> dmap = new HashMap<>();

        for (File file: booksDir.listFiles()) {
            try {
                List<String> lines = Files.readAllLines(Paths.get(String.valueOf(file)), charset);
                List<String> wordsFromLines = TFIDF.getWordsFromLine(lines);
                Results res = TFIDF.calcFreqForAllTerms(wordsFromLines, queryWords);
                dmap.put(file.getName(),res);
            } catch (IOException ex) {
                System.out.format("I/O error: %s%n", ex);
            }
        }

        Map<Double, List<String>> docsByScore = TFIDF.getDocumentSortedByScore(queryWords, dmap);
        for (Double score: docsByScore.keySet()) {
            System.out.println(score+" " + docsByScore.get(score));
        }
    }
}
