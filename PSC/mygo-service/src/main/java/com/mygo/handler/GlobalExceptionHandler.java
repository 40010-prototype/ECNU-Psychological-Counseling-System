package com.mygo.handler;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mygo.constant.SQLExceptionCodes;
import com.mygo.exception.BaseException;
import com.mygo.result.Result;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.support.DefaultMessageSourceResolvable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    private ObjectMapper objectMapper = new ObjectMapper();


    /**
     * 自定义异常处理器
     */
    @ExceptionHandler(BaseException.class)
    public ResponseEntity<Result<Void>> handleBadRequestException(BaseException e) {
        log.error("自定义异常 -> {} , 异常原因：{}  ", e.getClass()
                .getName(), e.getMessage());
        log.debug("", e);
        return ResponseEntity.status(e.getCode())
                .body(Result.error(e.getMessage()));
    }

    @ExceptionHandler(SQLIntegrityConstraintViolationException.class)
    public ResponseEntity<Result<Void>> handleSQLException(SQLIntegrityConstraintViolationException e) {
        if (e.getErrorCode() == SQLExceptionCodes.ER_DUP_ENTRY) {
            return ResponseEntity.status(HttpServletResponse.SC_CONFLICT)
                    .body(Result.error("唯一键约束冲突"));
        }
        return ResponseEntity.status(401)
                .body(Result.error("测试"));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException e) throws JsonProcessingException {

        List<String> errors = e.getBindingResult().getAllErrors()
                .stream()
                .map(DefaultMessageSourceResolvable::getDefaultMessage)
                .toList();


        return ResponseEntity.status(HttpServletResponse.SC_BAD_REQUEST).body(Result.error(errors.toString()));
    }


}
