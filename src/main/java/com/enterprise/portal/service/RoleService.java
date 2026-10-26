package com.enterprise.portal.service;

import com.enterprise.portal.dao.RoleDao;
import com.enterprise.portal.entity.Role;
import com.enterprise.portal.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface RoleService {
    List<Role> getAllRoles();
    Role getRoleById(Long id);
}
