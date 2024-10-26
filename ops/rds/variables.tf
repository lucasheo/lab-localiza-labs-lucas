variable "tags" {}

variable "identifier" {
  description = "Identificao do nome do cluster"
  type        = string
  default     = "db-lab"
}

variable "character_set_client" {
  description = "Conjunto de caracteres para o cliente"
  type        = string
  default     = "utf8mb4"
}

variable "character_set_server" {
  description = "Conjunto de caracteres para o servidor"
  type        = string
  default     = "utf8mb4"
}

variable "server_plugin_events" {
  description = "Tipos de eventos que o plugin de auditoria deve monitorar (CONNECT, QUERY, etc.)"
  type        = string
  default     = "CONNECT"  
}

variable "server_file_rotations" {
  description = "Número de arquivos de log de auditoria a serem mantidos antes da rotação"
  type        = number
  default     = 37
}

variable "option_name" {
  description = "option_name"
  type        = string
  default     = "MARIADB_AUDIT_PLUGIN"  
}

variable "monitoring_interval" {
  description = "monitoring_interval"
  type        = number
  default     = "30"  
}

variable "monitoring_role_name" {
  description = "monitoring_role_name"
  type        = string
  default     = "MyRDSMonitoringRole"  
}

