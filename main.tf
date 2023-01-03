#####
# Add DNS Name Server
#####

resource "citrixadc_dnsnameserver" "finish_dnsnameserver" {
    count     = length(var.adc-finish-dnsvserver.dnsvservername)
    dnsvservername = element(var.adc-finish-dnsvserver["dnsvservername"],count.index)
    type           = element(var.adc-finish-dnsvserver["type"],count.index)
}

#####
# Save config
#####

resource "citrixadc_nsconfig_save" "finish_save" {
  all        = true
  timestamp  = timestamp()

  depends_on = [
      citrixadc_dnsnameserver.finish_dnsnameserver
  ]
}

#####
# Wait for config save to commence properly, before allowing the subsequent module to run.
#####


resource "time_sleep" "finish_wait" {

  create_duration = "5s"

  depends_on = [
    citrixadc_nsconfig_save.finish_save
  ]

}