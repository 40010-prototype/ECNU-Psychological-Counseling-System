package com.mygo.service.impl;

import cn.hutool.core.util.RandomUtil;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mygo.constant.ErrorMessage;
import com.mygo.constant.RedisConstant;
import com.mygo.domain.dto.AdminLoginDTO;
import com.mygo.domain.dto.AdminRegisterDTO;
import com.mygo.domain.dto.ResetPasswordDTO;
import com.mygo.domain.entity.Admin;
import com.mygo.domain.vo.AdminInfoVO;
import com.mygo.domain.vo.AdminLoginVO;
import com.mygo.exception.BadRequestException;
import com.mygo.mapper.AdminMapper;
import com.mygo.service.AdminService;
import com.mygo.utils.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Slf4j
@Service
public class AdminServiceImpl implements AdminService {

    private final ObjectMapper objectMapper = new ObjectMapper();

    private final AdminMapper adminMapper;

    private final JwtTool jwtTool;

    private final StringRedisTemplate stringRedisTemplate;

    private final MailUtils mailUtils;

    private final IdTool idTool;

    @Autowired
    public AdminServiceImpl(AdminMapper adminMapper, JwtTool jwtTool, StringRedisTemplate stringRedisTemplate,
                            MailUtils mailUtils, IdTool idTool) {
        this.adminMapper = adminMapper;
        this.jwtTool = jwtTool;
        this.stringRedisTemplate = stringRedisTemplate;
        this.mailUtils = mailUtils;
        this.idTool = idTool;
    }

    /**
     * 登陆
     *
     * @param adminLoginDTO 登陆DTO，包括如下字段：<br>
     *                      用户名、密码
     * @return jwt令牌、用户类型
     */
    @Override
    public AdminLoginVO login(AdminLoginDTO adminLoginDTO) throws JsonProcessingException {
        log.info("登录服务");
        //1.根据用户名查找是否存在该用户
        Admin admin = adminMapper.getAdminByName(adminLoginDTO.getName());
        if (admin == null) {
            throw new BadRequestException(ErrorMessage.USER_NOT_FOUND);
        }
        //2.判断密码是否正确
        if (!PasswordEncoder.matches(admin.getPassword(), adminLoginDTO.getPassword())) {
            throw new BadRequestException(ErrorMessage.PASSWORD_ERROR);
        }
        log.info(String.valueOf(admin.toString()));
        //3.生成JWT令牌
        String jwt = jwtTool.createJWT(admin.getAdminId());
        //4.将JWT保存在redis中
        stringRedisTemplate.opsForValue()
                .set(RedisConstant.JWT_KEY + admin.getAdminId(), RedisConstant.JWT_VALUE);
        //5.设置过期时间
        stringRedisTemplate.expire(
                RedisConstant.JWT_KEY + admin.getAdminId(), RedisConstant.JWT_EXPIRE, RedisConstant.JWT_EXPIRE_UNIT);
        log.info("redis设置成功");
        //6.返回token
        return new AdminLoginVO(jwt, admin.getRole());
    }

    /**
     * 注册用户
     * @param adminRegisterDTO 注册DTO，包括如下字段：<br>
     *                         用户名、密码、邮箱、身份
     */
    @Override
    public void register(AdminRegisterDTO adminRegisterDTO) throws JsonProcessingException {
        adminMapper.addAdmin(idTool.getPersonId(), adminRegisterDTO.getUsername(), adminRegisterDTO.getName(),
                adminRegisterDTO.getEmail(), PasswordEncoder.encode(adminRegisterDTO.getPassword()),
                adminRegisterDTO.getRole(), objectMapper.writeValueAsString(adminRegisterDTO.getProfile()));
    }

    /**
     * 发送邮箱验证码
     * @param name 用户名
     * @return 用户邮箱
     */
    @Override
    public String sendEmail(String name) {
        //1.通过用户名查询邮件
        String email = adminMapper.getEmailByAccountName(name);
        if (email == null) {
            throw new BadRequestException(ErrorMessage.USER_NOT_FOUND);
        }
        //2.生成6为随机数字
        String num = RandomUtil.randomNumbers(6);
        //3.发送邮件
        String subject = "找回密码验证码";
        String text = "你的验证码为：" + num;
        mailUtils.sendMail(email, subject, text);
        //4.把数据存在redis中
        stringRedisTemplate.opsForValue()
                .set(RedisConstant.ADMIN_VERIFY_KEY +
                        name, num, RedisConstant.VERIFY_EXPIRE, RedisConstant.VERIFY_EXPIRE_UNIT);
        //5.返回邮箱（用于前端展示）
        return email;
    }

    /**
     * 检查用户发送的邮箱验证码。如果正确，重置密码。
     * @param resetPasswordDTO 重置密码DTO，包括如下字段：<br>
     *                         用户名，验证码，密码
     */
    @Override
    public void resetPassword(ResetPasswordDTO resetPasswordDTO) {
        String name = resetPasswordDTO.getName();
        //1.从redis读取验证码
        String verificationCode = stringRedisTemplate.opsForValue()
                .get(RedisConstant.ADMIN_VERIFY_KEY + name);
        //2.判断验证码是否正确
        if (!Objects.equals(verificationCode, resetPasswordDTO.getVerifyCode())) {
            throw new BadRequestException(ErrorMessage.VERIFY_CODE_ERROR);
        }
        //3.修改密码
        adminMapper.updatePassword(resetPasswordDTO.getName(), PasswordEncoder.encode(resetPasswordDTO.getPassword()));
    }

    @Override
    public AdminInfoVO getAdminInfo() {
        Integer id = Context.getId();
        Admin admin = adminMapper.getAdminById(id);
        return AdminInfoVO.builder()
                .adminId(admin.getAdminId())
                .name(admin.getRealName())
                .username(admin.getAccountName())
                .email(admin.getEmail())
                .role(admin.getRole())
                .createdAt(admin.getCreatedAt())
                .build();
    }

}
