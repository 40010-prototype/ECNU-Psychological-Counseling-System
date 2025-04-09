package com.mygo.mapper;

import com.mygo.domain.enumeration.MessageType;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface ChatMapper {

    @Select("SELECT * FROM consult_record WHERE admin_id=#{adminId} AND user_id=#{userId} AND status='progressing'")
    Integer getConsultId(Integer adminId, Integer userId);

    @Update("INSERT INTO message(consult_id, message, message_type, sender) VALUES (#{consultId}, #{message}, " +
            "#{messageType}, #{sender})")
    void addMessage(Integer consultId, String message, MessageType messageType, String sender);

}
