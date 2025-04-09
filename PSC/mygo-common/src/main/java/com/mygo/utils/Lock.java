package com.mygo.utils;

public interface Lock {

    boolean tryLock(long timeoutSeconds);

    void unlock();

}
