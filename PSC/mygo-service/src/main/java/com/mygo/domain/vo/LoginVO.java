package com.mygo.domain.vo;

import com.mygo.domain.enumeration.Role;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class LoginVO {
    private String token;
    private Role role;
}
