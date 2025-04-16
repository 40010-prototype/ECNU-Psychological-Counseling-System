package com.mygo.domain.enumeration;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

@Getter
public enum MessageType {
    TEXT("text"),
    PHOTO("photo"),
    FILE("file"),
    SYSTEM("system");

    @EnumValue
    private final String value;

    MessageType(String value) {
        this.value = value;
    }

    @JsonValue
    public String toJson() {
        return value;
    }
}
