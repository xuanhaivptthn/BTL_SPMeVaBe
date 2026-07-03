package model;

/**
 * Defines the role hierarchy for the application.
 *
 * Hierarchy (highest → lowest privilege):
 *   ADMIN  – full access (users, products, orders)
 *   STAFF  – limited admin access (products, orders only — cannot manage users)
 *   CUSTOMER – standard shop customer
 */
public enum Role {

    CUSTOMER,
    STAFF,
    ADMIN;

    /** Returns true if this role can enter the shared /admin/* area. */
    public boolean hasAdminAccess() {
        return this == ADMIN || this == STAFF;
    }

    /** Returns true if this role may manage user accounts. */
    public boolean canManageUsers() {
        return this == ADMIN;
    }

    /** Parse a role string safely; defaults to CUSTOMER on unknown values. */
    public static Role fromString(String value) {
        if (value == null) return CUSTOMER;
        try {
            return Role.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return CUSTOMER;
        }
    }
}
