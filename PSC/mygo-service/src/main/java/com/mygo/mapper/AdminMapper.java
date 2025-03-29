package com.mygo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.mygo.domain.entity.Admin;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface AdminMapper extends BaseMapper<Admin> {

    @Select("SELECT * FROM admins WHERE name=#{name}")
    Admin getAdminByName(@Param("name") String name);

    @Insert("INSERT INTO admins(name, password, email) VALUES(#{username}, #{password}, #{email})")
    void addAdmin(String username, String password, String email);

    @Select("SELECT email FROM admins WHERE name=#{name}")
    String getEmailByName(String name);

    @Update("UPDATE admins SET password=#{password} WHERE name=#{name}")
    void updatePassword(@Param("name") String name, @Param("password") String password);
}
