output "profile_kernel" {
  value       = matchbox_profile.worker.kernel
  description = "Kernel path or URL of the worker's matchbox profile"
}
