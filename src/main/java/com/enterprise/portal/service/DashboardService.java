package com.enterprise.portal.service;

import com.enterprise.portal.dao.DepartmentDao;
import com.enterprise.portal.dao.EmployeeDao;
import com.enterprise.portal.dao.LeaveRequestDao;
import com.enterprise.portal.dto.DashboardStatsDto;
import com.enterprise.portal.entity.EmployeeStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class DashboardService {

    @Autowired
    private EmployeeDao employeeDao;

    @Autowired
    private DepartmentDao departmentDao;

    @Autowired
    private LeaveRequestDao leaveRequestDao;

    @Transactional(readOnly = true)
    public DashboardStatsDto getDashboardMetrics() {
        DashboardStatsDto stats = new DashboardStatsDto();
        stats.setTotalEmployees(employeeDao.countTotal());
        stats.setActiveEmployees(employeeDao.countByStatus(EmployeeStatus.ACTIVE));
        stats.setOnLeaveEmployees(employeeDao.countByStatus(EmployeeStatus.ON_LEAVE));
        stats.setTotalDepartments(departmentDao.countTotal());
        stats.setPendingLeaveRequests(leaveRequestDao.countPending());
        stats.setDepartmentDistribution(employeeDao.countByDepartmentDistribution());
        return stats;
    }
}
