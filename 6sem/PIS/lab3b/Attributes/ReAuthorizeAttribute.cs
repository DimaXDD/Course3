using lab3b_vd.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc.Filters;

namespace lab3b_vd.Attributes;

public class ReAuthorizeAttribute : ActionFilterAttribute
{
    public override async Task OnActionExecutionAsync(ActionExecutingContext context, ActionExecutionDelegate next)
    {
        var httpContext = context.HttpContext;
        var request =  httpContext.Request;
        var response = httpContext.Response;

        request.Query.TryGetValue("_controller", out var _controller);
        request.Query.TryGetValue("_action", out var _action);

        try
        {
            var signInManager = httpContext.RequestServices.GetRequiredService<SignInManager<User>>();
            var userManager = httpContext.RequestServices.GetRequiredService<UserManager<User>>();

            if (signInManager is null)
                throw new("Error with signInManager");

            if (userManager is null)
                throw new("Error with userManager");

            if (!signInManager.IsSignedIn(httpContext.User))
            {
                await next();
                return;
            }

            var user = await userManager.GetUserAsync(httpContext.User);

            if (user is null)
                throw new("User is not exists");

            await signInManager.SignOutAsync();
            await signInManager.SignInAsync(user, isPersistent: true);
            await next();
        } 
        catch (Exception e)
        {
            response.Redirect($"/{_controller.FirstOrDefault() ?? "Admin"}/{_action.FirstOrDefault() ?? "Error"}?message={e.Message}");
        } 
    }
}
