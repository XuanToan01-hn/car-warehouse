/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */

import java.sql.Timestamp;

public class TransferOrder {
    private int id;
    private String transferCode;
    private int fromLocationId;
    private int toLocationId;
    private Timestamp transferDate;
    private int status; // 1: Draft/Pending, 2: Completed, 3: Cancelled
    private String note;
    private int createBy;

    private int productId;
    private int productDetailId;
    private int quantity;

    public TransferOrder() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTransferCode() { return transferCode; }
    public void setTransferCode(String transferCode) { this.transferCode = transferCode; }

    public int getFromLocationId() { return fromLocationId; }
    public void setFromLocationId(int fromLocationId) { this.fromLocationId = fromLocationId; }

    public int getToLocationId() { return toLocationId; }
    public void setToLocationId(int toLocationId) { this.toLocationId = toLocationId; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getProductDetailId() { return productDetailId; }
    public void setProductDetailId(int productDetailId) { this.productDetailId = productDetailId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getCreateBy() {
        return createBy;
    }

    public void setCreateBy(int createBy) {
        this.createBy = createBy;
    }
    
    
    
}