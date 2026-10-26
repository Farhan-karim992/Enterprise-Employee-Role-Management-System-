package com.enterprise.portal.service;

import com.enterprise.portal.entity.LeaveRequest;

import java.util.List;

public interface LeaveRequestService {

    List<LeaveRequest> getAllLeaveRequests();

    LeaveRequest getLeaveRequestById(Long id);

    LeaveRequest submitLeaveRequest(LeaveRequest request);

    LeaveRequest approveLeaveRequest(Long id, String notes);

    LeaveRequest rejectLeaveRequest(Long id, String notes);

    List<LeaveRequest> getLeavesByEmployeeId(Long employeeId);

    List<LeaveRequest> getPendingLeaves();
}
