package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Department;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class DepartmentDaoImpl implements DepartmentDao {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Department> findAll() {
        String hql = "FROM Department d ORDER BY d.name ASC";
        return getCurrentSession().createQuery(hql, Department.class).getResultList();
    }

    @Override
    public List<Department> findAllWithEmployees() {
        String hql = "SELECT DISTINCT d FROM Department d " +
                     "LEFT JOIN FETCH d.employees e " +
                     "ORDER BY d.name ASC";
        return getCurrentSession().createQuery(hql, Department.class).getResultList();
    }

    @Override
    public Optional<Department> findById(Long id) {
        String hql = "SELECT d FROM Department d " +
                     "LEFT JOIN FETCH d.employees e " +
                     "WHERE d.id = :id";
        Query<Department> query = getCurrentSession().createQuery(hql, Department.class);
        query.setParameter("id", id);
        return query.uniqueResultOptional();
    }

    @Override
    public Optional<Department> findByCode(String code) {
        String hql = "FROM Department d WHERE UPPER(d.code) = UPPER(:code)";
        Query<Department> query = getCurrentSession().createQuery(hql, Department.class);
        query.setParameter("code", code.trim());
        return query.uniqueResultOptional();
    }

    @Override
    public void saveOrUpdate(Department department) {
        getCurrentSession().saveOrUpdate(department);
    }

    @Override
    public void delete(Department department) {
        getCurrentSession().delete(department);
    }

    @Override
    public void deleteById(Long id) {
        findById(id).ifPresent(this::delete);
    }

    @Override
    public long countTotal() {
        String hql = "SELECT COUNT(d) FROM Department d";
        return getCurrentSession().createQuery(hql, Long.class).getSingleResult();
    }
}
