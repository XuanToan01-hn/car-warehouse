package model.dto;

import java.io.Serializable;

/**
 * One line on the PO create/edit form (stored in session draft).
 */
public class PurchaseLineDraft implements Serializable {

    private static final long serialVersionUID = 1L;

    private Integer productDetailId;
    private int quantity = 1;
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

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void clear() {
        this.productDetailId = null;
        this.quantity = 1;
        this.price = null;
    }
}
