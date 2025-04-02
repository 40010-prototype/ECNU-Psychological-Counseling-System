package com.mygo.utils;

import java.util.Random;

public class RandomGenerator {

    public static String generateRandomNumber(int length) {
        Random random = new Random();
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < length; i++) {
            result.append(random.nextInt(10));  // 生成一个0-9之间的随机数
        }

        return result.toString();
    }
}
