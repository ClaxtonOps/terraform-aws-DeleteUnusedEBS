variable "region" {
  type        = string
  description = "Region that will contain the resources. Example: 'us-east-1'"
}

variable "tag_environments" {
  type        = list(string)
  description = "List of permitted environments for the Lambda. The Lambda will delete any EBS not belonging to these environments. Example: ['Dev', 'Staging', 'Prod']"
}

variable "email" {
  description = "Email address to be notified in case of Lambda loading error. Example: paulo@gmail.com"
  type        = string

}


variable "trigger_cron" {
  type        = string
  description = "Time to trigger the Lambda by EventBridge. Example: cron(36 16 ? * * *)"
}

