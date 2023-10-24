package classes;

import java.util.Date;

public class Product {
    private int id;
    private String name;
    private String creater;
    private int storageTime;
    private int count;
    private int price;
    private String UPC;

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

    public String getCreater() {
        return creater;
    }

    public void setCreater(String creater) {
        this.creater = creater;
    }

    public int getStorageTime() {
        return storageTime;
    }

    public void setStorageTime(int storageTime) {
        this.storageTime = storageTime;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getUPC() {
        return UPC;
    }

    public void setUPC(String UPC) {
        this.UPC = UPC;
    }

    public Product(int id, String name, String creater, int storageTime, int count, int price, String UPC) {
        this.id = id;
        this.name = name;
        this.creater = creater;
        this.storageTime = storageTime;
        this.count = count;
        this.price = price;
        this.UPC = UPC;
    }

    public Product(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", creater='" + creater + '\'' +
                ", storageTime=" + storageTime +
                ", count=" + count +
                ", price=" + price +
                ", UPC='" + UPC + '\'' +
                '}';
    }
    public static Product[] getArrProduct() {
        Product[] products = new Product[4];
        int m = 0;
        for (var i = 3 ; i >= 0; i--)
        {
            products[m] = new Product(i, Integer.toString(i),Integer.toString(i),i,i,i,Integer.toString(i));
            m++;
        }
        return products;
    }
    public static void getProduct(Product[] products, String name) {
        for (var item: products) {
            if (item.name.equals(name))
                System.out.println(item.toString());
        }
    }
    public static  void getProduct(Product[] products,String name,int maxPrice) {
        for (var item : products) {
            if (item.name.equals(name) & item.price <= maxPrice)
                System.out.println(item.toString());
        }
    }
    public static  void getProduct(Product[] products,int storageTime) {
        for (var item : products) {
            if (item.storageTime > storageTime)
                System.out.println(item.toString());
        }
    }
}
