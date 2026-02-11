/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.List;

/**
 *
 * @author Asus
 */
public class PermissionGroup {
    private int id;
    private String groupName;
    private String description;
    private List<Permission> listPermissions;
    public PermissionGroup() {
    }

    public PermissionGroup(int id, String groupName, String description) {
        this.id = id;
        this.groupName = groupName;
        this.description = description;
    }

    public PermissionGroup(int id, String groupName, String description, List<Permission> listPermissions) {
        this.id = id;
        this.groupName = groupName;
        this.description = description;
        this.listPermissions = listPermissions;
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Permission> getListPermissions() {
        return listPermissions;
    }

    public void setListPermissions(List<Permission> listPermissions) {
        this.listPermissions = listPermissions;
    }
    
}


