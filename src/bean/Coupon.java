package bean;

public class Coupon {
    private int couponId;
    private int discountRate;

    private Integer menuItemId; // FK: cook_menu
    private Integer storeId;    // FK: store

}
