package classes;

import java.util.ArrayList;
import java.util.Date;

public class Book {
    private int id;
    private String name;
    private String author;
    private String publishing;
    private Date date;
    private int countPage;
    private int price;
    private String typePer;

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

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublishing() {
        return publishing;
    }

    public void setPublishing(String publishing) {
        this.publishing = publishing;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getCountPage() {
        return countPage;
    }

    public void setCountPage(int countPage) {
        this.countPage = countPage;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getTypePer() {
        return typePer;
    }

    public void setTypePer(String typePer) {
        this.typePer = typePer;
    }

    public Book(int id, String name, String author, String publishing, Date date, int countPage, int price, String typePer) {
        this.id = id;
        this.name = name;
        this.author = author;
        this.publishing = publishing;
        this.date = date;
        this.countPage = countPage;
        this.price = price;
        this.typePer = typePer;
    }

    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", author='" + author + '\'' +
                ", publishing='" + publishing + '\'' +
                ", date=" + date +
                ", countPage=" + countPage +
                ", price=" + price +
                ", typePer='" + typePer + '\'' +
                '}';
    }

    public Book(int id) {
        this.id = id;
    }
    public static Book[] getArrBook() {
        Book[] books = new Book[4];
        for (var i = 3 ; i >= 0; i--) {
            if (i % 2 == 0) {
                books[i] = new Book(i, Integer.toString(i), Integer.toString(i), Integer.toString(i), new Date(i, 4, 4), i, i, "Paper");
                continue;
            }
            books[i] = new Book(i,Integer.toString(i),Integer.toString(i),Integer.toString(i),new Date(i,4,4),i,i,"Carton");
        }
        return books;
    }

    public static void getBooksAuth(Book[] books,String author) {
        for (var item: books) {
            if (item.author.equals(author)) {
                System.out.println(item.toString());
            }
        }
    }
    public static void getBooksPubl(Book[] books,String publishing) {
        for (var item: books) {
            if (item.publishing.equals(publishing)) {
                System.out.println(item.toString());
            }
        }
    }
    public static void getBooksPubl(Book[] books,int year) {
        for (var item: books) {
            if (item.date.getYear() > year) {
                System.out.println(item.toString());
            }
        }
    }
}
