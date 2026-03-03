package model;

public class Product {
    private int id;
    private String code;
    private String name;
    private double price;
    private String description;
    private String image;
    private Unit unit;
    private Category category;
    private Supplier supplier; // Cập nhật theo FK_Product_Supplier
    private int minStock;
    private String color;

    // Thêm Getter và Setter
    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
    public Product() {}

    // Getter và Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public Unit getUnit() { return unit; }
    public void setUnit(Unit unit) { this.unit = unit; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public Supplier getSupplier() { return supplier; }
    public void setSupplier(Supplier supplier) { this.supplier = supplier; }

    public int getMinStock() { return minStock; }
    public void setMinStock(int minStock) { this.minStock = minStock; }
}