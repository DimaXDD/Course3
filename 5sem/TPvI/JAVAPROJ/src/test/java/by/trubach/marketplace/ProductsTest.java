package by.trubach.marketplace;

import by.trubach.marketplace.services.ProductService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.util.Assert;

@SpringBootTest
@RunWith(SpringRunner.class)
public class ProductsTest {
    @Autowired
    private ProductService productService;

    @Test
    public void shouldBeProvidedProductsList() {
        var list = productService.listProducts(null, "");
        Assert.notNull(list, "List is null");
    }

    @Test
    public void productShouldBeDeleted() {
        var list = productService.listProducts(null, "");
        var product = list.get(0);

        if (product != null) return;

        productService.deleteProduct(product.getUser(), product.getId());
        var list2 = productService.listProducts(null, "");
        Assert.isTrue(list2.size() == list.size() - 1, "Product was not deleted");
    }
}
