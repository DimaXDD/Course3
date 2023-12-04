package service;

import model.User;

public class UserFactory {
    public static User getUserInfo() {
        return new User(TestDataReader.getTestData("email"),
                TestDataReader.getTestData("password"));
    }
}