package test;

import model.User;
import org.testng.Assert;
import org.testng.annotations.Test;
import page.AuthPage;
import page.CartPage;
import page.CommentPage;
import page.ProductPage;

import static org.hamcrest.MatcherAssert.assertThat;

public class CommentTest extends CommonConditions {
    @Test
    public void testWrittingCommentOver500Symbols() throws InterruptedException {
        User user = new AuthPage(driver)
                .open()
                .fillEmailAndPassword()
                .getUser();

        assertThat("User is authorized", !user.getEmail().isEmpty());

        ProductPage productPage = new ProductPage(driver);
        productPage.open();

        CommentPage commentPage = new CommentPage(driver);
        commentPage.writeCommentWithOver500Characters("Все хорошо, мне нравится",
                "Нет",
                "qweeqweqadsadaqweeqweqadsadaqwee" +
                        "qweqadsadaqweeqweqadsadaqweeqweqadsada" +
                        "qweeqweqadsadaqweeqweqadsadaqweeqweqadsa" +
                        "daqweeqweqadsadaqweeqweqadsadaqweeqweqadsa" +
                        "daqweeqweqadsadaqweeqweqadsadaqweeqweqadsad" +
                        "aqweeqweqadsadaqweeqweqadsadaqweeqweqadsadaq" +
                        "weeqweqadsadaqweeqweqadsadaqweeqweqadsadaqwe" +
                        "eqweqadsadaqweeqweqadsadaqweeqweqadsadaqweeq" +
                        "weqadsadaqweeqweqadsadaqweeqweqadsadaqweeqwe" +
                        "qadsadaqweeqweqadsadaqweeqweqadsadaqweeqweqad" +
                        "sadaqweeqweqadsadaqweeqweqadsadaqweeqweqadsada");

        // Проверяем наличие сообщения "Спасибо! Ваш отзыв добавлен."
        boolean thankYouMessageDisplayed = commentPage.isThankYouMessageDisplayed();
        Assert.assertTrue(!thankYouMessageDisplayed, "Сообщение было показано, что не должно быть");



    }
}
