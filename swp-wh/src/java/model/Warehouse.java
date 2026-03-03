package model;

import java.util.Date;

public class Warehouse {
    private int id;
    private String warehouseCode;
    private String warehouseName;
    private String address;
    private String description;
    private Date createdAt;

    public Warehouse() {}

    public Warehouse(int id) {
        this.id = id;
    }

    public Warehouse(String warehouseCode, String warehouseName, String address, String description, Date createdAt) {
        this.warehouseCode = warehouseCode;
        this.warehouseName = warehouseName;
        this.address = address;
        this.description = description;
        this.createdAt = createdAt;
    }
    
    

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getWarehouseCode() { return warehouseCode; }
    public void setWarehouseCode(String warehouseCode) { this.warehouseCode = warehouseCode; }

    public String getWarehouseName() { return warehouseName; }
    public void setWarehouseName(String warehouseName) { this.warehouseName = warehouseName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
