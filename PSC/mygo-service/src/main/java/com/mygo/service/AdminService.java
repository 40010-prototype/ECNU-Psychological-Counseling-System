package com.mygo.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.mygo.domain.dto.LoginDTO;
import com.mygo.domain.dto.RegisterDTO;
import com.mygo.domain.dto.ResetPasswordDTO;
import com.mygo.domain.entity.Admin;
import com.mygo.domain.vo.LoginVO;

public interface AdminService {

    LoginVO login(LoginDTO loginDTO) throws JsonProcessingException;

    Admin findByUserName(String username);


    void register(RegisterDTO registerDTO);

    String sendEmail(String name);

    void resetPassword(ResetPasswordDTO resetPasswordDTO);
}
