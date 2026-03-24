package model.dto;

import java.io.Serializable;

/**
 * Một dòng trên form tạo PO (lưu trong session draft).
 */
public class PurchaseLineDraft implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer productDetailId;
    private int quantity = 1;
    private Integer taxId;
    private Double price;

    public Integer getProductDetailId() {
        return productDetailId;
    }

    public void setProductDetailId(Integer productDetailId) {
        this.productDetailId = productDetailId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Integer getTaxId() {
        return taxId;
    }

    public void setTaxId(Integer taxId) {
        this.taxId = taxId;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void clear() {
        this.productDetailId = null;
        this.quantity = 1;
        this.taxId = null;
        this.price = null;
    }
}
