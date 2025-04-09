package com.mygo.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.mygo.domain.entity.Message;

public interface ChatService {

    void receiveMessage(Message message) throws JsonProcessingException;

}
