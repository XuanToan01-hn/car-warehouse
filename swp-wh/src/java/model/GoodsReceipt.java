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

public class GoodsReceipt {
    private int id;
    private String receiptCode;
    private PurchaseOrder purchaseOrder;
    private Location location;
    private Date receiptDate;
    private int status;
    private String note;
    private User createBy;

    public GoodsReceipt() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }

    public PurchaseOrder getPurchaseOrder() { return purchaseOrder; }
    public void setPurchaseOrder(PurchaseOrder purchaseOrder) { this.purchaseOrder = purchaseOrder; }

    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }

    public Date getReceiptDate() { return receiptDate; }
    public void setReceiptDate(Date receiptDate) { this.receiptDate = receiptDate; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public User getCreateBy() { return createBy; }
    public void setCreateBy(User createBy) { this.createBy = createBy; }
}
