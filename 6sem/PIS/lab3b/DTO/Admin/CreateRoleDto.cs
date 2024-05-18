using System.ComponentModel.DataAnnotations;

namespace lab3b_vd.DTO.Admin;

public class CreateRoleDto
{
    [Length(2, 20, ErrorMessage = "Название роли должно содержать от 2 до 20 символов")]
    public string Name { get; set; }
}
