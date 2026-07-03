package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for hashing and verifying passwords with BCrypt.
 *
 * Work factor 12 is a good balance between security and performance
 * (increases hash time exponentially with each increment).
 */
public class PasswordUtil {

    private static final int WORK_FACTOR = 12;

    /** Returns a BCrypt hash of the raw plain-text password. */
    public static String hash(String rawPassword) {
        return BCrypt.hashpw(rawPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Verifies a raw password against a stored BCrypt hash.
     *
     * @param rawPassword the plain-text password to check
     * @param storedHash  the BCrypt hash stored in the database
     * @return true if they match
     */
    public static boolean verify(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null) return false;
        try {
            return BCrypt.checkpw(rawPassword, storedHash);
        } catch (Exception e) {
            // Malformed hash (e.g. old plain-text during migration)
            return false;
        }
    }

    /**
     * Returns true if the stored value looks like a BCrypt hash.
     * Useful during one-time migration of plain-text passwords.
     */
    public static boolean isBcryptHash(String value) {
        return value != null && (value.startsWith("$2a$") || value.startsWith("$2b$") || value.startsWith("$2y$"));
    }
}
