package com.mygo.domain.enumeration;

import com.fasterxml.jackson.annotation.JsonValue;
import lombok.Getter;

@Getter
public enum Role {
    COUNSELOR   ("counselor"),
    SUPERVISOR("supervisor"),
    MANAGER("manager");

    private final String value;

    Role(String value) {
        this.value = value;
    }

    public static Role fromValue(String value) {
        for (Role role : Role.values()) {
            if (role.getValue().equalsIgnoreCase(value)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }

    @JsonValue
    public String toJson() {
        return value;
    }
}
