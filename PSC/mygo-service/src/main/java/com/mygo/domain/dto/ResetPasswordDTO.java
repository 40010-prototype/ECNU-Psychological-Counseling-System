package com.mygo.domain.dto;


import lombok.Data;

@Data
public class ResetPasswordDTO {
    private String name;
    private String verificationCode;
    private String password;
}
