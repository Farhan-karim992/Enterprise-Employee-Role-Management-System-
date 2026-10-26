package com.enterprise.portal.service;

import com.enterprise.portal.dao.EmployeeDao;
import com.enterprise.portal.dao.LeaveRequestDao;
import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;
import com.enterprise.portal.entity.LeaveRequest;
import com.enterprise.portal.entity.LeaveStatus;
import com.enterprise.portal.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class LeaveRequestServiceImpl implements LeaveRequestService {

    private static final Logger logger = LoggerFactory.getLogger(LeaveRequestServiceImpl.class);

    @Autowired
    private LeaveRequestDao leaveRequestDao;

    @Autowired
    private EmployeeDao employeeDao;

    @Override
    @Transactional(readOnly = true)
    public List<LeaveRequest> getAllLeaveRequests() {
        return leaveRequestDao.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public LeaveRequest getLeaveRequestById(Long id) {
        return leaveRequestDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("LeaveRequest", id));
    }

    @Override
    @Transactional
    public LeaveRequest submitLeaveRequest(LeaveRequest request) {
        logger.info("Submitting new leave application for employee ID: {}", request.getEmployee().getId());
        request.setStatus(LeaveStatus.PENDING);
        request.calculateDays();
        leaveRequestDao.saveOrUpdate(request);
        return request;
    }

    @Override
    @Transactional
    public LeaveRequest approveLeaveRequest(Long id, String notes) {
        LeaveRequest request = getLeaveRequestById(id);
        request.setStatus(LeaveStatus.APPROVED);
        request.setDecisionNotes(notes);
        request.setReviewedAt(LocalDateTime.now());
        leaveRequestDao.saveOrUpdate(request);

        // Update employee status to ON_LEAVE if current date falls within leave period
        LocalDate today = LocalDate.now();
        if (!today.isBefore(request.getStartDate()) && !today.isAfter(request.getEndDate())) {
            Employee emp = request.getEmployee();
            emp.setStatus(EmployeeStatus.ON_LEAVE);
            employeeDao.saveOrUpdate(emp);
            logger.info("Employee {} status updated to ON_LEAVE", emp.getId());
        }

        return request;
    }

    @Override
    @Transactional
    public LeaveRequest rejectLeaveRequest(Long id, String notes) {
        LeaveRequest request = getLeaveRequestById(id);
        request.setStatus(LeaveStatus.REJECTED);
        request.setDecisionNotes(notes);
        request.setReviewedAt(LocalDateTime.now());
        leaveRequestDao.saveOrUpdate(request);
        return request;
    }

    @Override
    @Transactional(readOnly = true)
    public List<LeaveRequest> getLeavesByEmployeeId(Long employeeId) {
        return leaveRequestDao.findByEmployeeId(employeeId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<LeaveRequest> getPendingLeaves() {
        return leaveRequestDao.findByStatus(LeaveStatus.PENDING);
    }
}
