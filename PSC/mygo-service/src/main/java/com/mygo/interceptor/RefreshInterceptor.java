package com.mygo.interceptor;

import cn.hutool.core.util.StrUtil;
import com.mygo.constant.HeaderConstant;
import com.mygo.constant.RedisConstant;
import com.mygo.utils.AdminContext;
import com.mygo.utils.JwtTool;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Slf4j
@Component
public class RefreshInterceptor implements HandlerInterceptor {

    private final StringRedisTemplate stringRedisTemplate;

    private final JwtTool jwtTool;

    @Autowired
    public RefreshInterceptor(StringRedisTemplate stringRedisTemplate, JwtTool jwtTool) {
        this.stringRedisTemplate = stringRedisTemplate;
        this.jwtTool = jwtTool;
    }

    /**
     * 获取请求头中的token,把信息保存在UserContext中,并刷新在redis中的该记录的有效时间.<br>
     * 该拦截器无论怎样都会放行
     */
    @Override
    public boolean preHandle(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response,
                             @NonNull Object handler) {
        log.info("刷新拦截器正在拦截");
        //1.获取请求头中的token
        String token = request.getHeader(HeaderConstant.Admin_Token);
        //如果token为空,放行
        if (StrUtil.isBlank(token)) {
            return true;
        }
        //2.基于token获取用户
        Long id = jwtTool.parseJWT(token);
        log.info("token解析成功");
        //3.基于id在redis中查找用户
        String userinfo = stringRedisTemplate.opsForValue()
                .get(RedisConstant.JWT_KEY + id);
        log.info(userinfo);
        //如果info为空,放行
        if (StrUtil.isBlank(userinfo)) {
            return true;
        }
        //4.把用户信息保存在UserContext中
        AdminContext.saveUser(id);
        log.info("id成功保存在context");
        //5.刷新redis中该用户的有效时间
        stringRedisTemplate.expire(RedisConstant.JWT_KEY + id, RedisConstant.JWT_EXPIRE, RedisConstant.JWT_EXPIRE_UNIT);
        log.info("redis刷新成功");
        return true;
    }

    /**
     * 移除UserContext中的信息
     */
    @Override
    public void afterCompletion(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull Object handler, Exception ex) {
        AdminContext.removeUser();
    }
}
