package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.util.Properties;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.io.UnsupportedEncodingException;

public class EmailUtility {

    private static final Map<String, String> env = new HashMap<>();

    static {
        loadEnv();
    }

    private static void loadEnv() {
        try (InputStream is = EmailUtility.class.getClassLoader().getResourceAsStream(".env")) {
            if (is != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.startsWith("#")) {
                        int index = line.indexOf("=");
                        if (index > 0) {
                            String key = line.substring(0, index).trim();
                            String value = line.substring(index + 1).trim();
                            env.put(key, value);
                        }
                    }
                }
            } else {
                System.err.println("Could not find .env file in classpath");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean sendEmail(String toEmail, String subject, String body) {
        boolean isSent = false;
        
        final String authEmail = env.getOrDefault("AUTH_EMAIL", "");
        final String authPassword = env.getOrDefault("AUTH_PASSWORD", "");
        final String aliasEmail = env.getOrDefault("ALIAS_EMAIL", authEmail);
        final String aliasName = env.getOrDefault("ALIAS_NAME", "");
        
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        // For debugging
        // properties.put("mail.debug", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(authEmail, authPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            
            if (!aliasName.isEmpty()) {
                message.setFrom(new InternetAddress(aliasEmail, aliasName));
            } else {
                message.setFrom(new InternetAddress(aliasEmail));
            }
            
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
            isSent = true;
        } catch (MessagingException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return isSent;
    }
}
