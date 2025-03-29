package com.mygo;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import java.time.LocalDate;

@SpringBootTest(args = "--mpw.key=fqOS7bGCn3sxsTIL")
public class MailTest {


    @Autowired
    private JavaMailSender mailSender;


    @Test
    public void mailTest() {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setSubject("0721");
        message.setText(LocalDate.now().toString());
        message.setFrom("a728076618@163.com");
        message.setTo("a72807618@163.com");
        mailSender.send(message);
    }
}
