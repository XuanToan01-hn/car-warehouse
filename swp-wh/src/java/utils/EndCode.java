package utils;

import java.security.MessageDigest;
import java.util.Base64; // Sử dụng thư viện chuẩn của Java thay vì Tomcat

public class EndCode {

    public static String toSHA1(String str){
        String salt = "hfbsdfhdsfdkshfbdsfhksbdf;sdfd";
        String result = null;
        str = str + salt;
        try {
            byte[] dataBytes = str.getBytes("UTF-8");
            MessageDigest md = MessageDigest.getInstance("SHA-1");

            // Sử dụng Base64.getEncoder().encodeToString của java.util
            result = Base64.getEncoder().encodeToString(md.digest(dataBytes));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // Thêm hàm main để bạn có thể test trực tiếp
    public static void main(String[] args) {
        String originalPassword = "admin";
        String encodedPassword = toSHA1(originalPassword);

        System.out.println("Mật khẩu gốc: " + originalPassword);
        System.out.println("Mật khẩu sau khi mã hóa: " + encodedPassword);
    }
}