package com.enterprise.portal.dao;

import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Hibernate DAO Implementation for Employee entities.
 * Utilizes Hibernate SessionFactory, optimized HQL joins (avoiding N+1 queries),
 * and parameterized query execution.
 */
@Repository
public class EmployeeDaoImpl implements EmployeeDao {

    private static final Logger logger = LoggerFactory.getLogger(EmployeeDaoImpl.class);

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<Employee> findAll() {
        // Optimized JOIN FETCH query prevents N+1 lazy loading issues
        String hql = "SELECT DISTINCT e FROM Employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "LEFT JOIN FETCH e.role r " +
                     "ORDER BY e.lastName ASC, e.firstName ASC";
        Query<Employee> query = getCurrentSession().createQuery(hql, Employee.class);
        return query.getResultList();
    }

    @Override
    public Optional<Employee> findById(Long id) {
        String hql = "SELECT e FROM Employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "LEFT JOIN FETCH e.role r " +
                     "WHERE e.id = :id";
        Query<Employee> query = getCurrentSession().createQuery(hql, Employee.class);
        query.setParameter("id", id);
        return query.uniqueResultOptional();
    }

    @Override
    public Optional<Employee> findByEmail(String email) {
        String hql = "SELECT e FROM Employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "LEFT JOIN FETCH e.role r " +
                     "WHERE LOWER(e.email) = LOWER(:email)";
        Query<Employee> query = getCurrentSession().createQuery(hql, Employee.class);
        query.setParameter("email", email.trim());
        return query.uniqueResultOptional();
    }

    @Override
    public void saveOrUpdate(Employee employee) {
        getCurrentSession().saveOrUpdate(employee);
        logger.debug("Employee saved/updated successfully with ID: {}", employee.getId());
    }

    @Override
    public void delete(Employee employee) {
        getCurrentSession().delete(employee);
        logger.debug("Employee deleted: {}", employee.getId());
    }

    @Override
    public void deleteById(Long id) {
        findById(id).ifPresent(this::delete);
    }

    @Override
    public List<Employee> search(String keyword, Long departmentId, EmployeeStatus status) {
        StringBuilder hql = new StringBuilder(
            "SELECT DISTINCT e FROM Employee e " +
            "LEFT JOIN FETCH e.department d " +
            "LEFT JOIN FETCH e.role r " +
            "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append("AND (LOWER(e.firstName) LIKE :kw " +
                       "OR LOWER(e.lastName) LIKE :kw " +
                       "OR LOWER(e.email) LIKE :kw " +
                       "OR LOWER(e.jobTitle) LIKE :kw) ");
        }

        if (departmentId != null) {
            hql.append("AND d.id = :deptId ");
        }

        if (status != null) {
            hql.append("AND e.status = :status ");
        }

        hql.append("ORDER BY e.lastName ASC, e.firstName ASC");

        Query<Employee> query = getCurrentSession().createQuery(hql.toString(), Employee.class);

        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        }

        if (departmentId != null) {
            query.setParameter("deptId", departmentId);
        }

        if (status != null) {
            query.setParameter("status", status);
        }

        return query.getResultList();
    }

    @Override
    public List<Employee> findByDepartmentId(Long departmentId) {
        String hql = "SELECT e FROM Employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "LEFT JOIN FETCH e.role r " +
                     "WHERE d.id = :deptId " +
                     "ORDER BY e.lastName ASC";
        Query<Employee> query = getCurrentSession().createQuery(hql, Employee.class);
        query.setParameter("deptId", departmentId);
        return query.getResultList();
    }

    @Override
    public long countTotal() {
        String hql = "SELECT COUNT(e) FROM Employee e";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        return query.getSingleResult();
    }

    @Override
    public long countByStatus(EmployeeStatus status) {
        String hql = "SELECT COUNT(e) FROM Employee e WHERE e.status = :status";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    @Override
    public Map<String, Long> countByDepartmentDistribution() {
        String hql = "SELECT COALESCE(d.name, 'Unassigned'), COUNT(e) " +
                     "FROM Employee e LEFT JOIN e.department d " +
                     "GROUP BY d.name ORDER BY COUNT(e) DESC";
        Query<Object[]> query = getCurrentSession().createQuery(hql, Object[].class);
        List<Object[]> results = query.getResultList();

        Map<String, Long> distribution = new LinkedHashMap<>();
        for (Object[] row : results) {
            String deptName = (String) row[0];
            Long count = (Long) row[1];
            distribution.put(deptName, count);
        }
        return distribution;
    }

    @Override
    public List<Employee> findRecentHires(int limit) {
        String hql = "SELECT e FROM Employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "LEFT JOIN FETCH e.role r " +
                     "ORDER BY e.hireDate DESC";
        Query<Employee> query = getCurrentSession().createQuery(hql, Employee.class);
        query.setMaxResults(limit);
        return query.getResultList();
    }
}
