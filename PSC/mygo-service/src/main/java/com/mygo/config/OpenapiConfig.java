package com.mygo.config;

import com.mygo.properties.ProjectInfoProperties;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@EnableConfigurationProperties(ProjectInfoProperties.class)
@Configuration
public class OpenapiConfig {

    /**
     * 管理端接口分组
     */
    @Bean
    public GroupedOpenApi adminApi(ProjectInfoProperties projectInfoProperties) {
        return GroupedOpenApi.builder()  // 创建了一个api接口的分组
                //TODO分组默认按照名称排序.为了前期开发,添加编号1、2,后期删去
                .group("1.管理端接口")//分组名称
                //分组信息
                .addOpenApiCustomizer(openApi -> openApi.info(new Info().title(
                                projectInfoProperties.getProjectName() + "接口文档")
                        .description(projectInfoProperties.getProjectName() + "接口文档")
                        .version(projectInfoProperties.getVersion())
                        .contact(new Contact().name("eustia")
                                .url("https://github.com/Eustia232"))))
                .pathsToMatch("/admin/**")  // 接口请求路径规则
                .build();
    }

    /**
     * 用户端接口分组
     */
    @Bean
    public GroupedOpenApi userApi() {
        return GroupedOpenApi.builder()  // 创建了一个api接口的分组
                .group("2.用户端接口")         // 分组名称
                .pathsToMatch("/user/**")  // 接口请求路径规则
                .build();
    }

}