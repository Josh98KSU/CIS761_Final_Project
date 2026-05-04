import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.io.FileInputStream;

/**
 * Runs queries against a back-end database
 */
public class Query {
	private static Properties configProps = new Properties();

	private static String MySqlServerDriver; //note: shouldn't be necessary, leaving it in for the time being to test just in case it screws something up
	private static String MySqlServerUrl;
    private static String MySqlServerUser;
	private static String MySqlServerPassword;
	
	private static String PostgreSqlServerDriver;
	private static String PostgreSqlServerUrl;
	private static String PostgreSqlServerUser;
	private static String PostgreSqlServerPassword;
	private static String PostgreSqlServerSSL;


	// DB Connection
	private Connection _mySqlDB;
    private Connection _postgreSqlDB; //note: shouldn't be necessary, leaving it in for the time being to test in case it screws something up

	// Canned queries

	/*private String _search_sql = "SELECT * FROM movie_info WHERE movie_name like ? ORDER BY movie_id";
	private PreparedStatement _search_statement;

	private String _producer_id_sql = "SELECT y.* "
					 + "FROM producer_movies x, producer_ids y "
					 + "WHERE x.movie_id = ? and x.producer_id = y.producer_id";
	private PreparedStatement _producer_id_statement;*/

	/* uncomment, and edit, after your create your own customer database */
	/*private String _customer_login_sql = "SELECT * FROM customer WHERE login = ? and password = ?";
	private PreparedStatement _customer_login_statement;*/

	private String _begin_transaction_read_write_sql = "START TRANSACTION";
	private PreparedStatement _begin_transaction_read_write_statement;

	private String _commit_transaction_sql = "COMMIT";
	private PreparedStatement _commit_transaction_statement;

	private String _rollback_transaction_sql = "ROLLBACK";
	private PreparedStatement _rollback_transaction_statement;
 
  /* created by me */
  
  //I don't think I can really do a prepared statement for insertion/updating/delete? 
  
  private String _compatability_check_sql = "Select case when exists(Select 1 from PCs p" + 
  "Join GPU g on p.gpu = g.part_id" + 
  "Join PC_Case c on p.pc_case = c.part_id" +
  "Join CPU cpu on p.cpu = cpu.part_id" +
  "Join Motherboard m on p.motherboard = m.part_id" + 
  "Join RAM r on p.ram_kit = r.part_id" + 
  "Join Cooler cl on p.cooler = cl.part_id Where g.length_mm <= c.max_gpu_size" +
  "And cpu.socket = m.socket And r.ram_type = m.ram_type And cl.socket_type = cpu.socket And m.form_factor = c.form_factor And p.pc_id = ?) then 1 Else 0 End as pc_validity;";
  private PreparedStatement _compatability_check_statement;
  
  private String _users_complete_builds_sql = "Select u.user_id from Users u join PCs p ON u.user_id = p.user_id where num_nonnulls(p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) = 7;";
  private PreparedStatement _users_complete_builds_statement;
  
  private String _user_favorite_part_list_sql = "Select fp.part_id from Users u join Favorite_Parts fp on u.user_id = fp.user_id where u.user_id = ?";
  private PreparedStatement _user_favorite_part_list_statement;
  
  //private String _oldest_oldest_sql = "Select u.user_id from Users u join Part_Review r on u.user_id = r.user_id where u.created_on = min(u.created_on) AND min(r.timestamp)";
  private String _oldest_oldest_sql = "Select r.* from Part_Review r where r.user_id in (" +
  "select user_id from Users where created_on = (select min(created_on) from Users))" +
  "and r.review_time = (" +
  "select min(review_time) from Part_review where user_id in (select user_id from Users where created_on = (select min(created_on) from Users)));";
  private PreparedStatement _oldest_oldest_statement;
  
  private String _gpu_most_builds_sql = "Select count(*) as build_count from PCs group by GPU order by build_count desc limit 1 ";
  private PreparedStatement _gpu_most_builds_statement;
  
  private String _nvidia_gpu_count_sql = "Select count(p.gpu) from PCs p join PC_Parts pa on p.gpu = pa.part_id where manufacturer = 'NVIDIA'";
  private PreparedStatement _nvidia_gpu_count_statement;
  
  private String _gpu_below_avg_sql = "Select g.part_id from GPU g join PC_Parts p on g.part_id = p.part_id where p.price <= (Select avg(pa.price) from GPU gp join PC_Parts pa on gp.part_id = pa.part_id)";
  private PreparedStatement _gpu_below_avg_statement; 
  
  private String _expensive_pc_sql = "Select p.pc_id, (gpu_part.price + cpu_part.price + psu_part.price + ram_part.price + mot_part.price + cas_part.price + coo_part.price) as total_build_price from PCs p" +
  "join PC_Parts gpu_part on p.gpu = gpu_part.part_id" + 
  "join PC_Parts cpu_part on p.cpu = cpu_part.part_id" + 
  "join PC_Parts psu_part on p.psu = psu_part.part_id" + 
  "join PC_Parts ram_part on p.ram_kid = ram_part.part_id" + 
  "join PC_Parts mot_part on p.motherboard = mot_part.part_id" + 
  "join PC_Parts cas_part on p.pc_case = cas_part.part_id" + 
  "join PC_Parts coo_part on p.cooler = coo_part.part_id" + 
  "where num_nonulls(p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) = 7" +
  "Order by total_build_price desc limit 1";
  private PreparedStatement _expensive_pc_statement;
  
  private String _users_no_pc_sql = "Select u.user_id from Users u left join PCs p ON u.user_id = p.user_id where p.user_id IS NULL";
  private PreparedStatement _users_no_pc_statement;
  
  private String _parts_price_range_sql = "Select part_id from PC_Parts where manufacturer = ? and price between ? and ?"; 
  private PreparedStatement _parts_price_range_statement;
  
  private String _parts_man_rate_price_sql = "Select pp.part_id, pp.name, pp.price, avg(pp.rating) as avg_rating" +
  "From pc_parts pp Join gpu g on pp.part_id = g.part_id" +
  "Join part_review pr on pp.part_id = pr.part_id" +
  "Where pp.manufacturer = ? And pp.price < ?" +
  "Group by pp.part_id, pp.name, pp.price" +
  "Having avg(pr.rating) > ?;";
  private PreparedStatement _parts_man_rate_price_statement;
  
  private String _one_star_on_build_sql = "Select distinct p.pc_id, p.name as pc_name, pp.name as part_name, pr.comment, pr.rating, pr.timestamp" +
  "From PCs p" +
  "Join Part_Review pr on pr.part_id in (p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler)" +
  "Join PC_Parts pp on pr.part_id = pp.part_id" +
  "Where pr.rating = 1 and pr.timestamp >= now() - '1 day' and p.pc_id = [input id]" +
  "Order by pr.user_id desc;";
  private PreparedStatement _one_star_on_build_statement;
  
  private String _parts_since_date_sql = "Select pp.part_id, pp.manufacturer, pp.name, pp.release_date," +
  "avg(pr.rating) as avg_rating, count(pr.user_id) as popularity" +
  "From PC_Parts pp" +
  "Left join Part_Review pr on pp.part_id = pr.part_id" +
  "Where pp.release_date >= '2024-01-01'" +
  "Group by pp.part_id, pp.manufacturer, pp.name, pp.release_date" +
  "Order by avg_rating desc, popularity desc;";
  private PreparedStatement _parts_since_date_statement;
  
  private String _man_pop_by_user_sql = "Select count(distinct p.user_id) as user_count from PCs p" + 
  "join PC_Parts pp on pp.part_id in (p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) where pp.manufacturer = ?";
  private PreparedStatement _man_pop_by_user_statement;
  
  private String _part_by_rating_review_sql = "Select pp.part_id, pp.manufacturer, pp.name, avg(pr.rating) as avg_rating, count(pr.user_id) as review_count" +
  "From PC_Parts pp" +
  "Left join Part_Review pr on pp.part_id = pr.part_id" +
  "Group by pp.part_id, pp.manufacturer, pp.name" +
  "Order by avg_rating desc, review_count desc;";
  private PreparedStatement _part_by_rating_review_statement;
  
  /*private String _current_rentals_sql = "SELECT count(*) FROM rental WHERE cid = ? AND status = 'o'";
  private PreparedStatement _current_rentals_statement;
  
  private String _get_pid_sql = "SELECT pid FROM customer WHERE cid = ?";
  private PreparedStatement _get_pid_statement;
  
  private String _get_plan_rentals_sql = "SELECT max_rent FROM plan WHERE pid = ?";
  private PreparedStatement _get_plan_rentals_statement;
  
  private String _customer_name_sql = "SELECT first_name, last_name FROM customer WHERE cid = ?";
	private PreparedStatement _customer_name_statement;
 
  private String _return_sql = "UPDATE rental SET status = 'c' WHERE cid = ? AND mid = ?";
	private PreparedStatement _return_statement;
 
  private String _check_valid_movie_sql = "SELECT movie_id FROM movie_info WHERE movie_id = ?";
	private PreparedStatement _check_valid_movie_statement;
 
  private String _check_movie_rented_sql = "SELECT cid FROM rental WHERE mid = ? AND status = 'o'";
	private PreparedStatement _check_movie_rented_statement;
 
  private String _get_time_sql = "SELECT max(time) FROM rental WHERE cid = ? AND mid = ?";
	private PreparedStatement _get_time_statement;
 
  private String _rent_sql = "INSERT INTO rental (cid, mid, status, time) values (?, ?, 'o', ?)";
	private PreparedStatement _rent_statement;
 
  private String _plan_list_sql = "SELECT * FROM plan";
	private PreparedStatement _plan_list_statement;
 
  private String _check_plan_sql = "SELECT * FROM plan WHERE pid = ?";
	private PreparedStatement _check_plan_statement;
 
  private String _update_plan_sql = "UPDATE customer SET pid = ? WHERE cid = ?";
	private PreparedStatement _update_plan_statement;
  
  private String _actor_id_sql = "SELECT y.* "
					 + "FROM actor_movies x, actor_ids y "
					 + "WHERE x.movie_id = ? and x.actor_id = y.actor_id";
	private PreparedStatement _actor_id_statement;
 
  private String _fast_producer_id_sql = "SELECT m.movie_id, p.producer_name "
					 + "FROM movie_info m " 
           + "JOIN producer_movies x ON m.movie_id = x.movie_id "
           + "JOIN producer_ids p ON x.producer_id = p.producer_id "
					 + "WHERE movie_name like ? ORDER BY movie_id";
	private PreparedStatement _fast_producer_id_statement;
 
  private String _fast_actor_id_sql = "SELECT m.movie_id, a.actor_name "
					 + "FROM movie_info m " 
           + "JOIN actor_movies y ON m.movie_id = y.movie_id "
           + "JOIN actor_ids a ON y.actor_id = a.actor_id "
					 + "WHERE movie_name like ? ORDER BY movie_id";
	private PreparedStatement _fast_actor_id_statement; */
 
	public Query() {
	}

    /**********************************************************/
    /* Connection to MySQL database */

	public void openConnections() throws Exception {
        
        /* open connections to TWO databases: movie and  customer databases */
        
		configProps.load(new FileInputStream("dbconn.config"));
        
		MySqlServerDriver    = configProps.getProperty("MySqlServerDriver"); //note: shouldn't be necessary, leaving it in for the time being to test in case it screws something up
		MySqlServerUrl 	   = configProps.getProperty("MySqlServerUrl");
		MySqlServerUser 	   = configProps.getProperty("MySqlServerUser");
		MySqlServerPassword  = configProps.getProperty("MySqlServerPassword");
        
        PostgreSqlServerDriver    = configProps.getProperty("PostgreSqlServerDriver");
        PostgreSqlServerUrl 	   = configProps.getProperty("PostgreSqlServerUrl");
        PostgreSqlServerUser 	   = configProps.getProperty("PostgreSqlServerUser");
        PostgreSqlServerPassword  = configProps.getProperty("PostgreSqlServerPassword");
                              
		/* load jdbc driver for MySQL */
		Class.forName(MySqlServerDriver).getDeclaredConstructor().newInstance(); //note: shouldn't be necessary, leaving it in for the time being to test in case it screws something up

		/* open a connection to your mySQL database that contains the movie database */
		_mySqlDB = DriverManager.getConnection(MySqlServerUrl, // database
				MySqlServerUser, // user
				MySqlServerPassword); // password
		
		//_postgreSqlDB = DriverManager.getConnection(PostgreSqlServerUrl);
     
        /* load jdbc driver for PostgreSQL */
        Class.forName(PostgreSqlServerDriver).getDeclaredConstructor().newInstance();
        
        String PostgreSqlConnectionString = PostgreSqlServerUrl+"?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&user="+
        		PostgreSqlServerUser+"&password=" + PostgreSqlServerPassword;
        
        
        /* open a connection to your postgreSQL database that contains the customer database */
        _postgreSqlDB = DriverManager.getConnection(PostgreSqlConnectionString);
        		
        		//DriverManager.getConnection(PostgreSqlServerUrl, // database
                                              // PostgreSqlServerUser, // user
                                              // PostgreSqlServerPassword); // password
	
	}

	public void closeConnections() throws Exception {
		_mySqlDB.close();
       // _postgreSqlDB.close(); //note: shouldn't be necessary, leaving it in for the time being to test in case it screws something up
	}

    /**********************************************************/
    /* prepare all the SQL statements in this method.
      "preparing" a statement is almost like compiling it.  Note
       that the parameters (with ?) are still not filled in */

	public void prepareStatements() throws Exception {

		/*_search_statement = _mySqlDB.prepareStatement(_search_sql);
		_producer_id_statement = _mySqlDB.prepareStatement(_producer_id_sql);*/

		/* uncomment after you create your customers database */
		
		//_customer_login_statement = _postgreSqlDB.prepareStatement(_customer_login_sql);
		_begin_transaction_read_write_statement = _postgreSqlDB.prepareStatement(_begin_transaction_read_write_sql);
		_commit_transaction_statement = _postgreSqlDB.prepareStatement(_commit_transaction_sql);
		_rollback_transaction_statement = _postgreSqlDB.prepareStatement(_rollback_transaction_sql);
		 

		/* add here more prepare statements for all the other queries you need */
		/* . . . . . . */
   
   _compatability_check_statement = _postgreSqlDB.prepareStatement(_compatability_check_sql);
   _users_complete_builds_statement = _postgreSqlDB.prepareStatement(_users_complete_builds_sql);
   _user_favorite_part_list_statement = _postgreSqlDB.prepareStatement(_user_favorite_part_list_sql);
   _oldest_oldest_statement = _postgreSqlDB.prepareStatement(_oldest_oldest_sql);
   _gpu_most_builds_statement = _postgreSqlDB.prepareStatement(_gpu_most_builds_sql);
   _nvidia_gpu_count_statement = _postgreSqlDB.prepareStatement(_nvidia_gpu_count_sql);
   _gpu_below_avg_statement = _postgreSqlDB.prepareStatement(_gpu_below_avg_sql);
   _expensive_pc_statement = _postgreSqlDB.prepareStatement(_expensive_pc_sql);
   _users_no_pc_statement = _postgreSqlDB.prepareStatement(_users_no_pc_sql);
   _parts_price_range_statement = _postgreSqlDB.prepareStatement(_parts_price_range_sql);
   
   _parts_man_rate_price_statement = _postgreSqlDB.prepareStatement(_parts_man_rate_price_sql);
   _one_star_on_build_statement = _postgreSqlDB.prepareStatement(_one_star_on_build_sql);
   _parts_since_date_statement = _postgreSqlDB.prepareStatement(_parts_since_date_sql);
   _man_pop_by_user_statement = _postgreSqlDB.prepareStatement(_man_pop_by_user_sql);
   _part_by_rating_review_statement = _postgreSqlDB.prepareStatement(_part_by_rating_review_sql);
   
   /*_current_rentals_statement = _postgreSqlDB.prepareStatement(_current_rentals_sql);
   _get_pid_statement =  _postgreSqlDB.prepareStatement(_get_pid_sql);
   _get_plan_rentals_statement =  _postgreSqlDB.prepareStatement(_get_plan_rentals_sql);
   
   _customer_name_statement = _postgreSqlDB.prepareStatement(_customer_name_sql);
   
   _return_statement = _postgreSqlDB.prepareStatement(_return_sql);
   
   _check_valid_movie_statement = _mySqlDB.prepareStatement(_check_valid_movie_sql);
   _check_movie_rented_statement = _postgreSqlDB.prepareStatement(_check_movie_rented_sql);
   
   _get_time_statement = _postgreSqlDB.prepareStatement(_get_time_sql);
   _rent_statement = _postgreSqlDB.prepareStatement(_rent_sql);
   
   _check_plan_statement = _postgreSqlDB.prepareStatement(_check_plan_sql);
   _plan_list_statement = _postgreSqlDB.prepareStatement(_plan_list_sql);
   
   _update_plan_statement = _postgreSqlDB.prepareStatement(_update_plan_sql);
   
   _actor_id_statement = _mySqlDB.prepareStatement(_actor_id_sql);
   
   _fast_producer_id_statement = _mySqlDB.prepareStatement(_fast_producer_id_sql);
   _fast_actor_id_statement = _mySqlDB.prepareStatement(_fast_actor_id_sql);*/
	}


    /**********************************************************/
    /* suggested helper functions  */

	//public int helper_compute_remaining_rentals(int cid) throws Exception {
		/* how many movies can she/he still rent ? */
		/* you have to compute and return the difference between the customer's plan
		   and the count of outstanding rentals */
    /*int current_rent = 0;
    int pid = 0;
    int plan_rentals = 0;
          
    _current_rentals_statement.clearParameters();
    _current_rentals_statement.setInt(1, cid);
    ResultSet cur_set = _current_rentals_statement.executeQuery();
    if (cur_set.next()) {
      current_rent = cur_set.getInt(1);
    }
    
    _get_pid_statement.clearParameters();
    _get_pid_statement.setInt(1, cid);
    ResultSet pid_set = _get_pid_statement.executeQuery();
    if (pid_set.next()) {
      pid = pid_set.getInt(1);
    }
    
    _get_plan_rentals_statement.clearParameters();
    _get_plan_rentals_statement.setInt(1, pid);
    ResultSet plan_set = _get_plan_rentals_statement.executeQuery();
    if (plan_set.next()) {
      plan_rentals = plan_set.getInt(1);
    }
    
		return (plan_rentals - current_rent);
	}*/

	//public String helper_compute_customer_name(int cid) throws Exception {
		/* you find  the name of the current customer */
   /*String name = "";
   
   _customer_name_statement.clearParameters();
   _customer_name_statement.setInt(1, cid);
   ResultSet name_set = _customer_name_statement.executeQuery();
     if (name_set.next()) { 
       String first_name = name_set.getString(1);
       String last_name = name_set.getString(2);
       name = first_name + " " + last_name;
     }
		return (name);

	}*/

	//public boolean helper_check_plan(int plan_id) throws Exception {
		/* is plan_id a valid plan id?  you have to figure out */
   /*_check_plan_statement.clearParameters();
   _check_plan_statement.setInt(1, plan_id);
   ResultSet check_plan_set = _check_plan_statement.executeQuery();
   if (check_plan_set.next()) return true;
   else return false;
	}*/

	//public boolean helper_check_movie(String movie_id) throws Exception {
		/* is movie_id a valid movie id? you have to figure out  */
   
   /*_check_valid_movie_statement.clearParameters();
   _check_valid_movie_statement.setString(1, movie_id);
   ResultSet valid_set = _check_valid_movie_statement.executeQuery();
   if (valid_set.next()) return true;
   else return false;
	}*/

	//private int helper_who_has_this_movie(String movie_id) throws Exception {
		/* find the customer id (cid) of whoever currently rents the movie movie_id; return -1 if none */
		/*_check_movie_rented_statement.clearParameters();
    _check_movie_rented_statement.setString(1, movie_id);
    ResultSet who_rents_set = _check_movie_rented_statement.executeQuery();
    if (who_rents_set.next()) return (who_rents_set.getInt(1));
    else return (-1);
	}*/

    /**********************************************************/
    /* login transaction: invoked only once, when the app is started  */
	//public int transaction_login(String name, String password) throws Exception {
	/* authenticates the user, and returns the user id, or -1 if authentication fails */

		/* Uncomment after you create your own customers database */
		
		/*int cid;

		_customer_login_statement.clearParameters();
		_customer_login_statement.setString(1,name);
		_customer_login_statement.setString(2,password);
	    ResultSet cid_set = _customer_login_statement.executeQuery();
	    if (cid_set.next()) cid = cid_set.getInt(1);
		else cid = -1;
		return(cid);
		 
		//return (55); //comment after you create your own customers database
	}*/

	//public void transaction_personal_data(int cid) throws Exception {
		/* println the customer's personal data: name and number of remaining rentals */
   /*String cus_name = helper_compute_customer_name(cid);
   int can_rent = helper_compute_remaining_rentals(cid);
   System.out.println("Customer name: " + cus_name); 
   System.out.println("You can rent " + can_rent + " more movies");
   
	}*/


    /**********************************************************/
    
  public void transaction_query(int num, String[] params) throws Exception {
    switch(num) {
      case 1:
        _compatability_check_statement.clearParameters();
        _compatability_check_statement.setString(1, params[0]);
        ResultSet compat_set = _compatability_check_statement.executeQuery();
		    while (compat_set.next()) {
          System.out.println(compat_set.getString(1)); //note: this might output 1 or 0, not sure
        }
        break;
      case 2:
        ResultSet complet_set = _users_complete_builds_statement.executeQuery();
        while (complet_set.next()) {
          System.out.println("User ID: " + complet_set.getString(1));
        }
        break;
      case 3:
        _user_favorite_part_list_statement.clearParameters();
        _user_favorite_part_list_statement.setInt(1, Integer.parseInt(params[0]));
        ResultSet list_set = _user_favorite_part_list_statement.executeQuery();
        while (list_set.next()) {
          System.out.println("Part ID: " + list_set.getString(1));
        } 
        break;
      case 4:
        ResultSet old_set = _oldest_oldest_statement.executeQuery();
        while (old_set.next()) {
          System.out.println("User ID: " + old_set.getString(1));
        }
        break;
      case 5:
        ResultSet build_set = _gpu_most_builds_statement.executeQuery();
        while (build_set.next()) {
          System.out.println("GPU: " + build_set.getString(1));
        }
        break;
      case 6:
        ResultSet nvidia_set = _nvidia_gpu_count_statement.executeQuery();
        while (nvidia_set.next()) {
          System.out.println("NVIDIA GPU Count: " + nvidia_set.getString(1));
        }
        break;
      case 7:
        ResultSet avg_set = _gpu_below_avg_statement.executeQuery();
        while (avg_set.next()) {
          System.out.println("GPU: " + avg_set.getString(1)); 
        }
        break;
      case 8:
        ResultSet expensive_set = _expensive_pc_statement.executeQuery();
        while (expensive_set.next()) {
          System.out.println("PC ID: " + expensive_set.getString(1) + "\tPrice: " + expensive_set.getString(2));
        }
        break;
      case 9:
        ResultSet no_pc_set = _users_no_pc_statement.executeQuery();
        while (no_pc_set.next()) {
          System.out.println("User ID: " + no_pc_set.getString(1));
        }
        break;
      case 10:
        _parts_price_range_statement.clearParameters();
        _parts_price_range_statement.setString(1, params[0]);
        _parts_price_range_statement.setString(2, params[1]);
        _parts_price_range_statement.setString(3, params[2]);
        ResultSet price_set = _parts_price_range_statement.executeQuery();
		    while (price_set.next()) {
          System.out.println("Part ID:" + price_set.getString(1)); //note: this might output 1 or 0, not sure
        }
        break;
      default:
        System.out.println("Error: I have no idea how you got here, but you tried to select a query that doesn't exist");
        break;
    }
  }
  
  public void transaction_report(int num, String[] params) throws Exception {
    switch(num) {
      case 1:
        _parts_man_rate_price_statement.clearParameters();
        _parts_man_rate_price_statement.setString(1, params[0]);
        _parts_man_rate_price_statement.setString(2, params[1]);
        _parts_man_rate_price_statement.setString(3, params[2]);
        ResultSet rate_set = _parts_man_rate_price_statement.executeQuery();
        while (rate_set.next()) {
         System.out.println("Part ID: " + rate_set.getString(1) + "\tPart name: " + rate_set.getString(2) + 
           "\tPrice: " + rate_set.getString(3) + "\tAverage Rating: " + rate_set.getString(4));
       }
        break;
      case 2:
        _one_star_on_build_statement.setString(1, params[0]);
        ResultSet one_set = _one_star_on_build_statement.executeQuery();
        while (one_set.next()) {
         System.out.println("PC ID: " + one_set.getString(1) + "\tPC Name: " + one_set.getString(2) + "\tPart name: " + one_set.getString(3) + 
           "\tComment: " + one_set.getString(4) + "\tRating: " + one_set.getString(5) + "\tTimestamp: " + one_set.getString(6));
        }
        break;
      case 3:
       ResultSet date_set = _parts_since_date_statement.executeQuery();
       while (date_set.next()) {
         System.out.println("Part ID: " + date_set.getString(1) + "\tManufacturer: " + date_set.getString(2) + "\tPart name: " + 
           date_set.getString(3) + "\tRelease date: " + date_set.getString(4) + "\tAverage Rating: " + date_set.getString(5) + "\tUser count: " + date_set.getString(6));
       }
       break;
      case 4:
        _man_pop_by_user_statement.setString(1, params[0]);
        ResultSet pop_set = _man_pop_by_user_statement.executeQuery();
        while (pop_set.next()) {
         System.out.println("User count: " + pop_set.getString(1));
        }
        break;
      case 5:
        ResultSet part_set = _part_by_rating_review_statement.executeQuery();
        while (part_set.next()) {
         System.out.println("Part ID: " + part_set.getString(1) + "\tManufacturer: " + part_set.getString(2) + 
           "\tAverage Rating: " + part_set.getString(3) + "\tReview count: " + part_set.getString(4));
        }
        break;
      default:
        System.out.println("Error: I have no idea how you got here, but you tried to select a query that doesn't exist");
        break;
      }
  }
  
  public void transaction_insert(String statement) {
  
  }
  
  public void transaction_update(String statement) {
  
  }
  
  public void transaction_delete(String statement) {
  
  }
    
    /* main functions in this project: */

	//public void transaction_search(int cid, String movie_name)
	//		throws Exception {
		/* searches for movies with matching names: SELECT * FROM movie WHERE movie_name LIKE name */
		/* prints the movies, producers, actors, and the availability status:
		   AVAILABLE, or UNAVAILABLE, or YOU CURRENTLY RENT IT */

		/* set the first (and single) '?' parameter */
		/*_search_statement.clearParameters();
		_search_statement.setString(1, '%' + movie_name + '%');

		ResultSet movie_set = _search_statement.executeQuery();
		while (movie_set.next()) {
			String movie_id = movie_set.getString(1);
			System.out.println("ID: " + movie_id + " NAME: "
					+ movie_set.getString(2) + " YEAR: "
					+ movie_set.getString(3) + " RATING: "
					+ movie_set.getString(4));(/
			/* do a dependent join with producer */
			/*_producer_id_statement.clearParameters();
			_producer_id_statement.setString(1, movie_id);
			ResultSet producer_set = _producer_id_statement.executeQuery();
			while (producer_set.next()) {
				System.out.println("\t\tProducer name: " + producer_set.getString(2));
			}
			producer_set.close();*/
			/* now you need to retrieve the actors, in the same manner */
			/* then you have to find the status: of "AVAILABLE" "YOU HAVE IT", "UNAVAILABLE" */
      /*_actor_id_statement.clearParameters();
      _actor_id_statement.setString(1, movie_id);
      ResultSet actor_set = _actor_id_statement.executeQuery();
      while (actor_set.next()) {
        System.out.println("\t\tActor name: " + actor_set.getString(2));
      }
      actor_set.close();
      
      int renter_id = helper_who_has_this_movie(movie_id);
      if (renter_id == -1) System.out.println("AVAILABLE");
      else if (renter_id == cid) System.out.println("YOU HAVE IT");
      else System.out.println("UNAVAILABLE");
		}
		System.out.println();
	}*/

	//public void transaction_choose_plan(int cid, int pid) throws Exception {
	    /* updates the customer's plan to pid: UPDATE customer SET plid = pid */
	    /* remember to enforce consistency ! */
     /*_begin_transaction_read_write_statement.executeUpdate();
     try {
     
       if (helper_check_plan(pid) == false) System.out.println("Error: Plan ID invalid.");
       else {
         
         int can_rent = 0;
         _current_rentals_statement.clearParameters();
         _current_rentals_statement.setInt(1, cid);
         ResultSet cur_set = _current_rentals_statement.executeQuery();
         if (cur_set.next()) {
           can_rent = cur_set.getInt(1);
         }
         
         int new_rent = -1;
         _get_plan_rentals_statement.clearParameters();
         _get_plan_rentals_statement.setInt(1, pid);
         ResultSet plan_set = _get_plan_rentals_statement.executeQuery();
         if (plan_set.next()) {
           new_rent = plan_set.getInt(1);
         }
         
         if (new_rent >= can_rent) {
           _update_plan_statement.clearParameters();
           _update_plan_statement.setInt(1, pid);
           _update_plan_statement.setInt(2, cid);
           _update_plan_statement.executeUpdate();
           System.out.println("Plan switched!");
         }
         else System.out.println("Error: You would be over your rent cap on this plan.");
       
       }
       _commit_transaction_statement.executeUpdate();
     }
     catch (Exception e) {
       _rollback_transaction_statement.executeUpdate();
       throw e;
     }
	}*/

	//public void transaction_list_plans() throws Exception {
	    /* println all available plans: SELECT * FROM plan */
         /*ResultSet plan_list_set = _plan_list_statement.executeQuery();
         while (plan_list_set.next()) {
           System.out.println("Plan ID: " + plan_list_set.getInt(1));
           System.out.println("Plan name: " + plan_list_set.getString(2));
           System.out.println("Plan rentals: " + plan_list_set.getInt(3)); 
           System.out.println("Plan cost: " + plan_list_set.getFloat(4)); //might be getBigDecimal?  
           System.out.println("~");
         }
         System.out.println("Those are all available plans.");
	}*/

	//public void transaction_rent(int cid, String movie_id) throws Exception {
	    /* rend the movie movie_id to the customer cid */
	    /* remember to enforce consistency ! */
     /*_begin_transaction_read_write_statement.executeUpdate();
     
     try {
       if (helper_compute_remaining_rentals(cid) == 0) {
         System.out.println("You cannot rent any more movies.");
       }
       else if (helper_check_movie(movie_id) == false) {
         System.out.println("Error: movie_id invalid.");
       }
       else if (helper_who_has_this_movie(movie_id) != -1) {
         System.out.println("Someone else has this movie.");
       }
       else {
         //rent
         int next_time = 0;
         
         _get_time_statement.clearParameters();
         _get_time_statement.setInt(1, cid);
         _get_time_statement.setString(2, movie_id);
         
         ResultSet time_set = _get_time_statement.executeQuery();
         if (time_set.next()) next_time = time_set.getInt(1);
         next_time++;
         
         _rent_statement.clearParameters();
         _rent_statement.setInt(1, cid);
         _rent_statement.setString(2, movie_id);
         _rent_statement.setInt(3, next_time);
         _rent_statement.executeUpdate();
       }
       _commit_transaction_statement.executeUpdate();
     }
     catch(Exception e) {
       _rollback_transaction_statement.executeUpdate();
       throw e;
     }
	}*/

	//public void transaction_return(int cid, String movie_id) throws Exception {
	    /* return the movie_id by the customer cid */
     /*_return_statement.clearParameters();
     _return_statement.setInt(1, cid);
     _return_statement.setString(2, movie_id);
     _return_statement.executeUpdate();
	}*/

	//public void transaction_fast_search(int cid, String movie_name)
		//	throws Exception {
		/* like transaction_search, but uses joins instead of dependent joins
		   Needs to run three SQL queries: (a) movies, (b) movies join producers, (c) movies join actors
		   Answers are sorted by movie_id.
		   Then merge-joins the three answer sets */
       //I'm pretty sure this is just saying to make a big query
       
     /*_search_statement.clearParameters();
     _search_statement.setString(1, '%' + movie_name + '%');
     ResultSet movie_set = _search_statement.executeQuery();
     
     _fast_producer_id_statement.clearParameters();
     _fast_producer_id_statement.setString(1, '%' + movie_name + '%');
     ResultSet producer_set = _fast_producer_id_statement.executeQuery();
     
     _fast_actor_id_statement.clearParameters();
     _fast_actor_id_statement.setString(1, '%' + movie_name + '%');
     ResultSet actor_set = _fast_actor_id_statement.executeQuery();
     
     boolean next_prod = producer_set.next();
     boolean next_act = actor_set.next();
     
     
     while (movie_set.next()) {
       String movie_id = movie_set.getString(1);
			 System.out.println("ID: " + movie_id + " NAME: "
					+ movie_set.getString(2) + " YEAR: "
					+ movie_set.getString(3) + " RATING: "
					+ movie_set.getString(4));
      String prod_check = movie_id;
      String act_check = movie_id;

      while (next_prod && prod_check.equals(movie_id)) {

         System.out.println("\t\tProducer name: " + producer_set.getString(2));
         next_prod = producer_set.next();
          if (next_prod) prod_check = producer_set.getString(1);
        
      }
      
      while (next_act && act_check.equals(movie_id)) {

         System.out.println("\t\tActor name: " + actor_set.getString(2));
         next_act = actor_set.next();
         if (next_act) act_check = actor_set.getString(1);
        
      }
      
     }
     System.out.println();
	}*/

}
