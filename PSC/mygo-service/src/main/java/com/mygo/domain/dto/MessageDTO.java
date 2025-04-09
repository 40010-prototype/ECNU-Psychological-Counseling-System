package com.mygo.domain.dto;

import com.mygo.domain.enumeration.MessageType;
import lombok.Data;

@Data
public class MessageDTO {

    Integer toId;

    MessageType messageType;

    String message;

}
