variable "region" {
  default     = "us-east-1"
  description = "Region of AWS"
}

variable "kubeconfig_path" {
    default   = "/home/angel/.kube/config"
}
