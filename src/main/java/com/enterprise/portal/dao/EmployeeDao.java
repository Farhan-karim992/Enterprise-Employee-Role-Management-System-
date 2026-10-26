package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface EmployeeDao {

    List<Employee> findAll();

    Optional<Employee> findById(Long id);

    Optional<Employee> findByEmail(String email);

    void saveOrUpdate(Employee employee);

    void delete(Employee employee);

    void deleteById(Long id);

    List<Employee> search(String keyword, Long departmentId, EmployeeStatus status);

    List<Employee> findByDepartmentId(Long departmentId);

    long countTotal();

    long countByStatus(EmployeeStatus status);

    Map<String, Long> countByDepartmentDistribution();

    List<Employee> findRecentHires(int limit);
}
