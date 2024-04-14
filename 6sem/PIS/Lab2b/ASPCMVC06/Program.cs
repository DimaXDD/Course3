using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing.Constraints;
using System;

namespace ASPCMVC06
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddRazorPages();

            var app = builder.Build();
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
            }
            app.UseRouting();
            app.MapRazorPages();

                                                                                                                        #pragma warning disable ASP0014
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                   name: "V2",
                   pattern: "V2/{MResearch?}/{action}",
                   defaults: new { controller = "TMResearch", action = "M02" },
                   constraints: new { action = "M01|M02", MResearch = "MResearch" }
               );
                endpoints.MapControllerRoute(
                    name: "V3",
                    pattern: "V3/{MResearch?}/{value}/{action}",
                    defaults: new { controller = "TMResearch", action = "M03", value = "" },
                    constraints: new { action = "M01|M02|M03", MResearch = "MResearch" }
                );
                endpoints.MapControllerRoute(
                    name: "M01",
                    pattern: "/{MResearch?}/{action}/{id?}",
                    defaults: new { controller = "TMResearch", action = "M01" }/*,
                    constraints: new { MResearch = "MResearch", action = "M01" }*/
                    );
                /*                endpoints.MapControllerRoute(
                                    name: "M02",
                                    pattern: "/{MResearch}/{action}",
                                    defaults: new { controller = "TMResearch", action = "M02" },
                                    constraints: new { MResearch = "MResearch", action = "M02", }
                                    );*/


                endpoints.MapControllerRoute(
                     name: "MXX",
                     pattern: "{*url}",
                     defaults: new { controller = "TMResearch", action = "MXX" 
                     });
            });
                                                                                                                                        #pragma warning restore ASP0014 

            app.Run();
        }

    }
}
