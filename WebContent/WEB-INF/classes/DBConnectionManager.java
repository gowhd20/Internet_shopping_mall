import java.io.*;
import java.lang.*;
import java.sql.*;
import java.util.*;
import java.util.Date;

public class DBConnectionManager {

    static private DBConnectionManager instance;
    static private DBConnectionPool pool;

    private DBConnectionManager() {
        init();
    }
    
    private void init() {
        loadDrivers();
        createPools();
    }
    
    public void destroy() {
    }
    
    static synchronized public DBConnectionManager getInstance()     {
        
        if (instance == null) {
            instance = new DBConnectionManager();
        }
        return instance;
    }
    
    public void freeConnection(Connection con) {
        pool.freeConnection(con);
    }
    
    public Connection getConnection() {
        return pool.getConnection();
    }
    
    public synchronized void release() {
        pool.release();
    }

    private void createPools() {
		    String url = "jdbc:mysql://127.0.0.1:3306/디비네임";
			//String url = "jdbc:microsoft:sqlserver://127.0.0.1:1433;DatabaseName=prunus79";
            //String url = "jdbc:oracle:thin:@127.0.0.1:1521:poolpiri";
            String user = "아이디";
            String password = "패스워드";
			//String user = "scott";
            //String password = "tiger";
            pool =  new DBConnectionPool(url, user, password);
    }
     
    private void loadDrivers() {
        try {
			    Class.forName("org.gjt.mm.mysql.Driver").newInstance();
			    //Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
                //Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
        } catch (Exception e) {
                System.out.println("Can't register JDBC driver: " + e.getMessage());
        }
    }

//inner class

    class DBConnectionPool {

        private Vector freeConnections = new Vector();
        private String url;
        private String password;
        private String user;
	
        public DBConnectionPool(String url, String user, String password){
            this.url = url;
            this.user = user;
            this.password = password;
        }

        public synchronized void freeConnection(Connection con) {
            if (con != null) {
            	freeConnections.addElement(con);
                notifyAll();
            }
        }

        public synchronized Connection getConnection() {
            Connection con=null;
   
            if (freeConnections.size() > 0) {
                con = (Connection) freeConnections.firstElement();
            	freeConnections.removeElementAt(0);

    	        try {
                    if (con.isClosed()) {
                        con = getConnection();
                    }
        	    } catch (SQLException e) {
                    con = getConnection();
        	    }

            }else {
                con = newConnection();
            }
            return con;
        }//getconnection
        
        public synchronized void release() {
            Enumeration allConnections = freeConnections.elements();
            while (allConnections.hasMoreElements()) {
                Connection con = (Connection) allConnections.nextElement();
                try {
                    System.out.println("all connection close...");
                    con.close();
                } catch (SQLException e) {
                    System.out.println("Can't close connection for pool ");
                }
            }
            freeConnections.removeAllElements();
        }
        
        private Connection newConnection() {
         
            Connection con = null;
            
            try {
                 con = DriverManager.getConnection(url, user, password);
            } catch (SQLException e) {
                System.out.println("Can't create a new connection for " + url);
                return null;
            }
            return con;
        }
    }//inner class dbconnectionpool

}//class dbconnectionmanager

/*
String url="jdbc:microsoft:sqlserver://127.0.0.1:1433;DatabaseName=dsn_Teample";
String user="chansro";
String pwd="7777";
Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver")
Connection dbcon = DriverManager.getConnection(url, user, pwd);
Statement stat = dbconn.createStatement();
ResultSet rs = stat.executeUpdate("insert into QA .........................");
*/
