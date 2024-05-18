using System.ComponentModel.DataAnnotations;

namespace lab3b_vd.DTO.Admin;

public class ChangePasswordDto
{
    public string Password { get; set; }

    [Length(6, 64, ErrorMessage = "Пароль должен содержать от 6 до 64 символов")]
    public string NewPassword { get; set; }
}
