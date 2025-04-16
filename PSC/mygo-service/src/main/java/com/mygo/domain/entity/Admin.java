package com.mygo.domain.entity;

import com.mygo.domain.enumeration.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Tag(name = "用户实体", description = "用户实体")
public class Admin {

    @Schema(description = "用户ID")
    private Integer adminId;

    @Schema(description = "用户名")
    private String accountName;

    private String realName;

    @Schema(description = "用户密码")
    private String password;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "手机号")
    private String phone;

    @Schema(description = "用户角色")
    private Role role;

    private String info;

    private LocalDateTime createdAt;

}
