import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["current_amount"]

    changeAmount() {
        document.getElementById('account_current_amount').value = 120000
    }
}