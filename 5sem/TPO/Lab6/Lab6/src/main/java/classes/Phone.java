package classes;

import java.util.ArrayList;

public class Phone {
    private int id;
    private String name;
    private String surname;
    private String middle_name;
    private String numberOfCreditCard;
    private String debet;
    private int credit;
    private int timeCitySpeak;
    private int timeOutCitySpeak;

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

    public String getNumberOfCreditCard() {
        return numberOfCreditCard;
    }

    public void setNumberOfCreditCard(String numberOfCreditCard) {
        this.numberOfCreditCard = numberOfCreditCard;
    }

    public String getDebet() {
        return debet;
    }

    public void setDebet(String debet) {
        this.debet = debet;
    }

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public int getTimeCitySpeak() {
        return timeCitySpeak;
    }

    public void setTimeCitySpeak(int timeCitySpeak) {
        this.timeCitySpeak = timeCitySpeak;
    }

    public int getTimeOutCitySpeak() {
        return timeOutCitySpeak;
    }

    public void setTimeOutCitySpeak(int timeOutCitySpeak) {
        this.timeOutCitySpeak = timeOutCitySpeak;
    }

    public Phone(int id, String name, String surname, String middle_name, String numberOfCreditCard, String debet, int credit, int timeCitySpeak, int timeOutCitySpeak) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.middle_name = middle_name;
        this.numberOfCreditCard = numberOfCreditCard;
        this.debet = debet;
        this.credit = credit;
        this.timeCitySpeak = timeCitySpeak;
        this.timeOutCitySpeak = timeOutCitySpeak;
    }

    public Phone(int id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Phone{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", surname='" + surname + '\'' +
                ", middle_name='" + middle_name + '\'' +
                ", numberOfCreditCard='" + numberOfCreditCard + '\'' +
                ", debet='" + debet + '\'' +
                ", credit=" + credit +
                ", timeCitySpeak=" + timeCitySpeak +
                ", timeOutCitySpeak=" + timeOutCitySpeak +
                '}';
    }

    public static Phone[] getArrPhone() {
        Phone[] phones = new Phone[4];
        int m = 0;
        for (var i = 3 ; i >= 0; i--)
        {
            phones[m] = new Phone(i, Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),i,i,i);
            m++;
        }
        return phones;
    }
    public static void getInfoAboutCitySpeak(Phone[] phones, int timeCitySpeak) {
        for (var item: phones) {
            if (item.timeCitySpeak > timeCitySpeak)
                System.out.println(item.toString());
        }
    }
    public static void getInfoAboutOutCitySpeak(Phone[] phones) {
        for (var item: phones) {
            if (item.timeOutCitySpeak > 0)
                System.out.println(item.toString());
        }
    }
    public static void getInfo(Phone[] phones) {
        for (var i = 0; i < phones.length; i++) {
            for (var j = 0; j < phones.length - 1; j++) {
                int n = phones[j+1].name.charAt(0);
                if ( phones[j+1].name.charAt(0) <  phones[j].name.charAt(0))
                {
                    Phone customer = phones[j];
                    phones[j] = phones[j+1];
                    phones[j+1] = customer;
                }
            }
        }
        for (var item: phones) {
            System.out.println(item.toString());
        }
    }
}
