package com.enterprise.portal.service;

import com.enterprise.portal.dao.DepartmentDao;
import com.enterprise.portal.entity.Department;
import com.enterprise.portal.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class DepartmentServiceImpl implements DepartmentService {

    @Autowired
    private DepartmentDao departmentDao;

    @Override
    @Transactional(readOnly = true)
    public List<Department> getAllDepartments() {
        return departmentDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Department> getAllDepartmentsWithEmployees() {
        return departmentDao.findAllWithEmployees();
    }

    @Override
    @Transactional(readOnly = true)
    public Department getDepartmentById(Long id) {
        return departmentDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Department", id));
    }

    @Override
    @Transactional
    public Department saveOrUpdateDepartment(Department department) {
        departmentDao.saveOrUpdate(department);
        return department;
    }

    @Override
    @Transactional
    public void deleteDepartment(Long id) {
        departmentDao.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isCodeUnique(Long id, String code) {
        Optional<Department> existing = departmentDao.findByCode(code);
        if (existing.isEmpty()) {
            return true;
        }
        return id != null && existing.get().getId().equals(id);
    }
}
