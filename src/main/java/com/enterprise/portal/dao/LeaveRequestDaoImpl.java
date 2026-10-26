package com.enterprise.portal.dao;

import com.enterprise.portal.entity.LeaveRequest;
import com.enterprise.portal.entity.LeaveStatus;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class LeaveRequestDaoImpl implements LeaveRequestDao {

    @Autowired
    private SessionFactory sessionFactory;

    protected Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public List<LeaveRequest> findAll() {
        String hql = "SELECT l FROM LeaveRequest l " +
                     "JOIN FETCH l.employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "ORDER BY l.appliedAt DESC";
        return getCurrentSession().createQuery(hql, LeaveRequest.class).getResultList();
    }

    @Override
    public Optional<LeaveRequest> findById(Long id) {
        String hql = "SELECT l FROM LeaveRequest l " +
                     "JOIN FETCH l.employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "WHERE l.id = :id";
        Query<LeaveRequest> query = getCurrentSession().createQuery(hql, LeaveRequest.class);
        query.setParameter("id", id);
        return query.uniqueResultOptional();
    }

    @Override
    public List<LeaveRequest> findByEmployeeId(Long employeeId) {
        String hql = "SELECT l FROM LeaveRequest l " +
                     "JOIN FETCH l.employee e " +
                     "WHERE e.id = :empId " +
                     "ORDER BY l.startDate DESC";
        Query<LeaveRequest> query = getCurrentSession().createQuery(hql, LeaveRequest.class);
        query.setParameter("empId", employeeId);
        return query.getResultList();
    }

    @Override
    public List<LeaveRequest> findByStatus(LeaveStatus status) {
        String hql = "SELECT l FROM LeaveRequest l " +
                     "JOIN FETCH l.employee e " +
                     "LEFT JOIN FETCH e.department d " +
                     "WHERE l.status = :status " +
                     "ORDER BY l.appliedAt ASC";
        Query<LeaveRequest> query = getCurrentSession().createQuery(hql, LeaveRequest.class);
        query.setParameter("status", status);
        return query.getResultList();
    }

    @Override
    public void saveOrUpdate(LeaveRequest leaveRequest) {
        getCurrentSession().saveOrUpdate(leaveRequest);
    }

    @Override
    public void delete(LeaveRequest leaveRequest) {
        getCurrentSession().delete(leaveRequest);
    }

    @Override
    public long countPending() {
        String hql = "SELECT COUNT(l) FROM LeaveRequest l WHERE l.status = :status";
        Query<Long> query = getCurrentSession().createQuery(hql, Long.class);
        query.setParameter("status", LeaveStatus.PENDING);
        return query.getSingleResult();
    }
}
