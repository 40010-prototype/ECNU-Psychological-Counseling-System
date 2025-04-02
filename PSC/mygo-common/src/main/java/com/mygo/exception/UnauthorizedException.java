package com.mygo.exception;

import jakarta.servlet.http.HttpServletResponse;

public class UnauthorizedException extends BaseException {

    public UnauthorizedException(String message) {
        super(message, HttpServletResponse.SC_UNAUTHORIZED);
    }

    public UnauthorizedException(String message, Throwable cause) {
        super(message, cause, HttpServletResponse.SC_UNAUTHORIZED);
    }

    public UnauthorizedException(Throwable cause) {
        super(cause, HttpServletResponse.SC_UNAUTHORIZED);
    }
}
