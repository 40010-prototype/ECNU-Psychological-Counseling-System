package com.mygo.mapper;

import com.mygo.domain.entity.Admin;
import com.mygo.domain.enumeration.Role;
import com.mygo.handler.RoleTypeHandler;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;

public interface AdminMapper {

    @Select("SELECT * FROM admin WHERE account_name=#{accountName}")
    @Results({@Result(property = "role", column = "role", javaType = Role.class, typeHandler = RoleTypeHandler.class)
            , @Result(property = "createdAt", column = "created_at", javaType = LocalDateTime.class)})
    Admin getAdminByName(String accountName);

    @Select("SELECT * FROM admin WHERE admin_id=#{id}")
    @Results({@Result(property = "role", column = "role", javaType = Role.class, typeHandler = RoleTypeHandler.class)
            , @Result(property = "createdAt", column = "created_at", javaType = LocalDateTime.class)})
    Admin getAdminById(Integer id);

    @Insert("INSERT INTO admin(admin_id, account_name, real_name, email, password,role,info) VALUES(#{id}, " +
            "#{accountName},#{realName},  #{email},#{password}, #{role},#{info})")
    void addAdmin(Integer id, String accountName, String realName,  String email, String password,
                  Role role, String info);

    @Select("SELECT email FROM admin WHERE account_name=#{accountName}")
    String getEmailByAccountName(String accountName);

    @Update("UPDATE admin SET password=#{password} WHERE name=#{name}")
    void updatePassword(String name, String password);

}
