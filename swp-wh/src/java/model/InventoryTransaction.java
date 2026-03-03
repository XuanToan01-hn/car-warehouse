/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
import java.util.Date;

public class InventoryTransaction {
    private int id;
    private Product product;
    private ProductDetail productDetail;
    private Location location;
    private String transactionType;
    private int quantity;
    private String referenceCode;
    private Date transactionDate;

    public InventoryTransaction() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public ProductDetail getProductDetail() { return productDetail; }
    public void setProductDetail(ProductDetail productDetail) { this.productDetail = productDetail; }

    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }

    public String getTransactionType() { return transactionType; }
    public void setTransactionType(String transactionType) { this.transactionType = transactionType; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getReferenceCode() { return referenceCode; }
    public void setReferenceCode(String referenceCode) { this.referenceCode = referenceCode; }

    public Date getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Date transactionDate) { this.transactionDate = transactionDate; }
}

