package com.enterprise.portal.controller;

import com.enterprise.portal.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ResourceNotFoundException.class)
    public String handleResourceNotFound(ResourceNotFoundException ex, HttpServletRequest request, Model model) {
        logger.warn("Resource not found at {}: {}", request.getRequestURI(), ex.getMessage());
        model.addAttribute("errorCode", "404 - Not Found");
        model.addAttribute("errorMessage", ex.getMessage());
        model.addAttribute("requestedUri", request.getRequestURI());
        return "error";
    }

    @ExceptionHandler(Exception.class)
    public String handleGeneralException(Exception ex, HttpServletRequest request, Model model) {
        logger.error("Unhandled error processing request {}: {}", request.getRequestURI(), ex.getMessage(), ex);
        model.addAttribute("errorCode", "500 - Internal Server Error");
        model.addAttribute("errorMessage", "An unexpected system error occurred. Please contact the administrator.");
        model.addAttribute("technicalDetails", ex.getClass().getSimpleName() + ": " + ex.getMessage());
        model.addAttribute("requestedUri", request.getRequestURI());
        return "error";
    }
}
