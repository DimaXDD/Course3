using lab3b_vd.Attributes;
using lab3b_vd.Data;
using lab3b_vd.DTO.Admin;
using lab3b_vd.Exceptions;
using lab3b_vd.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace lab3b_vd.Controllers;

[Route("Admin")]
[CheckOnExist]
[ReAuthorize]
public class AdminController : Controller
{
    private readonly UserManager<User> userManager;
    private readonly SignInManager<User> signInManager;
    private readonly RoleManager<IdentityRole> roleManager;
    private readonly AppDbContext? dbContext;

    public AdminController(UserManager<User> userManager, RoleManager<IdentityRole> roleManager, AppDbContext appDbContext, SignInManager<User> signInManager)
    {
        this.userManager = userManager;
        this.roleManager = roleManager;
        this.signInManager = signInManager;
        this.dbContext = dbContext;
    }

    #region Registration

    [HttpGet("Register")]
    [NonAuthorize]
    [ControllerAction]
    public IActionResult RegisterForm()
    {
        return View("Register");
    }

    [HttpPost("Register")]
    [NonAuthorize]
    public async Task<IActionResult> Register(RegisterDto dto, string _controller = "Home", string _action = "Index")
    {
        try
        {
            ViewBag.Username = dto.Username;
            ViewBag.Password = dto.Password;

            if (!ModelState.IsValid)
                throw new ValidationException(ModelState);

            var user = new User()
            {
                UserName = dto.Username,
                PasswordHash = dto.Password,
                NormalizedUserName = dto.Username
            };

            if (await userManager.FindByNameAsync(user.UserName.ToLower()) != null)
                throw new Exception("Пользователь с таким именем уже существует");

            await userManager.CreateAsync(user);
            await userManager.AddToRoleAsync(user, "User");

            if (user.UserName.Contains("Admin"))
                await userManager.AddToRoleAsync(user, "Administrator");

            return RedirectToAction(_action, _controller);
        }
        catch (ValidationException ve)
        {
            ViewBag.Errors = ve.ValidationErrors;
            return View(ViewBag.View ?? "Register");
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return View(ViewBag.View ?? "Register");
        }
    }

    #endregion

    #region Login

    [HttpGet("SignIn")]
    [NonAuthorize]
    [ControllerAction]
    public IActionResult LoginForm()
    {
        return View("Login");
    }

    [HttpPost("SignIn")]
    [NonAuthorize]
    public async Task<IActionResult> Login(RegisterDto dto, string _controller = "Home", string _action = "Index")
    {
        try
        {
            if (!ModelState.IsValid)
                throw new ValidationException(ModelState);

            var user = await userManager.FindByNameAsync(dto.Username);

            if (user is null || user.PasswordHash != dto.Password)
                throw new UnauthorizedAccessException();

            await this.signInManager.SignInAsync(user, true);
            return RedirectToAction(_action, _controller);
        }
        catch (ValidationException ve)
        {
            ViewBag.Errors = ve.ValidationErrors;
            return View("Login");
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return View("Login");
        }
    }

    #endregion

    #region Sign out

    [HttpGet("SignOut")]
    [Authorize]
    [ControllerAction]
    public IActionResult SignOutForm()
    {
        return View("SignOut");
    }

    [HttpPost("SignOut")]
    [Authorize]
    public async Task<IActionResult> SignOut(string _controller = "Home", string _action = "Index")
    {
        try
        {
            await signInManager.SignOutAsync();
            return RedirectToAction(_action, _controller);
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return View();
        }
    }

    #endregion

    #region Create user

    [HttpGet("CreateUser")]
    [Authorize(Roles = "Administrator")]
    [ControllerAction]
    public IActionResult CreateUserForm()
    {
        return View("CreateUser");
    }

    [HttpPost("CreateUser")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> CreateUser(RegisterDto dto, string _controller = "Home", string _action = "Index")
    {
        ViewBag.View = "CreateUser";
        return await Register(dto, _controller, _action);
    }

    #endregion

    #region Delete user

    [HttpGet("DeleteUser")]
    [Authorize(Roles = "Administrator")]
    [ControllerAction]
    public async Task<IActionResult> DeleteUserForm()
    {
        var nameOfCurrent = this.User.Identity?.Name;
        var userNames = await userManager
            .Users
            .Select(u => u.UserName)
            .Where(n => !n.Equals(nameOfCurrent))
            .ToListAsync();
        return View("DeleteUser", userNames);
    }

    [HttpPost("DeleteUser")]
    [Authorize(Roles = "Administrator,User")]
    public async Task<IActionResult> DeleteUser([FromForm] string username, string _controller = "Home", string _action = "Index")
    {
        try
        {
            var user = await userManager.GetUserAsync(User);
            var _user = user;

            if (user is null)
                throw new("User is null");

            var roles = await userManager.GetRolesAsync(user);
            if (!roles.Contains("Administrator") && username != user.UserName)
                throw new UnauthorizedAccessException("Нельзя!");

            user = await userManager.FindByNameAsync(username);
            if (user is null)
                throw new("User is null");

            if (_user.UserName == username)
                await signInManager.SignOutAsync();

            await userManager.DeleteAsync(user);

            return RedirectToAction(_action, _controller);
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return View();
        }
    }

    #endregion

    #region Change password

    [HttpGet("ChangePassword")]
    [Authorize]
    [ControllerAction]
    public IActionResult ChangePasswordForm()
    {
        return View("ChangePassword");
    }

    [HttpPost("ChangePassword")]
    [Authorize]
    public async Task<IActionResult> ChangePassword(ChangePasswordDto dto, string _controller = "Home", string _action = "Index")
    {
        try
        {
            if (!ModelState.IsValid)
                throw new ValidationException(ModelState);

            if (User.Identity is null)
                throw new UnauthorizedAccessException();

            var user = await userManager.FindByNameAsync(User.Identity.Name);

            if (user is null)
                throw new UnauthorizedAccessException();

            if (!user.PasswordHash.Equals(dto.Password))
                throw new Exception("Старый пароль введен неверно");

            user.PasswordHash = dto.NewPassword;
            await userManager.UpdateAsync(user);

            return RedirectToAction(_action, _controller);
        }
        catch (ValidationException ve)
        {
            ViewBag.Errors = ve.ValidationErrors;
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
        }
        return View();
    }

    #endregion

    #region Assign

    [HttpGet("Assign")]
    [Authorize(Roles = "Administrator")]
    [ControllerAction]
    public async Task<IActionResult> AssignForm()
    {
        try
        {
            var users = (await userManager
                .Users
                //.Where(u => !u.NormalizedUserName.Equals(User.Identity.Name))
                .ToListAsync())
                .Select(u => new RUser(u, this.userManager.GetRolesAsync(u).Result))
                .ToList();

            var roles = await roleManager
                .Roles
                .Where(r => r.Name != "User")
                .ToListAsync();

            return View("Assign", new AssignRoleModel(users, roles));
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return View("Assign", new AssignRoleModel());
        }
    }

    [HttpPost("Assign")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> AssignRole(AssignRoleDto dto)
    {
        try
        {
            var user = await userManager.FindByIdAsync(dto.UserId);
            if (user is null)
                throw new("Invalid user");

            var userRoles = await userManager.GetRolesAsync(user);

            var role = await roleManager.FindByIdAsync(dto.RoleId);

            if (role is null || role.Name == "User")
                throw new Exception();

            IdentityResult res = await (!userRoles.Contains(role.Name) ?
                userManager.AddToRoleAsync(user, role.NormalizedName) :
                userManager.RemoveFromRoleAsync(user, role.NormalizedName));

            if (!res.Succeeded)
                throw new Exception();

            return Ok();
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return BadRequest();
        }
    }

    #endregion

    #region Create role

    [HttpGet("CreateRole")]
    [Authorize(Roles = "Administrator")]
    [ControllerAction]
    public IActionResult CreateRoleForm()
    {
        return View("CreateRole");
    }

    [HttpPost("CreateRole")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> CreateRole(CreateRoleDto dto, string _controller = "Home", string _action = "Index")
    {
        try
        {
            if (!ModelState.IsValid)
                throw new ValidationException(ModelState);

            var role = await roleManager.Roles.FirstOrDefaultAsync(r => r.Name == dto.Name);

            if (role is not null)
                throw new Exception("Роль с таким названием уже существует");

            role = new IdentityRole()
            {
                Name = dto.Name,
                NormalizedName = dto.Name
            };

            await roleManager.CreateAsync(role);
            return RedirectToAction(_action, _controller);
        }
        catch (ValidationException ve)
        {
            ViewBag.Errors = ve.ValidationErrors;
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<String> { e.Message };
        }

        return View();
    }

    #endregion

    #region Delete role

    [HttpGet("DeleteRole")]
    [Authorize(Roles = "Administrator")]
    [ControllerAction]
    public async Task<IActionResult> DeleteRoleForm()
    {
        try
        {
            var roles = await roleManager
                .Roles
                .Select(r => r.Name)
                .Where(r => /*r != "Administrator" &&*/ r != "User")
                .ToListAsync();
            return View("DeleteRole", roles);
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
        }

        return View("DeleteRole", new string[0]);
    }

    [HttpPost("DeleteRole")]
    [Authorize(Roles = "Administrator")]
    public async Task<IActionResult> DeleteRole(DeleteRoleDto dto, string _controller = "Home", string _action = "Index")
    {
        try
        {
            var role = await roleManager.FindByNameAsync(dto.RoleName);

            if (role is null)
                throw new Exception("Роль не найдена");

            var users = await userManager.Users.ToListAsync();
            foreach(var u in users)
            {
                await userManager.RemoveFromRoleAsync(u, role?.NormalizedName ?? "");
            }

            await roleManager.DeleteAsync(role);
            return RedirectToAction(_action, _controller);
        }
        catch (Exception e)
        {
            ViewBag.Errors = new List<string> { e.Message };
            return await this.DeleteRoleForm();
        }
    }

    #endregion
        
    #region Error

    [HttpGet("Error")]
    [ControllerAction]
    [Route("{*path}")]
    public IActionResult Error(string message)
    {
        ViewBag.Message = message ?? "Not Found";
        return View();
    }

    [HttpGet("AccessError")]
    [ControllerAction]
    public IActionResult Error()
    {
        return Redirect("/Admin/Error?message=Access denied");
    }
    #endregion

    #region Private Scripts 

    private async Task<List<string>> GetRoles(string username)
    {
        var user = await userManager.FindByNameAsync(username);
        return (await userManager.GetRolesAsync(user)).ToList();
    }

    #endregion
}
