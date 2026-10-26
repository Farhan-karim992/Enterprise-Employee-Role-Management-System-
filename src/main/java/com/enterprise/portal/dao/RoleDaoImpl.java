package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Role;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class RoleDaoImpl implements RoleDao {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Role> findAll() {
        String hql = "FROM Role r ORDER BY r.accessTier ASC, r.displayName ASC";
        return getCurrentSession().createQuery(hql, Role.class).getResultList();
    }

    @Override
    public Optional<Role> findById(Long id) {
        Role role = getCurrentSession().get(Role.class, id);
        return Optional.ofNullable(role);
    }

    @Override
    public Optional<Role> findByName(String name) {
        String hql = "FROM Role r WHERE r.name = :name";
        Query<Role> query = getCurrentSession().createQuery(hql, Role.class);
        query.setParameter("name", name);
        return query.uniqueResultOptional();
    }

    @Override
    public void saveOrUpdate(Role role) {
        getCurrentSession().saveOrUpdate(role);
    }
}
