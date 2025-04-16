package com.mygo.constant;

import java.util.concurrent.TimeUnit;

public class RedisConstant {

    //不管是admin端还是user端，统一用这个key，因为http和websocket的拦截器要做统一处理
    //不用担心键冲突，因为不会有admin和user的id是一样的
    //login:token:{id)
    public static final String JWT_KEY = "login:token:";

    public static final int JWT_EXPIRE = 12;

    public static final TimeUnit JWT_EXPIRE_UNIT = TimeUnit.HOURS;

    public static final String JWT_VALUE = "ciallo";

    //admin:reset:verify:{name}
    public static final String ADMIN_VERIFY_KEY = "admin:reset:verify:";

    public static final int VERIFY_EXPIRE = 10;

    public static final TimeUnit VERIFY_EXPIRE_UNIT = TimeUnit.MINUTES;

    //用于生成唯一id
    public static final String PERSON_INDEX_KEY = "index:person";

    public static final String PERSON_INDEX_OFFSET = "721";

    public static final Integer PERSON_INDEX_INCREMENT = 7;

    public static final String CHAT_INDEX_KEY = "index:chat";

}
