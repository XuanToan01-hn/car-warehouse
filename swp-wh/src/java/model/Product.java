/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class Product {
    private int id;
    private String code;
    private String name;
    private double price;
    private String description;
    private String image;
    private Unit unit;
    private Category category;
    private int minStock;

    public Product() {}

    public Product(int id, String code, String name, double price, String description, String image, Unit unit, Category category) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.price = price;
        this.description = description;
        this.image = image;
        this.unit = unit;
        this.category = category;
    }

    
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

    public int getMinStock() { return minStock; }
    public void setMinStock(int minStock) { this.minStock = minStock; }
}
