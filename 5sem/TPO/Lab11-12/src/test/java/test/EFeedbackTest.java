package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.CommentPage;
import page.EFeedbackPage;
import page.ProductPage;

import java.time.Duration;

import static org.hamcrest.MatcherAssert.assertThat;

public class EFeedbackTest extends CommonConditions{
    @Test
    public void testForm() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        assertThat("User is authorized", !user.getEmail().isEmpty());

        EFeedbackPage eFeedbackPage = new EFeedbackPage(driver);
        eFeedbackPage.openFeedbackPage();
        eFeedbackPage.fillFeedbackForm("1112121",
                "г. Минск, улица БГТУ, д. 123",
                "+375 (00) 000-00-00",
                "dima@...yandex..ru",
                "Текст сообщения");
        eFeedbackPage.submitFeedbackForm();

        Thread.sleep(5000);

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        By errorMessageLocator = By.xpath("//*[@id='main']/div[14]/div");

        try {
            wait.until(ExpectedConditions.invisibilityOfElementLocated(errorMessageLocator));
        } catch (Exception e) {
            Assert.fail("Сообщение видно на странице");
        }
    }
}
