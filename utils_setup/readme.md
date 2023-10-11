### DNS Setup 
>> To be done in Azure DNS under trainocate.cloud dns Account

* run create_dns_tc_log.sh to create child domain and 9 record set using appX prefix and 9 record for kubX prefix
    ```
    bash create_dns_tc_log.sh 52.163.84.37 stu01
    ```

* run update_dns_app_tc.sh to update the IP address for appX records
    ```
    bash update_dns_app_tc.sh 91.92.93.94 stu01
    ```

* run update_dns_kub_tc.sh to update the IP address for kubX records
    ```
    bash update_dns_kub_tc.sh 91.92.93.94 stu01
    ```
    >> This is needed because Kubernetes ingress/LB is part of lesson, until we reach that lesson, pip unknown


* run delete_dns_tc.sh to delete records 
    ```
    bash delete_dns_tc.sh stu01
    ```
