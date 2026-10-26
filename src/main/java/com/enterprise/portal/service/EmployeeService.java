package com.enterprise.portal.service;

import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;

import java.util.List;

public interface EmployeeService {

    List<Employee> getAllEmployees();

    Employee getEmployeeById(Long id);

    Employee saveOrUpdateEmployee(Employee employee);

    void deleteEmployee(Long id);

    List<Employee> searchEmployees(String keyword, Long departmentId, EmployeeStatus status);

    boolean isEmailUnique(Long id, String email);

    List<Employee> getRecentHires(int limit);
}
