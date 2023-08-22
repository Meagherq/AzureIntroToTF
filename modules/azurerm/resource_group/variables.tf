variable "name" {}
variable "location" {
    type = string
    description = "Azure Region"
    validation {
        condition = contains(["eastus", "eastus2"], var.location)
        error_message = "Valid value is one of the following: eastus, eastus2."
    }
}
variable owner {}
variable department {}