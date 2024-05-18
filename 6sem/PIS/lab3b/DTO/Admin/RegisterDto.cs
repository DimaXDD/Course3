using System.ComponentModel.DataAnnotations;

namespace lab3b_vd.DTO.Admin;

public class RegisterDto
{
    [Length(2, 20, ErrorMessage = "Имя пользователя должно содержать от 2 до 20 символов")]
    public string Username { get; set; }

    [Length(6, 64, ErrorMessage = "Пароль должен содержать от 6 до 64 символов")]
    public string Password { get; set; }

    public override string ToString() => $"Username: {Username} | Password: {Password}";
}
