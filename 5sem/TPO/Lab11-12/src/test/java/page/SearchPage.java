package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class SearchPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(id = "title-search-input_fixed")
    private WebElement searchInput;

    @FindBy(xpath = "//*[@id=\'subserch\']")
    private WebElement searchBtn;

    public SearchPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public void searchForProduct(String searchTerm) {
        searchInput.sendKeys(searchTerm);
        log.info("What search is input");
        searchBtn.click();
        log.info("Search");
    }
}
