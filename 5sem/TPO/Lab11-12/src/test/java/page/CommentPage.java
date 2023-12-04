package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class CommentPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'comp_fef6959c5bb871c37e4d53ca4820d9ee\']/div/div[4]/form/div[1]/div/label[1]")
    private WebElement ratingFive;
    @FindBy(xpath = "//*[@id=\'comp_fef6959c5bb871c37e4d53ca4820d9ee\']/div/div[4]/form/div[2]/textarea")
    private WebElement advantages;

    @FindBy(xpath = "//*[@id=\"comp_fef6959c5bb871c37e4d53ca4820d9ee\"]/div/div[4]/form/div[3]/textarea")
    private WebElement disadvantages;

    @FindBy(xpath = "//*[@id=\'comp_fef6959c5bb871c37e4d53ca4820d9ee\']/div/div[4]/form/div[4]/textarea")
    private WebElement comment;

    @FindBy(xpath = "//*[@id=\'SendReview\']")
    private WebElement send;

    public CommentPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public CommentPage writeCommentWithOver500Characters(String advantagesText,
                                                         String disadvantagesText,
                                                         String commentText) throws InterruptedException {
        Thread.sleep(1000);
        ratingFive.click();
        advantages.sendKeys(advantagesText);
        disadvantages.sendKeys(disadvantagesText);
        comment.sendKeys(commentText);
        log.info("Write rating, advantages and disadvantages");
        wait.until(ExpectedConditions.elementToBeClickable(send)).click();
        log.info("Button send clicked");
        return this;
    }

    public boolean isThankYouMessageDisplayed() {
        try {
            // Ожидание появления элемента с текстом "Спасибо! Ваш отзыв добавлен."
            wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id='comp_fef6959c5bb871c37e4d53ca4820d9ee']/div/div[4]/div[1]")));
            return true;
        } catch (org.openqa.selenium.TimeoutException exception) {
            return false;
        }
    }


}
