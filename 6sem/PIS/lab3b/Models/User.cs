using Microsoft.AspNetCore.Identity;

namespace lab3b_vd.Models;

public class User : IdentityUser
{
    public User() : base()
    {

    }

    public User(User user)
    {
        Id = user.Id;
        UserName = user.UserName;
        NormalizedUserName = user.NormalizedUserName;
        PasswordHash = user.PasswordHash;
    }

    public override string ToString() =>
        $"""
        UserName: {UserName}
        NormalizedUserName: {NormalizedUserName}
        PasswordHash: {PasswordHash}
        """;
}
