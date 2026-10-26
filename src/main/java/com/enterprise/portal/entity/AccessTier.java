package com.enterprise.portal.entity;

public enum AccessTier {
    TIER_1_ADMIN("Tier 1: Full Administrator Access"),
    TIER_2_MANAGER("Tier 2: Department Manager Access"),
    TIER_3_STAFF("Tier 3: Standard Staff Access");

    private final String label;

    AccessTier(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
