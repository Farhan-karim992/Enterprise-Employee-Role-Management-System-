package com.enterprise.portal.service;

import com.enterprise.portal.entity.Department;

import java.util.List;

public interface DepartmentService {

    List<Department> getAllDepartments();

    List<Department> getAllDepartmentsWithEmployees();

    Department getDepartmentById(Long id);

    Department saveOrUpdateDepartment(Department department);

    void deleteDepartment(Long id);

    boolean isCodeUnique(Long id, String code);
}
