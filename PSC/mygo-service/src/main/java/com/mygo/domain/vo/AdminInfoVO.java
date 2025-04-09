package com.mygo.domain.vo;

import com.mygo.domain.enumeration.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Getter
@Builder
public class AdminInfoVO {
    @Schema(description = "用户ID")
    private Integer adminId;

    @Schema(description = "用户名")
    private String name;

    private String username;

    @Schema(description = "用户密码")
    private String password;

    @Schema(description = "邮箱")
    private String email;

    @Schema(description = "用户角色")
    private Role role;

    private LocalDateTime createdAt;
}
