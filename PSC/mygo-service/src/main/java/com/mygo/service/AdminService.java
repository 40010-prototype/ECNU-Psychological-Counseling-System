package com.mygo.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.mygo.domain.dto.AdminLoginDTO;
import com.mygo.domain.dto.AdminRegisterDTO;
import com.mygo.domain.dto.ResetPasswordDTO;
import com.mygo.domain.vo.AdminInfoVO;
import com.mygo.domain.vo.AdminLoginVO;

public interface AdminService {

    AdminLoginVO login(AdminLoginDTO adminLoginDTO) throws JsonProcessingException;

    void register(AdminRegisterDTO adminRegisterDTO) throws JsonProcessingException;

    String sendEmail(String name);

    void resetPassword(ResetPasswordDTO resetPasswordDTO);

    AdminInfoVO getAdminInfo();

}
