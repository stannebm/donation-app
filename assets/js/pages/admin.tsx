// DEFAULT DOM FOR ALL PAGES

// ALERT MESSAGE
document.addEventListener("DOMContentLoaded", () => {
  (document.querySelectorAll(".notification .delete") || []).forEach(
    (deleteEl) => {
      if (deleteEl) {
        const notification = deleteEl.parentNode!;
        deleteEl.addEventListener("click", () => {
          notification.parentNode!.removeChild(notification);
        });
      }
    },
  );
});
