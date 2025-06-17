# Terraform Environment Variables for key values
1. Edit the .env and either update or add the variables needed for Terraform.
Example: .env contains "TF_VAR_username=Bart".
NOTE: The variables should be in the format of "TF_VAR_<variable name>".  The TF_VAR_ tells Terraform to use it.
2. Update the main.tf or other Terraform files to use the variable.
Example: main.tf would use "var.username" and would get the value of Bart
3. Define the variables in the variables.tf
Example:
variable "username" {

description = "The username"

type = string

} 
4. 