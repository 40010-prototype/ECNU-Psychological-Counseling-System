package com.mygo.domain.enumeration;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

@Getter
public enum Role {
    PSYCHOLOGIST("psychologist"),
    SUPERVISOR("supervisor"),
    MANAGER("manager");


    @EnumValue
    private final String value;

    Role(String value) {
        this.value = value;
    }

    @JsonValue
    public String toJson() {
        return value;
    }
}
