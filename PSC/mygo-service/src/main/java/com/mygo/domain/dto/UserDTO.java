package com.mygo.domain.dto;

import com.mygo.domain.enumeration.Role;
import lombok.Data;

@Data
public class UserDTO {

    private Long id;

    private String name;

    private String email;

    private String phone;

    private Role role;

}
