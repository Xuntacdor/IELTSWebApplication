package util;

import model.GoogleUser;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class GoogleUtils {


    private static final String CLIENT_ID = "";
    private static final String CLIENT_SECRET = ""; // <-- Thay đúng secret
    private static final String REDIRECT_URI = "";

    public static String getToken(String code) throws IOException {
        String url = "https://oauth2.googleapis.com/token";
        String params = "code=" + code
                + "&client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + REDIRECT_URI
                + "&grant_type=authorization_code";

        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes());
        }

        int status = conn.getResponseCode();
        if (status != 200) {
            // In lỗi chi tiết nếu token request bị từ chối
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            StringBuilder errorMsg = new StringBuilder();
            String line;
            while ((line = errorReader.readLine()) != null) {
                errorMsg.append(line);
            }
            errorReader.close();

            System.err.println("=== TOKEN ERROR ===");
            System.err.println(errorMsg);
            System.err.println("===================");

            throw new IOException("Failed to get token. HTTP error code: " + status + "\n" + errorMsg);
        }

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();

        JSONObject json = new JSONObject(response.toString());
        return json.getString("access_token");
    }

    public static GoogleUser getUserInfo(String accessToken) throws IOException {
        String url = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken;

        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
        conn.setRequestMethod("GET");

        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line);
        }
        reader.close();

        JSONObject json = new JSONObject(response.toString());

        GoogleUser user = new GoogleUser();
        user.setId(json.getString("id"));
        user.setFullName(json.getString("name"));
        user.setEmail(json.getString("email"));
        user.setPicture(json.getString("picture"));
        return user;
    }
}
