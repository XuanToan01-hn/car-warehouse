/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class GoodsReceiptDetail {
    private int id;
    private GoodsReceipt receipt;
    private Product product;
    private ProductDetail productDetail;
    private int quantityExpected;
    private int quantityActual;

    public GoodsReceiptDetail() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public GoodsReceipt getReceipt() { return receipt; }
    public void setReceipt(GoodsReceipt receipt) { this.receipt = receipt; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public ProductDetail getProductDetail() { return productDetail; }
    public void setProductDetail(ProductDetail productDetail) { this.productDetail = productDetail; }

    public int getQuantityExpected() { return quantityExpected; }
    public void setQuantityExpected(int quantityExpected) { this.quantityExpected = quantityExpected; }

    public int getQuantityActual() { return quantityActual; }
    public void setQuantityActual(int quantityActual) { this.quantityActual = quantityActual; }
}

