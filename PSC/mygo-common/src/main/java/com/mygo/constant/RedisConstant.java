package com.mygo.constant;

import java.util.concurrent.TimeUnit;

public class RedisConstant {

    //admin:login:token:{id)
    public static final String JWT_KEY = "admin:login:token:";

    public static final int JWT_EXPIRE = 12;

    public static final TimeUnit JWT_EXPIRE_UNIT = TimeUnit.HOURS;

    //admin:reset:verify:{name}
    public static final String VERIFY_KEY = "admin:reset:verify:";

    public static final int VERIFY_EXPIRE = 10;

    public static final TimeUnit VERIFY_EXPIRE_UNIT = TimeUnit.MINUTES;

}
