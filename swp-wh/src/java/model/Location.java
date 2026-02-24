package model;

public class Location {

    private int id;
    private int warehouseId;
    private String locationCode;
    private String locationName;
    private Integer parentLocationId;
    private String locationType;
    private Integer maxCapacity;
    private Integer aggregatedCapacity; // Calculated sum of children's capacities

    public Location() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(int warehouseId) {
        this.warehouseId = warehouseId;
    }

    public String getLocationCode() {
        return locationCode;
    }

    public void setLocationCode(String locationCode) {
        this.locationCode = locationCode;
    }

    public String getLocationName() {
        return locationName;
    }

    public void setLocationName(String locationName) {
        this.locationName = locationName;
    }

    public Integer getParentLocationId() {
        return parentLocationId;
    }

    public void setParentLocationId(Integer parentLocationId) {
        this.parentLocationId = parentLocationId;
    }

    public String getLocationType() {
        return locationType;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public Integer getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(Integer maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public Integer getAggregatedCapacity() {
        return aggregatedCapacity != null ? aggregatedCapacity : (maxCapacity != null ? maxCapacity : 0);
    }

    public void setAggregatedCapacity(Integer aggregatedCapacity) {
        this.aggregatedCapacity = aggregatedCapacity;
    }
}
