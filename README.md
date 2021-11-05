# Online store

## Resources 
 The original spring-boot application was inspired from here https://github.com/springframeworkguru/spring-boot-mysql-example 
### Steps to build locally 
1 - First, ensure to have Java JDK/JRE and maven installed on your local machine </br>
  a - install Java JDK by running the command `sudo apt install default-jdk -y`</br>
  b - install Java JRE by running the command `sudo apt install default-jre -y`</br>
  c - install maven bwith `sudo apt install maven -y`</br>
2 - Second, install and configure mysql </br>
  a - install from here https://linuxize.com/post/how-to-install-mysql-on-ubuntu-18-04/ </br>
  b - configure mysql by creating a user with `mysql_native_password` for the authentication method. You can take guidance from here https://linuxize.com/post/how-to-manage-mysql-databases-and-users-from-the-command-line/#create-a-new-mysql-user-account </br>
  c - create database for the application ( use the same guide above )</br>
  Note: all names and passwords must be updated in the `src/main/resources/application.properties` file </br>
3 - Build the jar file and run</br>
  a - Run the command `mvn clean install`. This will create a directory named `target`.</br>
  b - navigate to the `target` directory and run the jar file with `java -jar <file_name.jar>`</br>
