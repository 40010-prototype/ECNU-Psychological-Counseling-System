package com.mygo.utils;

import com.mygo.constant.RedisConstant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

/**
 * 自定义Id工具，利用redis实现全局Id。<br>
 * 为了不和hutool中的IdUtil重名，改名为IdTool。
 */
@Component
public class IdTool {

    private final StringRedisTemplate stringRedisTemplate;

    @Autowired
    public IdTool(StringRedisTemplate stringRedisTemplate) {
        this.stringRedisTemplate = stringRedisTemplate;
    }

    public int getPersonId() {
        //查询redis中存的id，作为返回结果，并自增，作为下次使用
        String id = stringRedisTemplate.opsForValue()
                .get(RedisConstant.PERSON_INDEX_KEY);
        if (id == null) {
            stringRedisTemplate.opsForValue()
                    .set(RedisConstant.PERSON_INDEX_KEY, RedisConstant.PERSON_INDEX_OFFSET);
            return 0;
        }
        int personId = Integer.parseInt(id);
        stringRedisTemplate.opsForValue()
                .set(RedisConstant.PERSON_INDEX_KEY, String.valueOf(personId + RedisConstant.PERSON_INDEX_INCREMENT));
        return personId;
    }

}
