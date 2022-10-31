terraform {
 backend "gcs" {
   bucket  = "ca722bb262a23d93-bucket-tfstate" # storge bucket id
   prefix  = "terraform/state"
 }
}