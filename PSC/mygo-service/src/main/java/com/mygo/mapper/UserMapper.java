package com.mygo.mapper;

import com.mygo.domain.entity.User;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface UserMapper {

    @Insert("INSERT INTO user(user_id, email, password) VALUES (#{id}, #{email}, #{password})")
    void addUser(@Param("id") long id, @Param("email") String email, @Param("password") String password);

    @Select("SELECT * FROM user WHERE email=#{email}")
    User selectUserByEmail(@Param("email") String email);


}
