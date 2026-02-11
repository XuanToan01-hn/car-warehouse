/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class SalesOrderDetail {
    private int id;
    private SalesOrder salesOrder;
    private ProductDetail productDetail;
    private int quantity;
    private double price;
    private Tax tax;
    private double subTotal;

    public SalesOrderDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public SalesOrder getSalesOrder() { return salesOrder; }
    public void setSalesOrder(SalesOrder salesOrder) { this.salesOrder = salesOrder; }

    public ProductDetail getProductDetail() { return productDetail; }
    public void setProductDetail(ProductDetail productDetail) { this.productDetail = productDetail; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public Tax getTax() { return tax; }
    public void setTax(Tax tax) { this.tax = tax; }

    public double getSubTotal() { return subTotal; }
    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }
}

