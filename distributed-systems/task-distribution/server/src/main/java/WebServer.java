import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpContext;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigInteger;
import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

public class WebServer {
    private static final String task = "/task";
    private static final String status = "/status";

    private static int port = 9999;
    private HttpServer httpserver;

    public static void main(String [] args) throws IOException {
        int serverPort = args.length == 1 ? Integer.parseInt(args[0]) : port;
        WebServer s = new WebServer(serverPort);
        s.startServer();
    }

    WebServer (int port) {
        this.port = port;
    }

    private void startServer() throws IOException {
        try{
            this.httpserver = HttpServer.create(new InetSocketAddress(port), 0);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }
        HttpContext taskCtx = httpserver.createContext(task);
        HttpContext statusCtx = httpserver.createContext(status);

        taskCtx.setHandler(this::handleTask);
        statusCtx.setHandler(this::handleStatus);

        httpserver.setExecutor(Executors.newFixedThreadPool(8));
        httpserver.start();
    }

    private byte[] calculateResponse(byte [] requestBytes) {
        String bodyNumbers = new String(requestBytes);
        String [] stringNumbers = bodyNumbers.split(",");

        BigInteger res = BigInteger.ONE;
        for (String number : stringNumbers) {
            BigInteger temp = new BigInteger(number);
            res = res.multiply(temp);
        }

        return String.format("%s", res).getBytes();
    }

    private void handleTask(HttpExchange exchange) throws IOException {
        if (!exchange.getRequestMethod().equalsIgnoreCase("post")) {
            exchange.close();
            return;
        }

        Headers headers = exchange.getRequestHeaders();
        if (headers.containsKey("X-Custom-Debug") && headers.get("X-Custom-Debug").get(0).equalsIgnoreCase("test")) {
            String testResponse = "Rcvd. OK";
            sendResponse(testResponse.getBytes(), exchange);
        }

        byte [] task = exchange.getRequestBody().readAllBytes();
        byte [] ctask = calculateResponse(task);
        sendResponse(ctask, exchange);
    }

    private void handleStatus(HttpExchange exchange) throws IOException {
        if (!exchange.getRequestMethod().equalsIgnoreCase("get")) {
            exchange.close();
            return;
        }

        String response = "Healthy. OK.";
        sendResponse(response.getBytes(), exchange);
    }

    private void sendResponse(byte[] r, HttpExchange exchange) throws IOException {
        exchange.sendResponseHeaders(200, r.length);
        OutputStream out = exchange.getResponseBody();
        out.write(r);
        out.flush();
        out.close();
    }
}
