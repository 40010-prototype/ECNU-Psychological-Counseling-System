package com.mygo.utils;

public class AdminContext {

    private static final ThreadLocal<Long> tl = new ThreadLocal<>();

    public static void saveUser(Long userId) {
        tl.set(userId);
    }

    public static Long getUser() {
        return tl.get();
    }

    public static void removeUser() {
        tl.remove();
    }
}
