package com.mygo.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.core.io.Resource;

import java.time.Duration;

@Data
@ConfigurationProperties(prefix = "mygo.jwt")
public class JwtProperties {

    private Resource location;

    private String storePassword;

    private String keyPassword;

    private String alias;

    private Duration tokenTTL;

}