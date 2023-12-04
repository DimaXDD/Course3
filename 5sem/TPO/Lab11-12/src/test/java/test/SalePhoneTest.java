package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.SalePhonePage;

import java.time.Duration;

public class SalePhoneTest extends CommonConditions {
    @Test
    public void testSearchPhoneOnSale() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        Assert.assertFalse(user.getEmail().isEmpty(), "User is not authorized");

        SalePhonePage salePhonePage = new SalePhonePage(driver);
        salePhonePage.searchPhoneOnSale();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id='bx_3966226736_118567']/tbody/tr[2]/td[2]/div/div[1]/a/span")));

        String elementText = element.getText();
        Assert.assertTrue(elementText.toLowerCase().contains("смартфон"), "Элемент не содержит слово 'смартфон'");
    }
}
