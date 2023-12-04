package page;

import model.User;
import org.openqa.selenium.By;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.TimeoutException;
import service.TestDataReader;
import service.UserFactory;

public class AuthPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'USER_LOGIN_POPUP\']")
    private WebElement emailInput;

    @FindBy(xpath = "//*[@id=\'USER_PASSWORD_POPUP\']")
    private WebElement passwordInput;

    @FindBy(xpath = "//*[@id=\'avtorization-form\']/div[3]/div[2]/button")
    private WebElement continueButton;

    public AuthPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public AuthPage open() {
        driver.navigate().to("https://nsv.by/");
        log.info("Main page is opened");
        driver.findElement(By.xpath("//*[@id=\'header\']/div/div[1]/div/div/div/div[3]/div[2]/div/a")).click();
        log.info("Auth page is opened");
        return this;
    }

    public User getUser() {
        return UserFactory.getUserInfo();
    }

    public AuthPage fillEmailAndPassword() {
        String email = TestDataReader.getTestData("email");
        String password = TestDataReader.getTestData("password");

        wait.until(ExpectedConditions.elementToBeClickable(emailInput)).sendKeys(email);
        log.info("Email is filled");

        wait.until(ExpectedConditions.elementToBeClickable(passwordInput)).sendKeys(password);
        log.info("Password is filled");

        wait.until(ExpectedConditions.elementToBeClickable(continueButton)).click();
        log.info("Continue button is clicked");

        // Проверка успешной авторизации
        java.time.Duration timeout = java.time.Duration.ofSeconds(3);
        WebDriverWait wait = new WebDriverWait(driver, timeout);
        try {
            wait.withTimeout(timeout)
                    .ignoring(TimeoutException.class)
                    .until(ExpectedConditions.presenceOfElementLocated(By.xpath("//*[@id='ajax_auth']/div/div[1]/div/div/div")));
            log.info("User login failed");
        } catch (TimeoutException e) {
            log.info("User is successfully logged in");
            // Добавим проверку, перенаправлены ли мы на главную страницу после авторизации
            try {
                wait.until(ExpectedConditions.urlToBe("https://nsv.by/"));
                log.info("Redirected to the main page. User is authenticated.");
            } catch (TimeoutException ex) {
                log.error("Redirect to the main page failed. Authentication might have an issue.");
            }
            return this;
        }
        throw new AssertionError("User login failed");
    }
}
