package com.enterprise.portal.service;

import com.enterprise.portal.dao.RoleDao;
import com.enterprise.portal.entity.Role;
import com.enterprise.portal.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private RoleDao roleDao;

    @Override
    @Transactional(readOnly = true)
    public List<Role> getAllRoles() {
        return roleDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Role getRoleById(Long id) {
        return roleDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Role", id));
    }
}
