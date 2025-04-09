package com.mygo.domain.vo;

import com.mygo.domain.enumeration.MessageType;
import lombok.Data;

@Data
public class MessageVO {

    Integer fromId;

    MessageType messageType;

    String message;

    Boolean firstConnect;

    public MessageVO(Integer fromId, MessageType messageType, String message) {
        this.fromId = fromId;
        this.messageType = messageType;
        this.message = message;
        this.firstConnect = false;
    }

}
