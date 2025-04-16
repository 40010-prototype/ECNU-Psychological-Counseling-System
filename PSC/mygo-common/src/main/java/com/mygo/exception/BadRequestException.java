package com.mygo.exception;

import jakarta.servlet.http.HttpServletResponse;

public class BadRequestException extends BaseException {

    public BadRequestException(String message) {
        super(message, HttpServletResponse.SC_BAD_REQUEST);
    }

    public BadRequestException(String message, Throwable cause) {
        super(message, cause, HttpServletResponse.SC_BAD_REQUEST);
    }

    public BadRequestException(Throwable cause) {
        super(cause, HttpServletResponse.SC_BAD_REQUEST);
    }

}
