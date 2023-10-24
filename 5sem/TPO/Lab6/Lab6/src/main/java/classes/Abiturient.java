package classes;

import java.util.ArrayList;
import java.util.Dictionary;

public class Abiturient {
    private int id;
    private String name;
    private String surname;
    private String middle_name;
    private String address;
    private String number;
    private ArrayList<Integer> marks;

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

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getMiddle_name() {
        return middle_name;
    }

    public void setMiddle_name(String middle_name) {
        this.middle_name = middle_name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public ArrayList<Integer> getMarks() {
        return marks;
    }

    public void setMarks(ArrayList<Integer> marks) {
        this.marks = marks;
    }

    public Abiturient(int id, String name, String surname, String middle_name, String address, String number, ArrayList<Integer> marks) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.middle_name = middle_name;
        this.address = address;
        this.number = number;
        this.marks = marks;
    }

    public Abiturient() {
    }

    @Override
    public String toString() {
        return "Abiturient{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", surname='" + surname + '\'' +
                ", middle_name='" + middle_name + '\'' +
                ", address='" + address + '\'' +
                ", number='" + number + '\'' +
                ", marks=" + marks +
                '}';
    }
    public static Abiturient[] getArrAbit() {
        Abiturient[] abiturients = new Abiturient[4];
        for (var i = 3 ; i >= 0; i--)
        {
            ArrayList<Integer> marks = new ArrayList<>();
            marks.add(i +2);
            marks.add(i + 3);
            abiturients[i] = new Abiturient(i, Integer.toString(i), Integer.toString(i),
                    Integer.toString(i), Integer.toString(i), Integer.toString(i),marks);
        }
        return abiturients;
    }

    public static void getAbitWithNeyd(Abiturient[] abiturients) {
        for (var item: abiturients) {
            for (var mark: item.marks) {
                if (mark < 4)
                    System.out.println(item.toString());
            }
        }
    }

    public static void getPassAbit(Abiturient[] abiturients, int ball) {
        for (var item : abiturients) {
            int sum = 0;
            for (var mark: item.marks) {
                sum += mark;
            }
            if (sum > ball)
                System.out.println(item.toString());
        }
    }
    public static void getAllAbit(Abiturient[] abiturients,int count) {
        for(var i = 0; i< abiturients.length; i++){
            for(var j = 0; j< abiturients.length - 1;j++)
            {
                int sum = 0;
                int sum1 = 0;
                for (var mark: abiturients[j].marks) {
                    sum += mark;
                }
                for (var mark: abiturients[j + 1].marks) {
                sum1 += mark;
            }
                if (sum < sum1) {
                    Abiturient ab = abiturients[j];
                    abiturients[j] = abiturients[j +1];
                    abiturients[j +1] = ab;
                }
            }
        }

        System.out.println(count + " абитуриентов с max баллом");

        for (var i = 0; i < count; i++) {
            System.out.println(abiturients[i].toString());
        }

        System.out.println(" полный список абитуриентов, имеющих полупроходную сумму");

        int ball = 0;
        for (var item: abiturients[count].marks) {
            ball += item;
        }

        for (var item: abiturients) {
            int sum = 0;
            for (var i: item.marks) {
                sum += i;
            }
            if (sum >= ball) {
                System.out.println(item.toString());
            }
        }
    }
}