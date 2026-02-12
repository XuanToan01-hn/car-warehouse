/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author admin
 */
public class ValidateCustomer {
    public static final String NAME_REGEX_PRODUCT = "^[A-Za-zÀ-Ỹà-ỹ0-9\\s]+$";
    public final String NAME_REGEX = "^[A-Za-zÀ-Ỹà-ỹ\\s]+$";
    public final String PHONE_REGEX = "^(0|\\+84)[0-9]{9}$";
    public final String EMAIL_REGEX = "^[a-zA-Z0-9]+([._][a-zA-Z0-9]+)*@[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+$";
    public final String ADDRESS_REGEX = "^[a-zA-Z0-9À-Ỹà-ỹ\\s,\\.\\-\\_]+$";
    public final String CODE_REGEX = "^CUS\\d+$";
}
