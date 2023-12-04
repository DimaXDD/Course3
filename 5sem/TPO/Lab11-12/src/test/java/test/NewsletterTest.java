package test;

import model.User;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.NewsletterPage;

import static org.hamcrest.MatcherAssert.assertThat;

public class NewsletterTest extends CommonConditions {
    @Test
    public void testNewsletter() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        assertThat("User is authorized", !user.getEmail().isEmpty());

        NewsletterPage newsletterPage = new NewsletterPage(driver);
        newsletterPage.testNewsletterShop("pochta@.yandex..ru");

        String currentUrl = driver.getCurrentUrl();
        Thread.sleep(2000);
        Assert.assertEquals(currentUrl, "https://cp.unisender.com/ru/error_subscribe", "Redirected to unexpected URL");
    }
}
