package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.FiltrationPage;
import page.SearchPage;

import java.time.Duration;

public class FiltrationTest extends CommonConditions {
    @Test
    public void testSearchProductWithSomeStats() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        Assert.assertFalse(user.getEmail().isEmpty(), "User is not authorized");

        FiltrationPage filtrationPage = new FiltrationPage(driver);
        filtrationPage.searchProductWithSomeStats();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id='bx_3966226736_114835']/tbody/tr[2]/td[2]/div/div[1]/a/span")));

        String elementText = element.getText();
        Assert.assertTrue(elementText.toLowerCase().contains("зеленый"), "Элемент не содержит слово 'зеленый'");



    }
}
