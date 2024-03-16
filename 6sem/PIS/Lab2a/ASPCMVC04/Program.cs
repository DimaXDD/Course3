namespace ASPCMVC04
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddControllersWithViews();

            var app = builder.Build();

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
            }

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Status}/{action=S200}");

            app.Run();
        }
    }
}