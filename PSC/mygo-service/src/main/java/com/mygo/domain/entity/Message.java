package com.mygo.domain.entity;

import com.mygo.domain.enumeration.MessageType;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Message {

    String fromId;

    String toId;

    MessageType messageType;

    String message;

}
