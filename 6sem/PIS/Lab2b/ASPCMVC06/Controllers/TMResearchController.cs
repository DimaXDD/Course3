using Microsoft.AspNetCore.Mvc;

namespace ASPCMVC06.Controllers
{
    public class TMResearchController : Controller
    {
        [HttpGet("/MResearch/M01/1")]
        [HttpGet("/MResearch/M01")]
        [HttpGet("/MResearch")]
        [HttpGet("/")]
        [HttpGet("V2/MResearch/M01")]
        [HttpGet("V3/MResearch/{param}/M01")]
        public string M01(string param = "")
        {
            return $"GET:M01 {param}";
        }

        [HttpGet("V2")]
        [HttpGet("V2/MResearch")]
        [HttpGet("/MResearch/M02")]
        [HttpGet("V3/MResearch/{param}/M02")]
        public string M02(string param = "")
        {
            return $"GET:M02 {param}";
        }

        [HttpGet("V3")]
        [HttpGet("V3/MResearch/{param}/")]
        [HttpGet("V3/MResearch/{param}/M03")]
        public string M03(string param = "")
        {
            return $"GET:M03 {param}";
        }

        [HttpGet("{*url}", Order = int.MaxValue)]
        public string MXX(string url = "")
        {
            return $"GET:MXX {url}";
        }
    }
}