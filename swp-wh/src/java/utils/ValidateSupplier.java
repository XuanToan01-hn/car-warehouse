/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author win10
 */
public class ValidateSupplier {
     
    public static final String NAME_REGEX = "^(?!\\s*$).+"; 
    
    public static final String ADDRESS_REGEX = "^(?!\\s*$).+"; 
    
    public static final String PHONE_REGEX = "^0[0-9]{9}$";
    
    public static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    
    public static final String DESCRIPTION_REGEX = "^(?!\\s*$).+";
}
