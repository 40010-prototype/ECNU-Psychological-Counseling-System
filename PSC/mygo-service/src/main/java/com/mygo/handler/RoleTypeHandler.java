package com.mygo.handler;

import com.mygo.domain.enumeration.Role;
import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RoleTypeHandler extends BaseTypeHandler<Role> {

    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, Role parameter, JdbcType jdbcType) throws SQLException {
        // 将枚举的值（如 "psychologist"）设置为数据库字段的值
        ps.setString(i, parameter.getValue());
    }

    @Override
    public Role getNullableResult(ResultSet rs, String columnName) throws SQLException {
        // 根据列名获取数据库中的值，并转换为 Role 枚举
        String roleStr = rs.getString(columnName);
        return Role.fromValue(roleStr); // 假设你在 Role 枚举类里有从值转换为枚举的方法
    }

    @Override
    public Role getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        String roleStr = rs.getString(columnIndex);
        return Role.fromValue(roleStr);
    }


    @Override
    public Role getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        String roleStr = cs.getString(columnIndex);
        return Role.fromValue(roleStr);
    }
}
