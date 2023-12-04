package test;

import model.User;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.CartPage;
import page.ProductPage;

import static org.hamcrest.MatcherAssert.assertThat;

public class CartTest extends CommonConditions {

    @Test
    public void testAddingProductToCartAndVerifyingQuantityLimit() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        assertThat("User is authorized", !user.getEmail().isEmpty());

        ProductPage productPage = new ProductPage(driver);
        productPage.open();
        productPage.addToCart();
        CartPage cartPage = productPage.goToCart();
        cartPage.enterQuantity("1000");
        Assert.assertTrue(cartPage.isMaxQuantityLimitReached(),
                "Ограничение максимального количества заказываемых товаров сработало");

    }
}
