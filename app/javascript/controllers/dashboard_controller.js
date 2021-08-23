import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["tform", "transferType", "trans_type", "e_category", "i_category", "submit", "account_to", "account_from"]

    bankTransfer() {
        console.log("hello from bank transfer")
        this.tformTarget.classList.remove('d-none')
        this.transferTypeTarget.textContent = "Make a Bank Transfer"
        this.trans_typeTarget.placeholder = "Bank Transfer"

        this.trans_typeTarget.value = "bank_transfer"

        this.account_toTarget.classList.remove('d-none')
        this.account_fromTarget.classList.remove('d-none')

        this.e_categoryTarget.classList.add('d-none')
        this.i_categoryTarget.classList.add('d-none')
    }
    income() {
        console.log("hello from income")
        this.tformTarget.classList.remove('d-none')
        this.transferTypeTarget.textContent = "Add Income"

        this.trans_typeTarget.placeholder = "Income"
        this.trans_typeTarget.value = "income"

        this.account_toTarget.classList.add('d-none')

        this.e_categoryTarget.classList.add('d-none')

        this.i_categoryTarget.classList.remove('d-none')
    }
    expense() {
        console.log("hello from expense")
        this.tformTarget.classList.remove('d-none')
        this.transferTypeTarget.textContent = "Add Expense"
        this.trans_typeTarget.placeholder = "Expense"

        this.trans_typeTarget.value = "expense"

        this.account_toTarget.classList.add('d-none')

        this.e_categoryTarget.classList.remove('d-none')
        this.i_categoryTarget.classList.add('d-none')
    }

}