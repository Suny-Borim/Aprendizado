package br.com.customer.model;
import java.util.Date;
public class customer {

	private int id;
	private String firstname;
	private String lastname;
	private int age;
	private String email;
	private Date birthday;

	public int getId(){
		return this.id;
	}
	public void setId(int id){
		this.id = id;
	}
	public String getfirstname(){
		return this.firstname;
	}
	public void setfirstname(String firstname){
		this.firstname = firstname;
	}
	public String getlastname(){
		return this.lastname;
	}
	public void setlastname(String lastname){
		this.firstname = lastname;
	}
	public int getAge(){
		return this.age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getEmail() {
		return this.email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Date getBirthday() {
		return this.birthday;
	}
	public void setBirthday(Date Birthday) {
		this.birthday = Birthday;
	}

	
}
