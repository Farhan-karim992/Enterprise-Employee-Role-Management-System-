package com.enterprise.portal.dao;

import com.enterprise.portal.entity.LeaveRequest;
import com.enterprise.portal.entity.LeaveStatus;

import java.util.List;
import java.util.Optional;

public interface LeaveRequestDao {

    List<LeaveRequest> findAll();

    Optional<LeaveRequest> findById(Long id);

    List<LeaveRequest> findByEmployeeId(Long employeeId);

    List<LeaveRequest> findByStatus(LeaveStatus status);

    void saveOrUpdate(LeaveRequest leaveRequest);

    void delete(LeaveRequest leaveRequest);

    long countPending();
}
