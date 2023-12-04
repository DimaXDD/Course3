package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.CallPage;
import page.EFeedbackPage;

import java.time.Duration;

import static org.hamcrest.MatcherAssert.assertThat;

public class CallTest extends CommonConditions {
    @Test
    public void testCallFormWithMaxCharacters() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        assertThat("User is authorized", !user.getEmail().isEmpty());

        CallPage callPage = new CallPage(driver);
        callPage.fillCallForm("dimasdimasdimasdimasd" +
                        "imasdimasdimasdimasdimasdimasd" +
                        "imasdimasdimasdimasdimasdimasdima" +
                        "sdimasdimasdimasdimasdimas",
                "291234343");

        By errorMessageLocator = By.xpath("//*[@id='comp_5c11fd50eca000304bc4c3616bab9880']/div/div[2]/div/h3");
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(errorMessageLocator));
            Assert.fail("Тест провален: Сообщение об ошибке видно");
        } catch (Exception ignored) {
            // Если элемент не виден, то тест успешен
        }




    }
}
