package br.com.customer.aplicacao;

import java.util.Date;

import br.com.customer.model.customer;
import br.com.customer.dao.customerDAO;

public class Main {

	public static void main(String[] args) {
	
		customer client = new customer();
		client.setfirstname("Maria");
		client.setlastname("Gabriela");
		client.setAge(19);
		client.setBirthday(new Date());
		
		customerDAO.save(client);
	}
}
