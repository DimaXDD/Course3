package classes;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Student {
    private int id;
    private String name;
    private String surname;
    private String middle_name;
    private Date birthday_date;
    private String address;
    private String number;
    private String faculty;

    private int course;
    private int group;

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

    public void setBirthday_date(Date birthday_date) {
        this.birthday_date = birthday_date;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public void setFaculty(String faculty) {
        this.faculty = faculty;
    }

    public void setCourse(int course) {
        this.course = course;
    }

    public void setGroup(int group) {
        this.group = group;
    }

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

    public Date getBirthday_date() {
        return birthday_date;
    }

    public String getAddress() {
        return address;
    }

    public String getNumber() {
        return number;
    }

    public String getFaculty() {
        return faculty;
    }

    public int getCourse() {
        return course;
    }

    public int getGroup() {
        return group;
    }

    public Student() {
    }

    public Student(int id, String name, String surname, String middle_name, Date birthday_date, String address, String number, String faculty, int course, int group) {
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.middle_name = middle_name;
        this.birthday_date = birthday_date;
        this.address = address;
        this.number = number;
        this.faculty = faculty;
        this.course = course;
        this.group = group;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", surname='" + surname + '\'' +
                ", middle_name='" + middle_name + '\'' +
                ", birthday_date=" + birthday_date +
                ", address='" + address + '\'' +
                ", number='" + number + '\'' +
                ", Faculty='" + faculty + '\'' +
                ", course=" + course +
                ", group=" + group +
                '}';
    }

    public static Student[] getArrStudent() {
        Student[] students = new Student[4];
        for (var i = 0 ; i < 4; i++)
        {
            students[i] = new Student(i,Integer.toString(i),Integer.toString(i),Integer.toString(i),
                    new Date(i,5,5), Integer.toString(i),Integer.toString(i),Integer.toString(i),i,i);
        }
        return students;
    }

    public static void getListFacultyAndCourse(Student[] students) {
        List<Integer> groups = new ArrayList<>();
        List<String> facultys = new ArrayList<>();

        for (var item: students) {
            if (!groups.contains(item.group))
                groups.add(item.group);
            if (!facultys.contains(item.faculty))
                facultys.add(item.faculty);
        }

        for (var faculty: facultys) {
            System.out.println("Faculty is: " + faculty);
            for (var group: groups) {
                for (var item: students) {
                        if (item.faculty.equals(faculty) & item.group == group) {
                            System.out.println("Group is: " + group);
                            System.out.println("\t"+item.toString());
                        }
                }
            }
        }
    }



    public static void getListOutBirthday(Student[] students,int year)
    {
        for (var item:
                students) {
            if (item.birthday_date.getYear() > year)
                System.out.println(item.toString());
        }
    }
    public static void getListGroupStudents(Student[] students, int group)
    {
        System.out.println("group number: " + group);
        for (var item:
                students) {
            if (item.group == group)
                System.out.println(item.toString());
        }
    }
    public static void getListFacultyStudents(Student[] students, String faculty)
    {
        System.out.println("Faculty is: " + faculty);
        for (var item:
                students) {
            if (item.faculty.equals(faculty))
                System.out.println(item.toString());
        }
    }
}
