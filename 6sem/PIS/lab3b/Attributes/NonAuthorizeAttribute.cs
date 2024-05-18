using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace lab3b_vd.Attributes;

public class NonAuthorizeAttribute : ActionFilterAttribute
{
    public override void OnActionExecuting(ActionExecutingContext context)
    {
        if (!context.HttpContext.User.Identity.IsAuthenticated)
        {
            base.OnActionExecuting(context);
            return;
        }

        var query = context.HttpContext.Request.Query;
        query.TryGetValue("_action", out var action);
        query.TryGetValue("_controller", out var controller);

        context.Result = new RedirectResult($"/{controller.FirstOrDefault() ?? "Admin"}/{action.FirstOrDefault() ?? "Error"}?message=Only for non authorize users");
        return;
    }
}
