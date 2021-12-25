package search;

import results.Results;

import java.io.StringBufferInputStream;
import java.util.*;

public class TFIDF {
    public static double calculateFrequencyOfTerm(List<String> words, String term) {
        int count = 0;
        for (String word: words) {
            if (word.equalsIgnoreCase(term)) {
               count++;
            }
        }

       return  count*1.0/words.size();
    }
    public static Results calcFreqForAllTerms(List<String> words, List<String> terms) {
        Results res = new Results();

        for (String term: terms) {
            res.putFrequency(term, calculateFrequencyOfTerm(words, term));
        }
        return res;
    }

    public static double calcInverseDocFreq(String term, Map<String, Results> documentFreq) {
        double res = 0;

        for (String doc: documentFreq.keySet()) {
            Results docFreq = documentFreq.get(doc);
            if (docFreq.getFrequency(term) > 0.0) {
                res++;
            }
        }

        return res == 0 ? 0: Math.log10(documentFreq.size()/res);
    }

    public static Map<String, Double> getIdfForAllTerms(List<String> terms, Map<String, Results> documentFreq) {
        Map<String, Double> res = new HashMap<>();

        for (String term: terms) {
            res.put(term, calcInverseDocFreq(term, documentFreq));
        }

        return res;
    }

    public static double calculateDocumentScoreForAllTerms(List<String> terms, Results res, Map<String, Double> docResults) {
        double score = 0;

        for (String term: terms) {
            double termFreq = res.getFrequency(term);
            double invTermFreq = docResults.get(term);
            score += termFreq * invTermFreq;
        }

        return score;
    }

    public static Map<Double, List<String>> getDocumentSortedByScore(List<String> terms, Map<String, Results> docResults) {
        TreeMap<Double, List<String>> sortedMap = new TreeMap();

        Map<String, Double> termToInverseDocumentFreq = getIdfForAllTerms(terms, docResults);

        for (String doc: docResults.keySet()) {
            Results res = docResults.get(doc);
            Double score = calculateDocumentScoreForAllTerms(terms, res, termToInverseDocumentFreq);
            List<String> docListForScore = sortedMap.get(score);
            if (docListForScore == null) {
                docListForScore = new ArrayList<String>();
            }
            docListForScore.add(doc);
            sortedMap.put(score, docListForScore);
        }

        return sortedMap.descendingMap();
    }
    public static List<String> getWordsFromLine(List<String> lines) {
        List<String> words = new ArrayList<String>();

        for (String line: lines) {
            words.addAll(List.of(line.split("\\t|,|;| |\\.|\\?|!|-|:|@|\\[|\\]|\\(|\\)|\\{|\\}|_|\\*|/")));
        }
        return words;
    }
}
