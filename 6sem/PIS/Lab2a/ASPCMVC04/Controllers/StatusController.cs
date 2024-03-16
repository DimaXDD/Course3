using Microsoft.AspNetCore.Mvc;

namespace ASPCMVC04.Controllers
{
    public class StatusController : Controller
    {
        private readonly Random random = new Random();
        public IActionResult S200()
        {
            return StatusCode(GenerateRandomStatusCode(200, 299));
        }

        public IActionResult S300()
        {
            return StatusCode(GenerateRandomStatusCode(300, 399));
        }

        public IActionResult S500()
        {
            try
            {
                throw new DivideByZeroException("Simulated DivideByZeroException");
            }
            catch
            {
                return StatusCode(GenerateRandomStatusCode(500, 599));
            }
        }
        private int GenerateRandomStatusCode(int min, int max)
        {
            return random.Next(min, max);
        }
    }
}
