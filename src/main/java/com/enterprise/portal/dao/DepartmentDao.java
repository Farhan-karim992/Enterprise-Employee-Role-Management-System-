package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Department;

import java.util.List;
import java.util.Optional;

public interface DepartmentDao {

    List<Department> findAll();

    List<Department> findAllWithEmployees();

    Optional<Department> findById(Long id);

    Optional<Department> findByCode(String code);

    void saveOrUpdate(Department department);

    void delete(Department department);

    void deleteById(Long id);

    long countTotal();
}
