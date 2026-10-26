/**
 * Enterprise Portal Client-side Application Scripts
 */
document.addEventListener('DOMContentLoaded', () => {
    // Auto-dismiss alert banners after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(() => {
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-10px)';
                setTimeout(() => alert.remove(), 400);
            });
        }, 5000);
    }

    // Dynamic Leave Days Calculator
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const daysCountDisplay = document.getElementById('daysCountDisplay');

    function calculateLeaveDays() {
        if (startDateInput && endDateInput && startDateInput.value && endDateInput.value) {
            const start = new Date(startDateInput.value);
            const end = new Date(endDateInput.value);

            if (end >= start) {
                const diffTime = Math.abs(end - start);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
                if (daysCountDisplay) {
                    daysCountDisplay.textContent = diffDays + (diffDays === 1 ? ' day' : ' days');
                }
            } else if (daysCountDisplay) {
                daysCountDisplay.textContent = 'Invalid date range';
            }
        }
    }

    if (startDateInput && endDateInput) {
        startDateInput.addEventListener('change', calculateLeaveDays);
        endDateInput.addEventListener('change', calculateLeaveDays);
        calculateLeaveDays();
    }
});

/**
 * Confirm deletion action with safety dialog
 */
function confirmDelete(resourceName) {
    return confirm("Are you sure you want to permanently delete this " + resourceName + "? This action cannot be undone.");
}
