package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.*;

import java.time.Duration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class BuyWithInCorrectDataTest extends CommonConditions {
    @Test
    public void testInCorrectDataTest() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        Assert.assertFalse(user.getEmail().isEmpty(), "User is not authorized");

        ProductPage productPage = new ProductPage(driver);
        productPage.open();
        productPage.addToCart();
        productPage.goToCart();

        BuyWithInCorrectDataPage buyWithInCorrectDataPage = new BuyWithInCorrectDataPage(driver);
        buyWithInCorrectDataPage.buyingWithInCorrectData("Иванов Иван",
                "291233443",
                "testmail@yandex.ru",
                "г. Минск, ул. Дмитрий Трубача, д. 228");

        // Ожидание URL с ORDER_ID
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        wait.until(ExpectedConditions.urlMatches("https://nsv.by/basket/\\?ORDER_ID=\\d+"));

        // Проверка, что URL содержит ORDER_ID
        String currentUrl = driver.getCurrentUrl();
        Pattern pattern = Pattern.compile("ORDER_ID=(\\d+)");
        Matcher matcher = pattern.matcher(currentUrl);
        Assert.assertTrue(!matcher.find(), "ORDER_ID is found in the URL");

    }


}
