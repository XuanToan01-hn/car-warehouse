package model;

public class PurchaseOrderDetail {
    private int id;
    private int purchaseOrderId;
    private Product product;
    private int quantity;
    private double price;
    private Tax tax;
    private double subTotal;

    public PurchaseOrderDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPurchaseOrderId() { return purchaseOrderId; }
    public void setPurchaseOrderId(int purchaseOrderId) { this.purchaseOrderId = purchaseOrderId; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Tax getTax() { return tax; }
    public void setTax(Tax tax) { this.tax = tax; }

    public double getSubTotal() { return subTotal; }
    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }
}
