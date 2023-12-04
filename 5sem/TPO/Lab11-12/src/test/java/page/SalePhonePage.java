package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class SalePhonePage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'header\']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[4]/div/a")
    private WebElement superCost;

    @FindBy(xpath = "//*[@id=\'bx_1847241719_1857\']/div[2]/a")
    private WebElement phoneOnSale;

    public SalePhonePage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public void searchPhoneOnSale() {
        superCost.click();
        log.info("SuperCost is clicked");
        phoneOnSale.click();
        log.info("Phone category is clicked");
    }
}
