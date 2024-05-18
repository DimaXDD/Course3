using lab3b_vd.Data;
using lab3b_vd.Models;
using Microsoft.AspNetCore.Identity;

namespace lab3b_vd.Middlewares;

public static class DefaultRoleMiddleware
{
    public static IApplicationBuilder UseDefaultRole(this WebApplication app, string role)
    {
        using var scope = app.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        if (db.Roles.Any(el => el.Name == role)) return app;

        db.Roles.Add(new IdentityRole()
        {
            Name = role,
            NormalizedName = role
        });

        db.SaveChanges();

        Console.WriteLine($"[INFO]: Role {role} was added");
        return app;
    }

    public static IApplicationBuilder UseDefaultRole(this WebApplication app, params string[] roles)
    {
        foreach (var role in roles)
        {
            app.UseDefaultRole(role);
        }

        return app;
    }

    public static async Task<IApplicationBuilder> UseDefaultUser(this WebApplication app, string username, string password, string[] roles)
    {
        try
        {
            using var scope = app.Services.CreateScope();
            var userManager = scope.ServiceProvider.GetRequiredService<UserManager<User>>();

            if (userManager.Users.Any(u => u.UserName == username))
                return app;

            var user = new User()
            {
                UserName = username,
                NormalizedUserName = username,
                PasswordHash = password
            };

            var res = await userManager.CreateAsync(user);

            if (!res.Succeeded)
                throw new("User not created");

            Console.WriteLine($"User created with username {username} and password {password}");

            foreach (var r in roles)
            {
                res = await userManager.AddToRoleAsync(user, r);
                if (res.Succeeded) continue;

                throw new("Role not added");
            }

            return app;
        } 
        catch
        {
            return app;
        }
    }
}

