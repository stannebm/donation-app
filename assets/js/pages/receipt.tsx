// ONCLICK

const el = document.getElementById("add_receipt_item")!;
el.onclick = (e) => {
  e.preventDefault();
  const time = new Date().getTime();
  let template = el.getAttribute("data-template")!;
  var uniq_template = template.replace(/\[0]/g, `[${time}]`);
  uniq_template = uniq_template.replace(/\[0]/g, `_${time}_`);
  el.insertAdjacentHTML("afterend", uniq_template);
  init_select_contribution();
  // init_delete_input(); // Don't remove. I'll put back after solve.
};

// RECEIPT: SHOW/HIDE OTHERS

function show_others(selectContribution: any) {
  const contributionName =
    selectContribution.options[selectContribution.selectedIndex].text;
  const nodeOther = selectContribution
    .closest(".box.content")
    .querySelector(".node-other");
  if (contributionName == "Others") {
    nodeOther.style.display = "block";
  } else {
    nodeOther.style.display = "none";
  }
}

function init_select_contribution() {
  const selectContributions = document.querySelectorAll<HTMLElement>(
    ".select-contribution",
  );
  selectContributions.forEach((selectContribution) => {
    selectContribution.addEventListener("change", () => {
      show_others(selectContribution);
    });
    show_others(selectContribution);
  });
}

init_select_contribution();

// RECEIPT: SHOW/HIDE CHEQUE

function display_cheque(selectPaymentMethod: any) {
  const paymentMethodName =
    selectPaymentMethod.options[selectPaymentMethod.selectedIndex].text;
  const nodeCheque = document.querySelector<HTMLElement>(
    ".node-payment-method",
  )!;
  if (paymentMethodName == "Cheque") {
    nodeCheque.style.display = "block";
  } else {
    nodeCheque.style.display = "none";
  }
}

function display_transaction_date(selectPaymentMethod: any) {
  const paymentMethodName =
    selectPaymentMethod.options[selectPaymentMethod.selectedIndex].text;
  const nodeTransactionDate = document.querySelector<HTMLElement>(
    ".node-transaction-date",
  )!;
  if (paymentMethodName == "Online Transfer/Direct Deposit") {
    nodeTransactionDate.style.display = "block";
  } else {
    nodeTransactionDate.style.display = "none";
  }
}

const selectPaymentMethod = document.getElementById(
  "receipt_type_of_payment_method_id",
);
if (selectPaymentMethod !== null) {
  selectPaymentMethod.addEventListener("change", () => {
    display_cheque(selectPaymentMethod);
    display_transaction_date(selectPaymentMethod);
  });
  display_cheque(selectPaymentMethod);
  display_transaction_date(selectPaymentMethod);
}
