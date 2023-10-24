package classes;

import java.util.Date;

public class Car {
    private int id;
    private String marka;
    private String model;
    private Date release;
    private String color;
    private int price;
    private String registrationNumber;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMarka() {
        return marka;
    }

    public void setMarka(String marka) {
        this.marka = marka;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public Date getRelease() {
        return release;
    }

    public void setRelease(Date release) {
        this.release = release;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getRegistrationNumber() {
        return registrationNumber;
    }

    public void setRegistrationNumber(String registrationNumber) {
        this.registrationNumber = registrationNumber;
    }

    public Car(int id, String marka, String model, Date release, String color, int price, String registrationNumber) {
        this.id = id;
        this.marka = marka;
        this.model = model;
        this.release = release;
        this.color = color;
        this.price = price;
        this.registrationNumber = registrationNumber;
    }

    public Car(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Car{" +
                "id=" + id +
                ", marka='" + marka + '\'' +
                ", model='" + model + '\'' +
                ", release=" + release +
                ", color='" + color + '\'' +
                ", price=" + price +
                ", registrationNumber='" + registrationNumber + '\'' +
                '}';
    }
    public static Car[] getArrCar() {
        Car[] cars = new Car[4];
        int m = 0;
        for (var i = 3 ; i >= 0; i--)
        {
            cars[m] = new Car(i, Integer.toString(i),Integer.toString(i),new Date(i,5,5),Integer.toString(i),i,Integer.toString(i));
            m++;
        }
        return cars;
    }
    public static void getCarsOfMark(Car[]cars,String marka) {
        for (var item: cars) {
            if (item.marka.equals(marka))
                System.out.println(item.toString());
        }
    }
    public static void getCarsOfModelAndYear(Car[]cars,String model,int years) {
        for (var item: cars) {
            if (item.marka.equals(model) & item.release.getYear() > years)
                System.out.println(item.toString());
        }
    }
    public static void getCarsOfYearAndPrice(Car[]cars,int years, int price) {
        for (var item: cars) {
            if (item.release.getYear() == years & item.price > price)
                System.out.println(item.toString());
        }
    }
}
