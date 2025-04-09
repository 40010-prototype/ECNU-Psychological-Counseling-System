package com.mygo.utils;

/**
 * 把用户id存在threadLocal中（包括管理端和用户端）
 */
public class Context {

    private static final ThreadLocal<Integer> tl = new ThreadLocal<>();

    public static void saveId(Integer userId) {
        tl.set(userId);
    }

    public static Integer getId() {
        return tl.get();
    }

    public static void removeId() {
        tl.remove();
    }

}
