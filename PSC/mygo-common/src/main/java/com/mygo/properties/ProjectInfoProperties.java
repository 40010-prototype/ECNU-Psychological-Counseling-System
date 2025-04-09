package com.mygo.properties;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "mygo.project-info")
public class ProjectInfoProperties {

    private String projectName;

    private String version;

}
