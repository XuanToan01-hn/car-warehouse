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

public class GoodsIssue {
    private int id;
    private String issueCode;
    private SalesOrder salesOrder;
    private Location location;
    private Date expectedDeliveryDate;
    private Date actualDeliveryDate;
    private Date issueDate;
    private int status;
    private String note;
    private User createBy;

    public GoodsIssue() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getIssueCode() { return issueCode; }
    public void setIssueCode(String issueCode) { this.issueCode = issueCode; }

    public SalesOrder getSalesOrder() { return salesOrder; }
    public void setSalesOrder(SalesOrder salesOrder) { this.salesOrder = salesOrder; }

    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }

    public Date getExpectedDeliveryDate() { return expectedDeliveryDate; }
    public void setExpectedDeliveryDate(Date expectedDeliveryDate) { this.expectedDeliveryDate = expectedDeliveryDate; }

    public Date getActualDeliveryDate() { return actualDeliveryDate; }
    public void setActualDeliveryDate(Date actualDeliveryDate) { this.actualDeliveryDate = actualDeliveryDate; }

    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public User getCreateBy() { return createBy; }
    public void setCreateBy(User createBy) { this.createBy = createBy; }
}

