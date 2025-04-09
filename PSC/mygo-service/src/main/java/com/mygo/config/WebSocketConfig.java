package com.mygo.config;

import cn.hutool.core.util.StrUtil;
import com.mygo.constant.RedisConstant;
import com.mygo.exception.UnauthorizedException;
import com.mygo.utils.Context;
import com.mygo.utils.JwtTool;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@Slf4j
@Configuration
public class WebSocketConfig extends ServerEndpointConfig.Configurator {

    private static JwtTool jwtTool;

    private static StringRedisTemplate stringRedisTemplate;

    /**WebSocketConfig必须要有一个无参的构造函数。所以我们用这种方法依赖注入。
     * 另外，由于WebSocket是多例的，其注入的bean要加static属性。
     */
    @Autowired
    public void setWebSocketConfig(JwtTool jwtTool, StringRedisTemplate stringRedisTemplate) {
        WebSocketConfig.jwtTool = jwtTool;
        WebSocketConfig.stringRedisTemplate = stringRedisTemplate;
    }

    //默认的serverEndpoint配置
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }

    /**
     * 建立握手时，连接前的操作：检查发送方携带的JWT
     */
    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        /*当Sec-WebSocket-Protocol请求头不为空时,需要返回给前端相同的响应。否则无法建立连接。
          所以如果不运行到最后就return，意思就是拒绝这次请求。
          另外，这里的异常不会被全局异常捕获类捕获，所以要放到try-catch中
         */
        try {
            //1.获取请求头中的token
            String token = request.getHeaders()
                    .get("Sec-WebSocket-Protocol")
                    .get(0);
            log.info("Sec-WebSocket-Protocol: " + token);
            //如果token为空，拒绝
            if (StrUtil.isBlank(token)) {
                return;
            }
            //2.基于token获取用户
            Integer id = jwtTool.parseJWT(token);
            //3.基于id在redis中查找用户
            String value = stringRedisTemplate.opsForValue()
                    .get(RedisConstant.JWT_KEY + id);
            //如果值为空，拒绝
            if (value == null) return;
            //4.把用户信息保存在Context中
            Context.saveId(id);
            //5.刷新redis中该用户的有效时间
            stringRedisTemplate.expire(
                    RedisConstant.JWT_KEY + id, RedisConstant.JWT_EXPIRE, RedisConstant.JWT_EXPIRE_UNIT);
            //6.返回给前端相同的响应
            response.getHeaders()
                    .put("Sec-WebSocket-Protocol", request.getHeaders()
                            .get("Sec-WebSocket-Protocol"));
            super.modifyHandshake(sec, request, response);
        } catch (UnauthorizedException e) {
            log.error(e.getMessage());
        }

    }

    @Override
    public <T> T getEndpointInstance(Class<T> clazz) throws InstantiationException {
        return super.getEndpointInstance(clazz);
    }

}

