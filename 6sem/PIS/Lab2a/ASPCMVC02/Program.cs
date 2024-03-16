namespace ASPCMVC02
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            var app = builder.Build();

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
            }


            app.MapGet("/", async context =>
            {
                try
                {
                    var redirectUrl = "http://localhost:5121/index.html";

                    context.Response.Redirect(redirectUrl);
                }
                catch (Exception ex)
                {
                    context.Response.StatusCode = 500;
                    await context.Response.WriteAsync($"An error occurred: {ex.Message}");
                }
            });

            app.Run();
        }
    }
}
