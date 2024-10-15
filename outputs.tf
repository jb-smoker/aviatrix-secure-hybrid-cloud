output "aws_instance" {
  value       = aws_instance.this
  description = "AWS Instance and its attributes"
}

output "azure_instance" {
  value       = azurerm_linux_virtual_machine.this
  description = "Azure Instance and its attributes"
}

output "edge_test_instance_pip" {
  value       = module.edge_sv.test_vm_pip.address
  description = "Edge Public IP for the test VM"
}
