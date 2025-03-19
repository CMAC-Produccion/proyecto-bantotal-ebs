import java.sql.*;

public class PruebaSolaris {
      public static void main(String args []) {
         
	System.out.println("pao");
      
        Connection con = null;

        //String conUrl = "jdbc:sqlserver://10.0.97.240:1433;databaseName=sigsretail;user=sa;password=bdconsejeros;";
        String conUrl = "jdbc:sqlserver://10.0.97.240:1433;databaseName=sigsretail;user=sa;password=bdconsejeros;";
        try
        { 
            System.out.println("entro al try");
            con = DriverManager.getConnection(conUrl);
            System.out.println("hizo con");
        }
        catch( Exception x ){
                 System.out.println("exception!");
                 System.out.println(x);
        } 
      }

}
