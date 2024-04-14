using Microsoft.AspNetCore.Mvc;

namespace ASPCMVC06.Controllers
{
    public class TMResearchController : Controller
    {

        public ActionResult M01(string id)
        {
            return Content("GET:M01 - " + id);
        }

        public ActionResult M02(string value)
        {
            return Content("GET:M02 - " + value);
        }


        public ActionResult M03(string value)
        {
            return Content("GET:M03");
        }


        public ActionResult MXX()
        {
            return Content("GET:MXX");
        }
    }
}
