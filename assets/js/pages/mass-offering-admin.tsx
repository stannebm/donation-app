// MASS OFFERING (ADMIN)

// Adding the block of Offering
const addOffer = document.getElementById("add_offering")!;
addOffer.onclick = (e) => {
  e.preventDefault();
  const time = new Date().getTime();
  let template = addOffer.getAttribute("data-template")!;
  var uniq_template = template.replace(/\[0]/g, `[${time}]`);
  uniq_template = uniq_template.replace(/\[0]/g, `_${time}_`);
  addOffer.insertAdjacentHTML("afterend", uniq_template);
  insert_mass_language();
  init_array_date_input();
};

// Adding the block of Date
function init_array_date_input(){
  const dateInputSelector = document.querySelectorAll<HTMLElement>(".add-array-date-input");
  dateInputSelector.forEach((el: any) => {
    el.onclick = () => {
      const firstLI = el.closest(".box.content").querySelector("ul > li:first-child");
      let cloneLI = '<li>' + firstLI.innerHTML + '</li>';
      firstLI.insertAdjacentHTML("afterend", cloneLI);
      eachSelected(".remove-array-item", (el: any) => el.onclick = removeItem);
    }
  });
}
init_array_date_input();

// MASS OFFERING (ADMIN): massLanguage
function insert_mass_language(){
  let selectMassLanguage = (document.getElementById("contribution_massLanguage") as HTMLInputElement).value;
  let selectNestedMassLanguages = document.querySelectorAll<HTMLElement>(".node-mass-language");
  selectNestedMassLanguages.forEach((elm: any) => {
    elm.value = selectMassLanguage;
  });
}

function init_select_mass_language(){
  const selectMassLanguage = document.getElementById("contribution_massLanguage")!;
  selectMassLanguage.addEventListener('change', () => {
    insert_mass_language();
  });
  insert_mass_language();
}

init_select_mass_language();

// ADD or REMOVE DATES
window.onload = () => {
  eachSelected(".remove-array-item", (el: any) => el.onclick = removeItem);
}

const eachSelected = (selector: any, fn: any) => {
  Array.prototype.forEach.call(document.querySelectorAll(selector), fn);
}

const removeItem = (event: any) => {
  let li = event.target.parentNode;
  let ol = li.parentNode;
  ol.removeChild(li);
}
