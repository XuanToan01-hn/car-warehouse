package model.dto;

/**
 * Một lựa chọn variant (ProductDetail) cho dropdown server-rendered.
 */
public class ProductDetailOption {

    private final int id;
    private final String label;
    private final double price;
    private final int productId;
    private final String color;

    public ProductDetailOption(int id, String label, double price, int productId, String color) {
        this.id = id;
        this.label = label;
        this.price = price;
        this.productId = productId;
        this.color = color;
    }

    public int getId() {
        return id;
    }

    public String getLabel() {
        return label;
    }

    public double getPrice() {
        return price;
    }

    public int getProductId() {
        return productId;
    }

    public String getColor() {
        return color;
    }
}
