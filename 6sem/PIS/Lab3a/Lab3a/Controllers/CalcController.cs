using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Lab3a.Controllers
{
    public class CalcController : Controller
    {
        public IActionResult Index(float x, float y, float z, string press = "+")
        {
            if (!isCorrectParams(x, y, press))
                return View("Calc");

            (ViewBag.x, ViewBag.y, ViewBag.z, ViewBag.press) = (x, y, z, press);
            return View("Calc");
        }

        public IActionResult Test()
        {
            ViewData["Model"] = "ААаа";
            ViewBag.Model = "Hello2";
            return View("Test", "Hello");
        }

        [HttpPost]
        public IActionResult Sum([FromForm] float? x, [FromForm] float? y)
        {
            if (!isCorrectParams(x, y, "+"))
                return View("Calc");

            try
            {
                ViewBag.z = x + y;
            }
            catch
            {
                ViewBag.Error = "Произошла ошибка при выполнении операции";
            }
            return View("Calc");
        }

        [HttpPost]
        public IActionResult Sub([FromForm] float? x, [FromForm] float? y)
        {
            if (!isCorrectParams(x, y, "-"))
                return View("Calc");

            try
            {
                ViewBag.z = x - y;
                return View("Calc");
            }
            catch
            {
                ViewBag.Error = "Произошла ошибка при выполнении операции";
            }

            return View("Calc");
        }

        [HttpPost]
        public IActionResult Mul([FromForm] float? x, [FromForm] float? y)
        {
            if (!isCorrectParams(x, y, "*"))
                return View("Calc");

            try
            {
                ViewBag.z = x * y;
            }
            catch
            {
                ViewBag.Error = "Произошла ошибка при выполнении операции";
            }

            return View("Calc");
        }

        [HttpPost]
        public IActionResult Div([FromForm] float? x, [FromForm] float? y)
        {
            if (!isCorrectParams(x, y, "/"))
                return View("Calc");

            try
            {
                ViewBag.z = x / y;
            }
            catch
            {
                ViewBag.Error = "Произошла ошибка при выполнении операции";
            }

            return View("Calc");
        }

        private bool isCorrectParams(float? x, float? y, string press = "+")
        {
            var err = "";

            ViewBag.x = x ?? 0;
            ViewBag.y = y ?? 0;
            ViewBag.z = 0;
            ViewBag.press = press;

            if (x is null)
                err += "Число x введено неверно\n";

            if (y is null)
                err += "Число y введено неверно\n";

            if (press is not "+" and not "-" and not "*" and not "/")
            {
                ViewBag.press = "+";
                err += "Операция введена неверно\n";
            }

            if (string.IsNullOrWhiteSpace(err)) return true;

            ViewBag.Error = err;
            return false;
        }
    }
}
