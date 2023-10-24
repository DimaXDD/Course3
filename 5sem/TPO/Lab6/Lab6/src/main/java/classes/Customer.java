package classes;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class Customer {
    private int id;
    private String name;
    private String surname;
    private String middle_name;
    private String numberOfCreditCard;
    private String numberOfBankAccount;

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

    public String getNumberOfCreditCard() {
        return numberOfCreditCard;
    }

    public String getNumberOfBankAccount() {
        return numberOfBankAccount;
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

    public void setNumberOfCreditCard(String numberOfCreditCard) {
        this.numberOfCreditCard = numberOfCreditCard;
    }

    public void setNumberOfBankAccount(String numberOfBankAccount) {
        this.numberOfBankAccount = numberOfBankAccount;
    }

    public Customer(int id, String name, String surname, String middle_name, String numberOfCreditCard, String numberOfBankAccount) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.middle_name = middle_name;
        this.numberOfCreditCard = numberOfCreditCard;
        this.numberOfBankAccount = numberOfBankAccount;
    }

    public Customer() {
    }

    @Override
    public String toString() {
        return "Customer{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", surname='" + surname + '\'' +
                ", middle_name='" + middle_name + '\'' +
                ", numberOfCreditCard='" + numberOfCreditCard + '\'' +
                ", numberOfBankAccount='" + numberOfBankAccount + '\'' +
                '}';
    }
    public static Customer[] getArrCustomer() {
        Customer[] customers = new Customer[6];
        for (var i = 3 ; i >= 0; i--)
        {
            customers[i] = new Customer(i,Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i),Integer.toString(i));
        }
        customers[5] = new Customer(5,"Alex","fd","ds","12341412","923454321");
        customers[4] = new Customer(4,"Nikita","as","gd","654342","87456457");
        return customers;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Customer customer = (Customer) o;
        return name.equals(customer.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }

    public static void getCustomersToAlfavit(Customer[]customers) {
        for (var i = 0; i < customers.length; i++)
        {
            for (var j = 0; j < customers.length - 1; j++)
            {
               int n = customers[j+1].name.charAt(0);
                if ( customers[j+1].name.charAt(0) <  customers[j].name.charAt(0))
                {
                    Customer customer = customers[j];
                    customers[j] = customers[j+1];
                    customers[j+1] = customer;
                }
            }
        }
        for (var item: customers) {
            System.out.println(item.toString());
        }
    }

    public static void getListCustomersCurdInterval(Customer[] customers,int from,int to) {
        for (var item: customers) {
            if (Integer.parseInt(item.numberOfCreditCard) <= to & Integer.parseInt(item.numberOfCreditCard) >= from)
                System.out.println(item.toString());
        }
    }
}
