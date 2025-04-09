package com.mygo.domain.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
@Tag(name = "登陆DTO", description = "登陆DTO")
public class AdminLoginDTO {

    @NotBlank(message = "用户名为空")
    @Schema(description = "用户名")
    String name;

    @Schema(description = "密码")
    String password;

}
