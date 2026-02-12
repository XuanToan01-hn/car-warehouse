package utils;

import dal.UserDAO;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import model.User;

public class InputValidator {

    public static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    public static final String NAME_USER = "^[a-zA-ZÀ-ỹ\\s'-]{2,50}$";
    public static final String PHONE_NUMBER = "^(\\+84|0)[0-9]{9,10}$";
    public static final String USERNAME = "^[a-zA-Z0-9._]{2,20}$";
    public static final String PASSWORD = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    public static final String USER_CODE = "^(MN|AD|SS|PS|WS)\\d{6}$";

    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValid(String str, String regex) {
        return str != null && str.matches(regex);
    }

    public static boolean isOver18(LocalDate dateOfBirth) {
        if (dateOfBirth == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        Period age = Period.between(dateOfBirth, today);
        return age.getYears() >= 18;
    }
    
    public static String normalizeSpaces(String input) {
    if (input == null) return "";
    return input.trim().replaceAll("\\s{2,}", " ");
}

}
