package com.mygo.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mygo.constant.RedisConstant;
import com.mygo.domain.dto.UserLoginDTO;
import com.mygo.domain.dto.UserRegisterDTO;
import com.mygo.domain.entity.User;
import com.mygo.domain.vo.UserLoginVO;
import com.mygo.exception.BadRequestException;
import com.mygo.mapper.UserMapper;
import com.mygo.service.UserService;
import com.mygo.utils.IdTool;
import com.mygo.utils.JwtTool;
import com.mygo.utils.PasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    private final UserMapper userMapper;

    private final JwtTool jwtTool;

    private final StringRedisTemplate stringRedisTemplate;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private final IdTool idTool;

    @Autowired
    public UserServiceImpl(UserMapper userMapper, JwtTool jwtTool, StringRedisTemplate stringRedisTemplate,
                           IdTool idTool) {
        this.userMapper = userMapper;
        this.jwtTool = jwtTool;
        this.stringRedisTemplate = stringRedisTemplate;
        this.idTool = idTool;
    }

    @Override
    public void register(UserRegisterDTO userRegisterDTO) {
        String email = userRegisterDTO.getEmail();
        String password = userRegisterDTO.getPassword();
        userMapper.addUser(idTool.getPersonId(), email, PasswordEncoder.encode(password));
    }

    @Override
    public UserLoginVO login(UserLoginDTO userLoginDTO) {
        //1.根据用户名查找是否存在该用户
        User user = userMapper.selectUserByEmail(userLoginDTO.getEmail());
        if (user == null) {
            throw new BadRequestException("用户不存在");
        }
        //2.判断密码是否正确
        if (!PasswordEncoder.matches(user.getPassword(), userLoginDTO.getPassword())) {
            throw new BadRequestException("密码错误");
        }
        //3.生成JWT令牌
        String jwt = jwtTool.createJWT(user.getId());
        //4.将JWT保存在redis中
        //这里不使用hash,因为要分别设置过期时间
        stringRedisTemplate.opsForValue()
                .set(RedisConstant.JWT_KEY + user.getId(), RedisConstant.JWT_VALUE);
        //5.设置过期时间
        stringRedisTemplate.expire(
                RedisConstant.JWT_KEY + user.getId(), RedisConstant.JWT_EXPIRE, RedisConstant.JWT_EXPIRE_UNIT);
        //6.返回token
        return new UserLoginVO(jwt, user.needCompleteInfo());
    }

}
