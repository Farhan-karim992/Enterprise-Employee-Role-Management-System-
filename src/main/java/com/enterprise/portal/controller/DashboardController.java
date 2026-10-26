package com.enterprise.portal.controller;

import com.enterprise.portal.service.DashboardService;
import com.enterprise.portal.service.EmployeeService;
import com.enterprise.portal.service.LeaveRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Controller for the Executive Management Dashboard.
 * Serves aggregated counts, department distributions, and pending actions.
 */
@Controller
@RequestMapping({"/", "/dashboard"})
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private LeaveRequestService leaveRequestService;

    @GetMapping
    public String showDashboard(Model model) {
        model.addAttribute("stats", dashboardService.getDashboardMetrics());
        model.addAttribute("recentEmployees", employeeService.getRecentHires(5));
        model.addAttribute("pendingLeaves", leaveRequestService.getPendingLeaves());
        model.addAttribute("activeNav", "dashboard");
        return "dashboard";
    }
}
