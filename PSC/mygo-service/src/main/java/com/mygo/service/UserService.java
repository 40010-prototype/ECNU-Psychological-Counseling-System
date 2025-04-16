package com.mygo.service;

import com.mygo.domain.dto.UserLoginDTO;
import com.mygo.domain.dto.UserRegisterDTO;
import com.mygo.domain.vo.UserLoginVO;

public interface UserService {

    void register(UserRegisterDTO userRegisterDTO);

    UserLoginVO login(UserLoginDTO userLoginDTO);

}
