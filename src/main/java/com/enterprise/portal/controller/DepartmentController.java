package com.enterprise.portal.controller;

import com.enterprise.portal.entity.Department;
import com.enterprise.portal.entity.Employee;
import com.enterprise.portal.service.DepartmentService;
import com.enterprise.portal.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/departments")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public String listDepartments(Model model) {
        List<Department> departments = departmentService.getAllDepartmentsWithEmployees();
        model.addAttribute("departments", departments);
        model.addAttribute("activeNav", "departments");
        return "department/list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("department", new Department());
        model.addAttribute("formAction", "new");
        model.addAttribute("pageTitle", "Create Department");
        model.addAttribute("activeNav", "departments");
        return "department/form";
    }

    @PostMapping("/save")
    public String saveDepartment(
            @Valid @ModelAttribute("department") Department department,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (!departmentService.isCodeUnique(department.getId(), department.getCode())) {
            bindingResult.addError(new FieldError("department", "code",
                    "Department code already exists in the system"));
        }

        if (bindingResult.hasErrors()) {
            model.addAttribute("formAction", department.getId() == null ? "new" : "edit");
            model.addAttribute("pageTitle", department.getId() == null ? "Create Department" : "Edit Department");
            model.addAttribute("activeNav", "departments");
            return "department/form";
        }

        departmentService.saveOrUpdateDepartment(department);
        redirectAttributes.addFlashAttribute("successMessage",
                "Department '" + department.getName() + "' saved successfully.");
        return "redirect:/departments";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Department department = departmentService.getDepartmentById(id);
        model.addAttribute("department", department);
        model.addAttribute("formAction", "edit");
        model.addAttribute("pageTitle", "Edit Department: " + department.getName());
        model.addAttribute("activeNav", "departments");
        return "department/form";
    }

    @GetMapping("/view/{id}")
    public String viewDepartment(@PathVariable("id") Long id, Model model) {
        Department department = departmentService.getDepartmentById(id);
        List<Employee> staff = employeeService.searchEmployees(null, id, null);
        model.addAttribute("department", department);
        model.addAttribute("staffMembers", staff);
        model.addAttribute("activeNav", "departments");
        return "department/view";
    }

    @GetMapping("/delete/{id}")
    public String deleteDepartment(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        Department department = departmentService.getDepartmentById(id);
        String name = department.getName();
        departmentService.deleteDepartment(id);
        redirectAttributes.addFlashAttribute("successMessage", "Department '" + name + "' was deleted.");
        return "redirect:/departments";
    }
}
