package test;

import model.User;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.CallPage;
import page.SearchPage;

import java.time.Duration;

import static org.hamcrest.MatcherAssert.assertThat;

public class SearchTest extends CommonConditions {

    @Test
    public void testSearch() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        Assert.assertFalse(user.getEmail().isEmpty(), "User is not authorized");

        String expTerm = "ноутбук";
        String searchTerm = "ноутбук";

        SearchPage searchPage = new SearchPage(driver);
        searchPage.searchForProduct(searchTerm);

        By searchResultLocator = By.xpath("//*[@id='bx_3966226736_119840']/tbody/tr[2]/td[2]/div/div[1]/a/span");
        WebElement searchResult = new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.visibilityOfElementLocated(searchResultLocator));

        String productTitle = searchResult.getText();
        Assert.assertTrue(productTitle.toLowerCase().contains(expTerm), "Товар с названием не содержит слово 'ноутбук'");
    }
}
