using System.Web;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);
        var app = builder.Build();


        // Task 1
        //http://localhost:5026/TDS?ParmA=1&ParmB=2
        app.MapGet("/TDS", (string ParmA, string ParmB) =>
        {
            var responseText = $"GET-Http-TDS:ParmA = {ParmA},ParmB = {ParmB}";
            return Results.Content(responseText, "text/plain");
        });

        // Task 2
        app.MapPost("/TDS", (string ParmA, string ParmB) =>
        {
            return $"POST-Http-TDS:ParmA = {ParmA},ParmB = {ParmB}";
        });

        // Task 3
        app.MapPut("/TDS", (string ParmA, string ParmB) =>
        {
            return $"PUT-Http-TDS:ParmA = {ParmA},ParmB = {ParmB}";
        });

        // Task 4
        app.MapPost("/task4", async (context) =>
        {
            // Получаем данные из тела запроса
            var form = await context.Request.ReadFormAsync();

            int x = int.Parse(form["X"]);
            int y = int.Parse(form["Y"]);
            int sum = x + y;

            // Отправляем результат обратно клиенту
            await context.Response.WriteAsync(sum.ToString());
        });

        // Task 5
        app.MapGet("/task5", async (context) =>
        {
            context.Response.ContentType = "text/html; charset=utf-8";
            await context.Response.SendFileAsync("html/task5.html");
        });

        app.MapPost("/task5", async (context) =>
        {
            var requestBody = await new StreamReader(context.Request.Body).ReadToEndAsync();
            var parameters = HttpUtility.ParseQueryString(requestBody);

            int x = int.Parse(parameters["X"]);
            int y = int.Parse(parameters["Y"]);
            int sum = x * y;

            await context.Response.WriteAsync(sum.ToString());
        });


        // Task 6
        app.MapGet("/task6", async (context) =>
        {
            context.Response.ContentType = "text/html; charset=utf-8";
            await context.Response.SendFileAsync("html/task6.html");
        });

        app.MapPost("/task6", async (context) =>
        {
            var form = await context.Request.ReadFormAsync();

            int x = int.Parse(form["X"]);
            int y = int.Parse(form["Y"]);
            int sum = x * y;

            await context.Response.WriteAsync(sum.ToString());
        });

        app.Run();
    }
}