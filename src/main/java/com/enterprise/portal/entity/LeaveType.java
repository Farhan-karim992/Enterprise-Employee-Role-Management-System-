package com.enterprise.portal.entity;

public enum LeaveType {
    ANNUAL("Annual Vacation"),
    SICK("Sick Leave"),
    CASUAL("Casual Leave"),
    MATERNITY("Maternity/Paternity"),
    UNPAID("Unpaid Sabbatical");

    private final String label;

    LeaveType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
