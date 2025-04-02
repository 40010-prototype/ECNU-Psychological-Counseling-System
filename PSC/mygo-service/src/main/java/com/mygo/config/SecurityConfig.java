package com.mygo.config;

import com.mygo.properties.JwtProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.rsa.crypto.KeyStoreKeyFactory;

import java.security.KeyPair;

@Configuration
@EnableConfigurationProperties(JwtProperties.class)
public class SecurityConfig {

    /**
     * 非对称密钥管理,在jwt中用到
     */
    @Bean
    public KeyPair keyPair(JwtProperties properties) {
        // 获取秘钥工厂
        KeyStoreKeyFactory keyStoreKeyFactory = new KeyStoreKeyFactory(properties.getLocation(),
                properties.getStorePassword()
                        .toCharArray());
        // 读取钥匙对
        return keyStoreKeyFactory.getKeyPair(properties.getAlias(), properties.getKeyPassword()
                .toCharArray());
    }
}
