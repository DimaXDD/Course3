
using lab3b_vd.Data;
using lab3b_vd.Models;
using Microsoft.AspNetCore.Identity;

namespace lab3b_vd.Middlewares;

public static class ExistsUserMiddlewareExtentions
{
    public static IApplicationBuilder UseCheckOnExists(this WebApplication app)
    {
        return app.Use(async (context, next) =>
        {
            var request = context.Request;
            var response = context.Response;

            try
            {
                var userManager = context.RequestServices.GetRequiredService<UserManager<User>>();
                var signInManager = context.RequestServices.GetRequiredService<SignInManager<User>>();

                var iuser = context.User.Identity;

                if (iuser is null || !iuser.IsAuthenticated)
                {
                    next?.Invoke(context);
                    return;
                }

                var user = await userManager.GetUserAsync(context.User);
                if (user is not null)
                {
                    next?.Invoke(context);
                    return;
                }

                await signInManager.SignOutAsync();

                next?.Invoke(context);
            }
            catch (Exception e)
            {
                response.Redirect("/Admin/Error?message=" + e.Message);
                next?.Invoke(context);
                return;
            }
        });
    }
}