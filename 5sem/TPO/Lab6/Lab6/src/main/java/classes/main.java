package classes;

import java.sql.Time;
import java.util.Scanner;

public class main {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.println("Выюерите пункт: \n 1 - Student \n 2 - Customer \n 3 - Patient \n" +
                " 4 - Abiturient \n 5 - Book \n 6 - Book \n 7 - Phone \n 8 - Car \n 9 - Product \n 10 - Train \n 0 - Выход");
        int num = in.nextInt();
        while (true)
        {
            switch (num) {
                case 1: {
                    Student[] students = Student.getArrStudent();
                    for (var item:
                            students) {
                        System.out.println(item.toString());
                    }
                    System.out.println("список студентов факультета 1: ");
                    Student.getListFacultyStudents(students,"1");
                    System.out.println();

                    System.out.println("списки студентов для каждого факультета и курса: ");
                    Student.getListFacultyAndCourse(students);
                    System.out.println();

                    System.out.println("список студентов, родившихся после заданного года: ");
                    Student.getListOutBirthday(students,2);
                    System.out.println();

                    System.out.println("список учебной группы: ");
                    Student.getListGroupStudents(students,2);
                    System.out.println();
                    break;
                }
                case 2:
                {
                    classes.Customer[] customers = Customer.getArrCustomer();

                    for (var item:
                            customers) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок покупателей в алфавитном порядке: ");
                    Customer.getCustomersToAlfavit(customers);
                    System.out.println("\n список покупателей, у которых номер кредитной карточки находится в заданном интервале: ");
                    Customer.getListCustomersCurdInterval(customers,3,777777);
                    break;
                }
                case 3:{
                    Patient[] patients = Patient.getArrCustomer();
                    for (var item:
                            patients) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок пациентов, имеющих данный диагноз: ");
                    Patient.getPatOfDiagnosis(patients,"2");
                    System.out.println("\n список пациентов, номер медицинской карты которых находится в заданном интервале: ");
                    Patient.getListPatientCurdInterval(patients,2,777777);
                    break;
                }
                case 4:
                {
                    Abiturient[] abiturients = Abiturient.getArrAbit();
                    for (var item:
                            abiturients) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок абитуриентов, имеющих неудовлетворительные оценки: ");
                    Abiturient.getAbitWithNeyd(abiturients);
                    System.out.println("\n список абитуриентов, у которых сумма баллов выше заданной: ");
                    Abiturient.getPassAbit(abiturients,6);
                    System.out.println("\nвыбрать заданное число n абитуриентов: ");
                    Abiturient.getAllAbit(abiturients,2);
                    break;
                }
                case 5:{
                    Book[] books = Book.getArrBook();
                    for (var item:
                            books) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок книг заданного автора: ");
                    Book.getBooksAuth(books,"0");
                    System.out.println("\nсписок книг, выпущенных заданным издательством: ");
                    Book.getBooksPubl(books,"1");
                    System.out.println("\nсписок книг, выпущенных после заданного года: ");
                    Book.getBooksPubl(books,2);
                    break;
                }
                case 6:
                {
                    House[] houses = House.getArrBook();
                    for (var item:
                            houses) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок квартир, имеющих заданное число комнат: ");
                    House.getFlatsWithCountRooms(houses,2);
                    System.out.println("\nписок квартир, имеющих заданное число комнат и расположенных на этаже, который находится в заданном промежутке: ");
                    House.getFlatsWithCountRoomsAndFloor(houses,1,0 , 2);
                    System.out.println("\nсписок квартир, имеющих площадь, превосходящую заданную: ");
                    House.getFlatsWithSquare(houses,2);
                    break;
                }
                case 7:
                {
                    Phone[] phones = Phone.getArrPhone();
                    for (var item:
                            phones) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\nсписок квартир, имеющих заданное число комнат: ");
                    Phone.getInfoAboutCitySpeak(phones,2);
                    System.out.println("\nписок квартир, имеющих заданное число комнат и расположенных на этаже, который находится в заданном промежутке: ");
                    Phone.getInfoAboutOutCitySpeak(phones);
                    System.out.println("\nсписок квартир, имеющих площадь, превосходящую заданную: ");
                    Phone.getInfo(phones);
                    break;
                }
                case 8:
                {
                    Car[] cars = Car.getArrCar();
                    for (var item:
                            cars) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\n список автомобилей заданной марки: ");
                    Car.getCarsOfMark(cars,"0");
                    System.out.println("\n список автомобилей заданной марки: ");
                    Car.getCarsOfModelAndYear(cars,"2",1);
                    System.out.println("\nсписок автомобилей заданного года выпуска, цена которых больше указанной: ");
                    Car.getCarsOfYearAndPrice(cars,3,2);
                    break;
                }
                case 9:{
                    Product[] products = Product.getArrProduct();
                    for (var item:
                            products) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\n список товаров для заданного наименования: ");
                    Product.getProduct(products,"2");
                    System.out.println("\n список товаров для заданного наименования, цена которых не превосходит заданную: ");
                    Product.getProduct(products,"2",3);
                    System.out.println("\n список товаров, срок хранения которых больше заданного: ");
                    Product.getProduct(products,2);
                    break;
                }
                case 10:
                {
                    Train[] trains = Train.getArrTrain();
                    for (var item:
                            trains) {
                        System.out.println(item.toString());
                    }
                    System.out.println("\n список поездов, следующих до заданного пункта назначения: ");
                    Train.getTrain(trains,"Minsk");
                    System.out.println("\n список поездов, следующих до заданного пункта назначения и отправляющихся после заданного часа: ");
                    Train.getTrain(trains,"London",new Time(2,2,2));
                    System.out.println("\n список поездов, отправляющихся до заданного пункта назначения и имеющих общие места: ");
                    Train.getTrainHasGeneralPlaces(trains,"London");
                    break;
                }
                case 0:{
                    break;
                }

            }
            if (num == 0)
                break;
            num = in.nextInt();

        }
    }

}