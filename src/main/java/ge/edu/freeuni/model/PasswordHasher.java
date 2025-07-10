package ge.edu.freeuni.model;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordHasher {

    private static final String ALGORITHM = "SHA-1";

    /**
     * Generates hashed password
     *
     * @param password
     * @return hashedPassword
     */
    public static String hashPassword(String password) {
        return hexToString(passwordToHexArray(password));
    }

    /**
     * Generates HashValue of a given string in a bytes array form
     *
     * @param password
     * @return bytes
     */
    private static byte[] passwordToHexArray(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(password.getBytes());
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Generates a hex string from bytes array with 2 chars for each byte
     *
     * @param bytes
     * @return string
     */
    private static String hexToString(byte[] bytes) {
        StringBuffer buff = new StringBuffer();
        for (int i = 0; i < bytes.length; i++) {
            int val = bytes[i];
            val = val & 0xff;  // remove higher bits, sign
            if (val < 16) buff.append('0'); // leading 0
            buff.append(Integer.toString(val, 16));
        }
        return buff.toString();
    }



}