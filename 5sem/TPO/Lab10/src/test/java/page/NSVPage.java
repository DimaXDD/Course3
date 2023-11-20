package page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class NSVPage {
    private WebDriver driver;

    public NSVPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);

    }

    @FindBy(id = "title-search-input_fixed")
    private WebElement searchInput; // Поле для поиска

    @FindBy(xpath = "//*[@id='subserch']")
    private WebElement searchButton; // Лупа (ну тип поиск)

    @FindBy(xpath = "//*[@id='ClickCallBack']")
    private WebElement callButton; // Кнопка "Заказать звонок"

    @FindBy(xpath = "//*[@id='comp_5c11fd50eca000304bc4c3616bab9880']/div/form/div[1]/div[1]/input")
    private WebElement nameField; // Поле для ввода имени

    @FindBy(xpath = "//*[@id='comp_5c11fd50eca000304bc4c3616bab9880']/div/form/div[1]/div[2]/input")
    private WebElement phoneField; // Поле для ввода номера

    @FindBy(xpath = "//*[@id='FormCall']")
    private WebElement phoneButton; // Кнопка заказа звонка

    @FindBy(xpath = "//*[@id='header']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/a")
    private WebElement catalogButton; // Кнопка "Каталог"

    @FindBy(xpath = "//*[@id='header']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/ul/li[2]/ul/li[1]/a/span")
    private WebElement targetElement; // То, что конкретно нужно (у меня айфон)

    @FindBy(xpath = "//*[@id='content']/div[4]/div[3]/div/noindex/div/form/div[15]/div[1]")
    private WebElement colorSelect; // Выбор цвета

    @FindBy(xpath = "//*[@id=\'content\']/div[4]/div[3]/div/noindex/div/form/div[15]/div[2]/div[1]/label[4]/span")
    private WebElement greenColor; // Какой именно цвет

    @FindBy(xpath = "//*[@id=\'modef\']/a")
    private WebElement submitButton; // Кнопка "Показать"

    public void searchPhone(String phoneName) throws InterruptedException {
        searchInput.sendKeys(phoneName);
        searchButton.click();
        Thread.sleep(5000);
    }

    public void callForm(String name, String phone) throws InterruptedException {
        callButton.click();
        Thread.sleep(3000);
        nameField.sendKeys(name);
        phoneField.sendKeys(phone);
        phoneButton.click();
        Thread.sleep(5000);
    }

    public void findIPhoneWithSomeStats() throws InterruptedException {
        Actions actions = new Actions(driver);
        actions.moveToElement(catalogButton).perform();
        targetElement.click();
        colorSelect.click();
        greenColor.click();
        Thread.sleep(5000);
        submitButton.click();
        Thread.sleep(5000);
    }
}
