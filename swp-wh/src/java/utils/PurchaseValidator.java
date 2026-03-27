package utils;

import dal.PurchaseOrderDAO;

/**
 * Server-side validation for Purchase Order fields to prevent bypass.
 */
public class PurchaseValidator {

    /**
     * Order Code format: PO-YYYYMMDD-NNNN
     */
    public static final String ORDER_CODE_REGEX = "^PO-\\d{8}-\\d{4}$";

    /**
     * Validates Order Code format.
     */
    public static boolean isValidOrderCode(String code) {
        return code != null && code.matches(ORDER_CODE_REGEX);
    }

    /**
     * Checks if Order Code is unique (does not exist in DB).
     */
    public static boolean isOrderCodeUnique(String code) {
        if (code == null || code.trim().isEmpty()) {
            return false;
        }
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        return !dao.existsByOrderCode(code.trim());
    }

    /**
     * Checks if Order Code is unique, excluding a specific PO (for edit).
     */
    public static boolean isOrderCodeUnique(String code, int excludePoId) {
        if (code == null || code.trim().isEmpty()) {
            return false;
        }
        PurchaseOrderDAO dao = new PurchaseOrderDAO();
        return !dao.existsByOrderCodeExcluding(code.trim(), excludePoId);
    }

    /**
     * Validates Unit Price: must be a valid positive number.
     */
    public static boolean isValidUnitPrice(String priceStr) {
        if (priceStr == null || priceStr.trim().isEmpty()) {
            return false;
        }
        try {
            double price = Double.parseDouble(priceStr.trim());
            return price > 0 && !Double.isInfinite(price) && !Double.isNaN(price);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * Validates Quantity: must be a valid positive integer >= 1.
     */
    public static boolean isValidQuantity(String qtyStr) {
        if (qtyStr == null || qtyStr.trim().isEmpty()) {
            return false;
        }
        try {
            int qty = Integer.parseInt(qtyStr.trim());
            return qty >= 1;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
