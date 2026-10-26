package com.enterprise.portal.service;

import com.enterprise.portal.dao.EmployeeDao;
import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;
import com.enterprise.portal.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * Service Implementation for Employee management.
 * Defines transaction boundaries using Spring's @Transactional annotation.
 */
@Service
public class EmployeeServiceImpl implements EmployeeService {

    private static final Logger logger = LoggerFactory.getLogger(EmployeeServiceImpl.class);

    @Autowired
    private EmployeeDao employeeDao;

    @Override
    @Transactional(readOnly = true)
    public List<Employee> getAllEmployees() {
        return employeeDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Employee getEmployeeById(Long id) {
        return employeeDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee", id));
    }

    @Override
    @Transactional
    public Employee saveOrUpdateEmployee(Employee employee) {
        logger.info("Executing transaction to persist/update employee: {}", employee.getEmail());
        employeeDao.saveOrUpdate(employee);
        return employee;
    }

    @Override
    @Transactional
    public void deleteEmployee(Long id) {
        logger.info("Executing transaction to delete employee ID: {}", id);
        Employee employee = getEmployeeById(id);
        employeeDao.delete(employee);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Employee> searchEmployees(String keyword, Long departmentId, EmployeeStatus status) {
        return employeeDao.search(keyword, departmentId, status);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isEmailUnique(Long id, String email) {
        Optional<Employee> existing = employeeDao.findByEmail(email);
        if (existing.isEmpty()) {
            return true;
        }
        return id != null && existing.get().getId().equals(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Employee> getRecentHires(int limit) {
        return employeeDao.findRecentHires(limit);
    }
}
