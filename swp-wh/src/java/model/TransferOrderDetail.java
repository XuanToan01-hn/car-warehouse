/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */

public class TransferOrderDetail {
    private int detailId;
    private int transferOrderId;
    private int productDetailId;
    private int quantity;

    public TransferOrderDetail() {}

    public int getDetailId() { return detailId; }
    public void setDetailId(int detailId) { this.detailId = detailId; }

    public int getTransferOrderId() { return transferOrderId; }
    public void setTransferOrderId(int transferOrderId) { this.transferOrderId = transferOrderId; }

    public int getProductDetailId() { return productDetailId; }
    public void setProductDetailId(int productDetailId) { this.productDetailId = productDetailId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
