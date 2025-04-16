package com.mygo;

import cn.hutool.jwt.signers.JWTSigner;
import cn.hutool.jwt.signers.JWTSignerUtil;
import com.baomidou.mybatisplus.core.toolkit.AES;
import com.mygo.properties.JwtProperties;
import com.mygo.utils.JwtTool;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;

@SpringBootTest(args = "--mpw.key=fqOS7bGCn3sxsTIL")
public class SecretTest {

    @Autowired
    JwtProperties jwtProperties;

    @Autowired
    KeyPair keyPair;

    @Autowired
    JwtTool jwtTool;

    @Test
    void contextLoads() {
        // 生成 16 位随机 AES 密钥
        String randomKey = "fqOS7bGCn3sxsTIL";
        // 利用密钥对用户名加密
        String text = AES.encrypt("YLgjz35ThdTAA2Ka", randomKey);
        System.out.println("username = " + text);
    }

    @Test
    public void generateRSAKeyPair() throws Exception {
        // 创建 KeyPairGenerator 实例，指定算法为 RSA
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        // 初始化密钥对生成器，密钥长度为 2048 位
        keyPairGenerator.initialize(2048);
        // 生成密钥对
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        // 获取私钥和公钥
        PrivateKey privateKey = keyPair.getPrivate();
        PublicKey publicKey = keyPair.getPublic();
        // 将公钥保存到 public.pem 文件
        System.out.println("privateKey = " + privateKey);
        System.out.println("publicKey = " + publicKey);
    }

    @Test
    public void porte() {
        System.out.println(jwtProperties.getTokenTTL());
    }

    @Test
    public void tryrsa() {
        System.out.println(keyPair.getPrivate());
        JWTSigner signer = JWTSignerUtil.createSigner("rs256", keyPair);
//        KeyStoreKeyFactory keyStoreKeyFactory =
//                new KeyStoreKeyFactory(
//                        properties.getLocation(),
//                        properties.getPassword().toCharArray());
//        //读取钥匙对
//        return keyStoreKeyFactory.getKeyPair(
//                properties.getAlias(),
//                properties.getPassword().toCharArray());
    }

    @Test
    public void testToken() {
        Object id = jwtTool.parseJWT("eyJ0eXAiOiJKV1QiLCJhbG" +
                "ciOiJSUzI1NiJ9.eyJpZCI6MSwiZXhwIjoxNzQyMDIwMjcxfQ.fHAzy" +
                "eyUmIyfCBBN6NHD_ZbXeEa91fiiT3N7ck7f7kA104u5kAj_vt9I12n1JZdyqv5z7ZwC1wyHncCkNP8Lm" +
                "-fKX2WtZsxUKZrLBrzFakwaiTUrBZQ0nd_GOuENVv0-deNxf2VVSc7FN" +
                "-pbwmkWonSLBS8GqdWInjhoLv4icKAU" +
                "1DcyaVhNhTjZcEz7pTEYhu1fe3aFNcX4_PtGAt5yxRvPJbyU0wp9uMFCmPVF_fpV7WDiVK4ZLzIVRjLnnb7aTqpKSWDf7" +
                "-JJFlSetqCyxBIZ5_GERr_5xJodY3V2a9wXwE8xoNX31RjeeoNilTTWUmoFUitIYJTTiJuAhYCzPQ");
        System.out.println(id);
    }

}
