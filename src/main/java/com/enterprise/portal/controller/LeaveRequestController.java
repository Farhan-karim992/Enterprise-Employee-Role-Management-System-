package com.enterprise.portal.controller;

import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.LeaveRequest;
import com.enterprise.portal.entity.LeaveStatus;
import com.enterprise.portal.entity.LeaveType;
import com.enterprise.portal.service.EmployeeService;
import com.enterprise.portal.service.LeaveRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/leaves")
public class LeaveRequestController {

    @Autowired
    private LeaveRequestService leaveRequestService;

    @Autowired
    private EmployeeService employeeService;

    @ModelAttribute("employeesList")
    public List<Employee> populateEmployees() {
        return employeeService.getAllEmployees();
    }

    @ModelAttribute("leaveTypes")
    public LeaveType[] populateLeaveTypes() {
        return LeaveType.values();
    }

    @GetMapping
    public String listLeaves(
            @RequestParam(name = "status", required = false) LeaveStatus status,
            Model model) {

        List<LeaveRequest> requests;
        if (status != null) {
            requests = leaveRequestService.getAllLeaveRequests().stream()
                    .filter(l -> l.getStatus() == status)
                    .toList();
        } else {
            requests = leaveRequestService.getAllLeaveRequests();
        }

        model.addAttribute("leaveRequests", requests);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("activeNav", "leaves");
        return "leave/list";
    }

    @GetMapping("/apply")
    public String showApplyForm(
            @RequestParam(name = "employeeId", required = false) Long employeeId,
            Model model) {

        LeaveRequest leaveRequest = new LeaveRequest();
        if (employeeId != null) {
            try {
                leaveRequest.setEmployee(employeeService.getEmployeeById(employeeId));
            } catch (Exception ignored) {}
        }

        model.addAttribute("leaveRequest", leaveRequest);
        model.addAttribute("activeNav", "leaves");
        return "leave/form";
    }

    @PostMapping("/apply")
    public String submitLeave(
            @Valid @ModelAttribute("leaveRequest") LeaveRequest leaveRequest,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (leaveRequest.getStartDate() != null && leaveRequest.getEndDate() != null) {
            if (leaveRequest.getEndDate().isBefore(leaveRequest.getStartDate())) {
                bindingResult.rejectValue("endDate", "date.order", "End date cannot be prior to start date");
            }
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("activeNav", "leaves");
            return "leave/form";
        }

        leaveRequestService.submitLeaveRequest(leaveRequest);
        redirectAttributes.addFlashAttribute("successMessage", "Leave application submitted successfully.");
        return "redirect:/leaves";
    }

    @PostMapping("/{id}/approve")
    public String approveLeave(
            @PathVariable("id") Long id,
            @RequestParam(name = "notes", required = false, defaultValue = "Approved") String notes,
            RedirectAttributes redirectAttributes) {

        leaveRequestService.approveLeaveRequest(id, notes);
        redirectAttributes.addFlashAttribute("successMessage", "Leave request #" + id + " has been approved.");
        return "redirect:/leaves";
    }

    @PostMapping("/{id}/reject")
    public String rejectLeave(
            @PathVariable("id") Long id,
            @RequestParam(name = "notes", required = false, defaultValue = "Rejected") String notes,
            RedirectAttributes redirectAttributes) {

        leaveRequestService.rejectLeaveRequest(id, notes);
        redirectAttributes.addFlashAttribute("successMessage", "Leave request #" + id + " has been rejected.");
        return "redirect:/leaves";
    }
}
