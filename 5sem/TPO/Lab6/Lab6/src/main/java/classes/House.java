package classes;

import java.util.Date;

public class House {
    private int id;
    private String numberFlat;
    private int square;
    private int floor;
    private int countOfRooms;
    private String street;
    private String typeOfHouse;
    private int term;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumberFlat() {
        return numberFlat;
    }

    public void setNumberFlat(String numberFlat) {
        this.numberFlat = numberFlat;
    }

    public int getSquare() {
        return square;
    }

    public void setSquare(int square) {
        this.square = square;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public int getCountOfRooms() {
        return countOfRooms;
    }

    public void setCountOfRooms(int countOfRooms) {
        this.countOfRooms = countOfRooms;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getTypeOfHouse() {
        return typeOfHouse;
    }

    public void setTypeOfHouse(String typeOfHouse) {
        this.typeOfHouse = typeOfHouse;
    }

    public int getTerm() {
        return term;
    }

    public void setTerm(int term) {
        this.term = term;
    }

    public House(int id, String numberFlat, int square, int floor, int countOfRooms, String street, String typeOfHouse, int term) {
        this.id = id;
        this.numberFlat = numberFlat;
        this.square = square;
        this.floor = floor;
        this.countOfRooms = countOfRooms;
        this.street = street;
        this.typeOfHouse = typeOfHouse;
        this.term = term;
    }

    public House(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "House{" +
                "id=" + id +
                ", numberFlat='" + numberFlat + '\'' +
                ", square=" + square +
                ", floor=" + floor +
                ", countOfRooms=" + countOfRooms +
                ", street='" + street + '\'' +
                ", typeOfHouse='" + typeOfHouse + '\'' +
                ", term=" + term +
                '}';
    }
    public static House[] getArrBook() {
        House[] houses = new House[4];
        for (var i = 3 ; i >= 0; i--) {
            if (i % 2 == 0) {
                houses[i] = new House(i, Integer.toString(i), i, i,i,Integer.toString(i),"blocks",i);
                continue;
            }
            houses[i] = new House(i, Integer.toString(i), i, i,i,Integer.toString(i),"wooden",i);
        }
        return houses;
    }

    public  static void getFlatsWithCountRooms(House[] houses, int countOfRooms) {
        for (var item:
             houses) {
            if (item.countOfRooms == countOfRooms)
                System.out.println(item.toString());
        }
    }
    public  static void getFlatsWithCountRoomsAndFloor(House[] houses, int countOfRooms,int fromFloor, int toFloor) {
        for (var item: houses) {
            if (item.countOfRooms == countOfRooms & item.floor > fromFloor & item.floor < toFloor)
                System.out.println(item.toString());
        }
    }
    public  static void getFlatsWithSquare(House[] houses, int square) {
        for (var item: houses) {
            if (item.square > square)
                System.out.println(item.toString());
        }
    }
}
