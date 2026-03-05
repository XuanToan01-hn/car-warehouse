/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class GoodsIssueDetail {
    private int id;
    private GoodsIssue issue;
    private ProductDetail productDetail;
    private int quantityExpected;
    private int quantityActual;

    public GoodsIssueDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public GoodsIssue getIssue() { return issue; }
    public void setIssue(GoodsIssue issue) { this.issue = issue; }

    public ProductDetail getProductDetail() { return productDetail; }
    public void setProductDetail(ProductDetail productDetail) { this.productDetail = productDetail; }

    public int getQuantityExpected() { return quantityExpected; }
    public void setQuantityExpected(int quantityExpected) { this.quantityExpected = quantityExpected; }

    public int getQuantityActual() { return quantityActual; }
    public void setQuantityActual(int quantityActual) { this.quantityActual = quantityActual; }
}

