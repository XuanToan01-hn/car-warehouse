/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class LocationProduct {
    private int id; // optional nếu bạn muốn log, DB là PK composite
    private Location location;
    private Product product;
    private ProductDetail productDetail;
    private int quantity;

    public LocationProduct() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public ProductDetail getProductDetail() { return productDetail; }
    public void setProductDetail(ProductDetail productDetail) { this.productDetail = productDetail; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}

