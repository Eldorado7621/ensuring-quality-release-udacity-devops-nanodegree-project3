resource "azurerm_network_interface" "proj3" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip}"
  }
}

resource "azurerm_linux_virtual_machine" "proj3" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_B1s"
  admin_username      = "sam"
  network_interface_ids = [azurerm_network_interface.test.id,]
  admin_ssh_key {
    username   = "sam"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJp9XnxNOg+Uq/lYi1nGlt7NnwaEQwQRB+GP7hAb3sQyFO7+8QIblFo0xyTnLqf1oZIVnW6tJp0ChXnYnCNwZyn6CE4uXLI/BAnEFo5dg3+sJvtxeSuTzRO2NDnMC54S7dTeRx+KYaV5Q3/OQYtg95OG19lMcr7Ay3H7WWKnBIyzJwFPidlRVHN9ksTghjBO02Ao8z+rdoZy4vv/aulg/xT0TawDgo6zoC5CD9i9PC39sae2Y2gItpLyEeQFW+RS71Sa1J9kJUzw5QEwWpTDnQ/qTQyQSXyL4aQf9R5MMqPxvQI0TkTykKeJWoPMzhZzIv3havgw7WkJU7WxV3s2hlzX5E0i3AHpBsa3w7JqGwjBK5bTvIk7a6bWrUZ+cs2ceerDFL/QQXhtgIcfm95yAkqX5tbtvA+HmGDlsJcy2hjFzO+ri3rjspShGbjgc9i3Usx1XrZ2v2fV3wflPrwbeWB341shWGEY41IVDfCp/yuVniKdYodNGf80oUveQM1D0= sam@sam-HP-Pavilion-Laptop-15-eg0xxx"
    #public_key = file(var.vm_public_key) 
     
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
