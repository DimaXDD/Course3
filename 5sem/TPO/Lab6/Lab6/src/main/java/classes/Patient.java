package classes;

import java.util.Date;

public class Patient {
    private int id;
    private String name;
    private String surname;
    private String middle_name;
    private String numberMedCard;
    private String address;
    private String number;
    private String diagnosis;

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getSurname() {
        return surname;
    }

    public String getMiddle_name() {
        return middle_name;
    }

    public String getNumberMedCard() {
        return numberMedCard;
    }

    public String getAddress() {
        return address;
    }

    public String getNumber() {
        return number;
    }

    public String getDiagnosis() {
        return diagnosis;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public void setMiddle_name(String middle_name) {
        this.middle_name = middle_name;
    }

    public void setNumberMedCard(String numberMedCard) {
        this.numberMedCard = numberMedCard;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }

    public Patient(int id, String name, String surname, String middle_name, String numberMedCard, String address, String number, String diagnosis) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.middle_name = middle_name;
        this.numberMedCard = numberMedCard;
        this.address = address;
        this.number = number;
        this.diagnosis = diagnosis;
    }

    public Patient() {
    }

    @Override
    public String toString() {
        return "Patient{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", surname='" + surname + '\'' +
                ", middle_name='" + middle_name + '\'' +
                ", numberMedCard='" + numberMedCard + '\'' +
                ", address='" + address + '\'' +
                ", number='" + number + '\'' +
                ", diagnosis='" + diagnosis + '\'' +
                '}';
    }
    public static Patient[] getArrCustomer() {
        Patient[] patients = new Patient[6];
        for (var i = 3 ; i >= 0; i--) {
            patients[i] = new Patient(i,Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i));
        }
        patients[5] = new Patient(5,"Alex","fd","ds","12341","angarskaya","375121234312","ORI");
        patients[4] = new Patient(4,"Nikita","zxc","fasd","12341412","street Yoga","3752312321","2");
        return patients;
    }

    public static void getPatOfDiagnosis(Patient[] patients, String diagnosis) {
        for (var item: patients) {
            if (item.diagnosis.equals(diagnosis))
                System.out.println(item.toString());
        }
    }
    public static void getListPatientCurdInterval(Patient[] patients,int from,int to) {
        for (var item: patients) {
            if (Integer.parseInt(item.numberMedCard) <= to & Integer.parseInt(item.numberMedCard) >= from)
                System.out.println(item.toString());
        }
    }
}
