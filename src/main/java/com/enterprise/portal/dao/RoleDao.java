package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Role;

import java.util.List;
import java.util.Optional;

public interface RoleDao {

    List<Role> findAll();

    Optional<Role> findById(Long id);

    Optional<Role> findByName(String name);

    void saveOrUpdate(Role role);
}
