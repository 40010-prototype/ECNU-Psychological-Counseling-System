package com.mygo;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@MapperScan("com.mygo.mapper")
@SpringBootApplication
public class MygoApplication {

    //TODO测试能不能防SQL注入
    //TODO如果不用mybatis-plus的话，就删了
    //TODO报错信息整理为常量类
    public static void main(String[] args) {
        SpringApplication.run(MygoApplication.class, args);
    }

}

