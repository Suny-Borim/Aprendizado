package br.com.customer.factory;

import java.sql.Connection;
import java.sql.DriverManager;


public class ConnectionFactory {
	
	//nome do usuario 
	private static final String USERNAME = "root";
	
	//senha do banco
	private static final String PASSWORD = "root";
	
	//caminho do banco
	private static final String DATABASE_URL = "jdbc:mysql://localhost:3306/crud_ciee";
	
	public static Connection createConnectionToMySQL() throws Exception {
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		Connection connection = DriverManager.getConnection(DATABASE_URL,USERNAME,PASSWORD);
		
		return connection;
	}
	
	public static void main(String[] args) throws Exception {
		
		Connection con = createConnectionToMySQL();
		
		if(con != null) {
			System.out.println("Conxeão uwu");
			con.close();
		}
	}
}
