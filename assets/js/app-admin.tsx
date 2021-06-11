// import "phoenix_html"

const el = document.getElementById("add_receipt_item")!;
el.onclick = (e) => {
  e.preventDefault();
  const time = new Date().getTime();
  let template = el.getAttribute("data-template")!;
  var uniq_template = template.replace(/\[0]/g, `[${time}]`);
  uniq_template = uniq_template.replace(/\[0]/g, `_${time}_`);
  el.insertAdjacentHTML("afterend", uniq_template);
};

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
