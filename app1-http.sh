

#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd.service
sudo service httpd start
sudo echo '<h1>welcome to terraform- APP-1</h1>' | sudo tee /var/www/html/index.html