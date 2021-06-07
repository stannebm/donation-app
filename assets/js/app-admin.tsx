// import "phoenix_html"

var el = document.getElementById('add_receipt_item');
el.onclick = function(e){
  e.preventDefault()
  var el = document.getElementById('add_receipt_item');
  let time = new Date().getTime()
  let template = el.getAttribute('data-template')
  var uniq_template = template.replace(/\[0]/g, `[${time}]`)
  uniq_template = uniq_template.replace(/\[0]/g, `_${time}_`)
  this.insertAdjacentHTML('afterend', uniq_template)
};

// ALERT MESSAGE

document.addEventListener('DOMContentLoaded', () => {
  (document.querySelectorAll('.notification .delete') || []).forEach(($delete) => {
    const $notification = $delete.parentNode;

    $delete.addEventListener('click', () => {
      $notification.parentNode.removeChild($notification);
    });
  });
});