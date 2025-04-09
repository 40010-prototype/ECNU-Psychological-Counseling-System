package com.mygo.domain.dto;

import com.mygo.domain.entity.Info;
import com.mygo.domain.enumeration.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Tag(name = "注册DTO", description = "注册DTO")
public class AdminRegisterDTO {

    @Schema(description = "用户名")
    @NotBlank(message = "用户名不能为空")
    String username;


    String name;

    //这里需要单独使用@NotBlank,因为@Email在输入为空时不会报错。
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "请输入正确的邮箱地址")
    @Schema(description = "邮箱")
    String email;

    String phone;


    @Schema(description = "密码")
    String password;



    Role role;

    Info profile;

}
