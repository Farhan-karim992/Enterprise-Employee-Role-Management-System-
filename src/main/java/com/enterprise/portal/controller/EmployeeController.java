package com.enterprise.portal.controller;

import com.enterprise.portal.entity.Department;
import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.entity.EmployeeStatus;
import com.enterprise.portal.entity.Role;
import com.enterprise.portal.service.DepartmentService;
import com.enterprise.portal.service.EmployeeService;
import com.enterprise.portal.service.LeaveRequestService;
import com.enterprise.portal.service.RoleService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.List;

/**
 * Spring MVC Controller handling CRUD operations, search filters,
 * and data binding for Employee records.
 */
@Controller
@RequestMapping("/employees")
public class EmployeeController {

    private static final Logger logger = LoggerFactory.getLogger(EmployeeController.class);

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private RoleService roleService;

    @Autowired
    private LeaveRequestService leaveRequestService;

    @ModelAttribute("departmentsList")
    public List<Department> populateDepartments() {
        return departmentService.getAllDepartments();
    }

    @ModelAttribute("rolesList")
    public List<Role> populateRoles() {
        return roleService.getAllRoles();
    }

    @ModelAttribute("statusesList")
    public EmployeeStatus[] populateStatuses() {
        return EmployeeStatus.values();
    }

    /**
     * List employees with optional search keyword, department filter, and status filter.
     */
    @GetMapping
    public String listEmployees(
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam(name = "departmentId", required = false) Long departmentId,
            @RequestParam(name = "status", required = false) EmployeeStatus status,
            Model model) {

        List<Employee> employees = employeeService.searchEmployees(keyword, departmentId, status);
        model.addAttribute("employees", employees);
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedDeptId", departmentId);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("activeNav", "employees");
        return "employee/list";
    }

    /**
     * Display the employee registration form.
     */
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        Employee employee = new Employee();
        employee.setStatus(EmployeeStatus.ACTIVE);
        model.addAttribute("employee", employee);
        model.addAttribute("formAction", "new");
        model.addAttribute("pageTitle", "Register New Employee");
        model.addAttribute("activeNav", "employees");
        return "employee/form";
    }

    /**
     * Process employee save/update form submission with validation.
     */
    @PostMapping("/save")
    public String saveEmployee(
            @Valid @ModelAttribute("employee") Employee employee,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Validate email uniqueness
        if (!employeeService.isEmailUnique(employee.getId(), employee.getEmail())) {
            bindingResult.addError(new FieldError("employee", "email",
                    "Email address is already in use by another employee"));
        }

        if (bindingResult.hasErrors()) {
            logger.warn("Validation failed for employee form submission: {} errors", bindingResult.getErrorCount());
            model.addAttribute("formAction", employee.getId() == null ? "new" : "edit");
            model.addAttribute("pageTitle", employee.getId() == null ? "Register New Employee" : "Edit Employee Profile");
            model.addAttribute("activeNav", "employees");
            return "employee/form";
        }

        boolean isUpdate = employee.getId() != null;
        employeeService.saveOrUpdateEmployee(employee);

        String message = isUpdate 
                ? "Employee '" + employee.getFullName() + "' updated successfully."
                : "Employee '" + employee.getFullName() + "' registered successfully.";
        redirectAttributes.addFlashAttribute("successMessage", message);

        return "redirect:/employees";
    }

    /**
     * Display the employee edit form.
     */
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Employee employee = employeeService.getEmployeeById(id);
        model.addAttribute("employee", employee);
        model.addAttribute("formAction", "edit");
        model.addAttribute("pageTitle", "Edit Employee: " + employee.getFullName());
        model.addAttribute("activeNav", "employees");
        return "employee/form";
    }

    /**
     * Detailed Profile view including departmental hierarchy and leave history.
     */
    @GetMapping("/view/{id}")
    public String viewEmployee(@PathVariable("id") Long id, Model model) {
        Employee employee = employeeService.getEmployeeById(id);
        model.addAttribute("employee", employee);
        model.addAttribute("leaves", leaveRequestService.getLeavesByEmployeeId(id));
        model.addAttribute("activeNav", "employees");
        return "employee/view";
    }

    /**
     * Delete an employee record.
     */
    @GetMapping("/delete/{id}")
    public String deleteEmployee(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        Employee employee = employeeService.getEmployeeById(id);
        String name = employee.getFullName();
        employeeService.deleteEmployee(id);
        redirectAttributes.addFlashAttribute("successMessage", "Employee '" + name + "' was successfully removed.");
        return "redirect:/employees";
    }
}
