/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class Permission {
    private int id;
    private String name;
    private String url;
    private String description;
    private PermissionGroup permissionGroup;
    private boolean checked;

    public Permission() {
    }

    public Permission(int id, String name, String url, String description, PermissionGroup permissionGroup) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.description = description;
        this.permissionGroup = permissionGroup;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public PermissionGroup getPermissionGroup() {
        return permissionGroup;
    }

    public void setPermissionGroup(PermissionGroup permissionGroup) {
        this.permissionGroup = permissionGroup;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }
    
    
}