package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class CartPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    public CartPage(WebDriver driver) {
        super(driver);
    }

    public CartPage openCart() {
        WebElement cartIcon = driver.findElement(By.xpath("//a[contains(@class, 'cart-icon')]")); // Пример локатора иконки корзины
        wait.until(ExpectedConditions.elementToBeClickable(cartIcon)).click();
        return this;
    }

    public void enterQuantity(String quantity) {
        int quantityValue = Integer.parseInt(quantity);
        WebElement quantityField = driver.findElement(By.xpath("//*[@id=\'content\']/div[3]/div/div/div/div/div/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/input"));
        quantityField.sendKeys(String.valueOf(quantityValue)); // Преобразовываем обратно в строку для ввода
        quantityField.sendKeys(Keys.ENTER); // Отправка клавиши Enter
        log.info("Quantity is send");
    }


    public boolean isMaxQuantityLimitReached() throws InterruptedException {
        Thread.sleep(2000);
        WebElement quantityField = driver.findElement(By.xpath("//*[@id=\'content\']/div[3]/div/div/div/div/div/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/input"));
        String enteredValue = quantityField.getAttribute("value");
        int maxQuantity = 99; // Максимальное количество товаров
        int enteredQuantity = Integer.parseInt(enteredValue);
        return enteredQuantity >= maxQuantity; // Проверяем, что введенное количество больше или равно максимальному
    }

    public String getCartUrl() {
        return driver.getCurrentUrl();
    }
}
