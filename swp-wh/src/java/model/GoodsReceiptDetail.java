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
    /** Max qty this line can still receive (expected − already delivered by OTHER confirmed GROs for the same PO) */
    private int remainingQty;
    /** Current stock of this product-detail at the receipt's location */
    private int currentStock;

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

    public int getRemainingQty() { return remainingQty; }
    public void setRemainingQty(int remainingQty) { this.remainingQty = remainingQty; }

    public int getCurrentStock() { return currentStock; }
    public void setCurrentStock(int currentStock) { this.currentStock = currentStock; }
}

