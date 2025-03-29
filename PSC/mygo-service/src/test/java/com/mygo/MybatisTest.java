package com.mygo;

import com.mygo.mapper.AdminMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.redis.core.StringRedisTemplate;

@SpringBootTest(args = "--mpw.key=fqOS7bGCn3sxsTIL")
public class MybatisTest {

    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private StringRedisTemplate stringRedisTemplate;


    @Test
    void SqlExceptionTest() {
        adminMapper.addAdmin("五河琴里", "123", "kk@qq.com");
        adminMapper.addAdmin("五河琴里", "123", "kk@qq.com");
    }
}
