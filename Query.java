import java.util.Properties;
import java.util.Scanner;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

import java.io.FileInputStream;

/**
 * Runs queries against a back-end database
 */
public class Query {
	private static Properties configProps = new Properties();

  private Scanner sc;
	
	private static String PostgreSqlServerDriver;
	private static String PostgreSqlServerUrl;
	private static String PostgreSqlServerUser;
	private static String PostgreSqlServerPassword;
	private static String PostgreSqlServerSSL;



  private Connection _postgreSqlDB; 
  private DeleteUpdateInsertStatements _dui;


	private String _begin_transaction_read_write_sql = "START TRANSACTION";
	private PreparedStatement _begin_transaction_read_write_statement;

	private String _commit_transaction_sql = "COMMIT";
	private PreparedStatement _commit_transaction_statement;

	private String _rollback_transaction_sql = "ROLLBACK";
	private PreparedStatement _rollback_transaction_statement;
 
  /* created by me */
  
  //I don't think I can really do a prepared statement for insertion/updating/delete? 
  
  private String _compatability_check_sql = "Select case when exists(Select 1 from PCs p " + 
  "Join GPU g on p.gpu = g.part_id " + 
  "Join PC_Case c on p.pc_case = c.part_id " +
  "Join CPU cpu on p.cpu = cpu.part_id " +
  "Join Motherboard m on p.motherboard = m.part_id " + 
  "Join RAM r on p.ram_kit = r.part_id " + 
  "Join Cooler cl on p.cooler = cl.part_id Where g.length_mm <= c.max_gpu_size " +
  "And cpu.socket = m.socket And r.ram_type = m.ram_type And cl.socket_type Like '%' || cpu.socket || '%' And m.form_factor = c.form_factor And p.pc_id = ?) then 1 Else 0 End as pc_validity;";
  private PreparedStatement _compatability_check_statement;
  
  private String _users_complete_builds_sql = "Select distinct u.user_id from Users u join PCs p ON u.user_id = p.user_id where num_nonnulls(p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) = 7;";
  private PreparedStatement _users_complete_builds_statement;
  
  private String _user_favorite_part_list_sql = "Select sum(p.price) from Favorite_Parts fp join PC_Parts p on fp.part_id = p.part_id where fp.user_id = ?";
  private PreparedStatement _user_favorite_part_list_statement;
  
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
  
  private String _expensive_pc_sql = "Select p.pc_id, (gpu_part.price + cpu_part.price + psu_part.price + ram_part.price + mot_part.price + cas_part.price + coo_part.price) as total_build_price from PCs p " +
  "join PC_Parts gpu_part on p.gpu = gpu_part.part_id " + 
  "join PC_Parts cpu_part on p.cpu = cpu_part.part_id " + 
  "join PC_Parts psu_part on p.psu = psu_part.part_id " + 
  "join PC_Parts ram_part on p.ram_kit = ram_part.part_id " + 
  "join PC_Parts mot_part on p.motherboard = mot_part.part_id " + 
  "join PC_Parts cas_part on p.pc_case = cas_part.part_id " + 
  "join PC_Parts coo_part on p.cooler = coo_part.part_id " + 
  "where num_nonnulls(p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) = 7 " +
  "Order by total_build_price desc limit 1";
  private PreparedStatement _expensive_pc_statement;
  
  private String _users_no_pc_sql = "Select u.user_id from Users u left join PCs p ON u.user_id = p.user_id where p.user_id IS NULL";
  private PreparedStatement _users_no_pc_statement;
  
  private String _parts_price_range_sql = "Select part_id from PC_Parts where manufacturer = ? and price between ? and ?"; 
  private PreparedStatement _parts_price_range_statement;
  
  private String _parts_man_rate_price_sql = "Select pp.part_id, pp.name, pp.price, avg(pr.rating)::REAL as avg_rating " +
  "From PC_Parts pp Join GPU g on pp.part_id = g.part_id " +
  "Join Part_Review pr on pp.part_id = pr.part_id " +
  "Where pp.manufacturer = ? And pp.price < ? " +
  "Group by pp.part_id, pp.name, pp.price " +
  "Having avg(pr.rating) > ?;";
  private PreparedStatement _parts_man_rate_price_statement;
  
  private String _one_star_on_build_sql = "Select distinct p.pc_id, p.name as pc_name, pp.name as part_name, pr.comment, pr.rating, pr.review_time " +
  "From PCs p " +
  "Join Part_Review pr on pr.part_id in (p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) " +
  "Join PC_Parts pp on pr.part_id = pp.part_id " +
  "Where pr.rating = 1 and pr.review_time >= now() - interval '1 year' and p.pc_id = ? ";// +
  //"Order by pr.user_id desc;";
  private PreparedStatement _one_star_on_build_statement;
  
  private String _parts_since_date_sql = "Select pp.part_id, pp.manufacturer, pp.name, pp.release_date," +
  "avg(pr.rating)::REAL as avg_rating, count(pr.user_id) as popularity " +
  "From PC_Parts pp " +
  "Left join Part_Review pr on pp.part_id = pr.part_id " +
  "Where pp.release_date >= '2024-01-01' " +
  "Group by pp.part_id, pp.manufacturer, pp.name, pp.release_date Having avg(pr.rating) > 0 " +
  "Order by avg_rating desc, popularity desc; ";
  private PreparedStatement _parts_since_date_statement;
  
  private String _man_pop_by_user_sql = "Select count(distinct p.user_id) as user_count from PCs p " + 
  "join PC_Parts pp on pp.part_id in (p.cpu, p.psu, p.ram_kit, p.gpu, p.motherboard, p.pc_case, p.cooler) where pp.manufacturer = ?";
  private PreparedStatement _man_pop_by_user_statement;
  
  private String _part_by_rating_review_sql = "Select pp.part_id, pp.manufacturer, pp.name, avg(pr.rating)::REAL as avg_rating, count(pr.user_id) as review_count " +
  "From PC_Parts pp " +
  "Left join Part_Review pr on pp.part_id = pr.part_id " +
  "Group by pp.part_id, pp.manufacturer, pp.name Having avg(pr.rating) > 0 " +
  "Order by avg_rating desc, review_count desc; ";
  private PreparedStatement _part_by_rating_review_statement;

  public void setScanner(Scanner scanner) {
    this.sc = scanner;
  }

  // INSERT DELEGATION METHODS

  public void transaction_insert_user(String email, String username) throws Exception {
    _dui.transaction_insert_user(email, username);
  }

  public void transaction_insert_favorite(Integer user_id, Integer part_id) throws Exception {
    _dui.transaction_insert_favorite(user_id, part_id);
  }

  public void transaction_insert_review(Integer user_id, Integer part_id,
                                        Integer rating, String comment) throws Exception {
    _dui.transaction_insert_review(user_id, part_id, rating, comment);
  }

  // public void transaction_insert_pc_part(String manufacturer, String name,
  //                                     Float price, String description) throws Exception {
  //   _dui.transaction_insert_pc_part(manufacturer, name, price, description);
  // }

  public void transaction_insert_pc(String name, List<Integer> parts) throws Exception {
    _dui.transaction_insert_pc(name, parts);
  }


  // UPDATE DELEGATION METHODS

  public void transaction_update_user(Integer user_id,
                                      String email,
                                      String username) throws Exception {
    _dui.transaction_update_user(user_id, email, username);
  }

  public void transaction_update_favorite(Integer user_id,
                                          Integer old_part_id,
                                          Integer new_part_id) throws Exception {
    _dui.transaction_update_favorite(user_id, old_part_id, new_part_id);
  }

  public void transaction_update_review(Integer user_id,
                                        Integer part_id,
                                        Integer rating,
                                        String comment) throws Exception {
    _dui.transaction_update_review(user_id, part_id, rating, comment);
  }

  public void transaction_update_part(Integer part_id,
                                      String manufacturer,
                                      String name,
                                      Float price,
                                      String description) throws Exception {
    _dui.transaction_update_pc_part(part_id, manufacturer, name, price, description);
  }

  public void transaction_update_pc(Integer pc_id,
                                    String name,
                                    List<Integer> part_ids) throws Exception {
    _dui.transaction_update_pc(pc_id, name, part_ids);
  }


  // DELETE DELEGATION METHODS

  public void transaction_delete_user(Integer user_id) throws Exception {
    _dui.transaction_delete_user(user_id);
  }

  public void transaction_delete_pc_part(Integer part_id) throws Exception {
    _dui.transaction_delete_pc_part(part_id);
  }

  public void transaction_delete_pc(Integer pc_id) throws Exception {
    _dui.transaction_delete_pc(pc_id);
  }

  public void transaction_delete_favorite(Integer user_id,
                                          Integer part_id) throws Exception {
    _dui.transaction_delete_favorite(user_id, part_id);
  }

  public void transaction_delete_review(Integer user_id,
                                        Integer part_id) throws Exception {
    _dui.transaction_delete_review(user_id, part_id);
  }
 
	public Query() {
	}

    /**********************************************************/
    /* Connection to MySQL database */

	public void openConnections() throws Exception {
        
        /* open connections to TWO databases: movie and  customer databases */
        
		configProps.load(new FileInputStream("dbconn.config"));
        
        PostgreSqlServerDriver    = configProps.getProperty("PostgreSqlServerDriver");
        PostgreSqlServerUrl 	   = configProps.getProperty("PostgreSqlServerUrl");
        PostgreSqlServerUser 	   = configProps.getProperty("PostgreSqlServerUser");
        PostgreSqlServerPassword  = configProps.getProperty("PostgreSqlServerPassword");
     
        /* load jdbc driver for PostgreSQL */
        Class.forName(PostgreSqlServerDriver).getDeclaredConstructor().newInstance();
        
        String PostgreSqlConnectionString = PostgreSqlServerUrl+"?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory&user="+
        		PostgreSqlServerUser+"&password=" + PostgreSqlServerPassword;
        
        /* open a connection to your postgreSQL database that contains the customer database */
        _postgreSqlDB = DriverManager.getConnection(PostgreSqlConnectionString);

        _dui = new DeleteUpdateInsertStatements(_postgreSqlDB);
        		
	}

	public void closeConnections() throws Exception {
		
    _postgreSqlDB.close(); //note: shouldn't be necessary, leaving it in for the time being to test in case it screws something up
	}

    /**********************************************************/
    /* prepare all the SQL statements in this method.
      "preparing" a statement is almost like compiling it.  Note
       that the parameters (with ?) are still not filled in */

	public void prepareStatements() throws Exception {

		/* uncomment after you create your customers database */
		
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
   
	}


    /**********************************************************/
    /* suggested helper functions  */

    /**********************************************************/
    /* login transaction: invoked only once, when the app is started  */

    /**********************************************************/
    /* main functions in this project: */
    
  public void transaction_query(int num, String[] params) throws Exception {
    switch(num) {
      case 1:
        _compatability_check_statement.clearParameters();
        _compatability_check_statement.setInt(1, Integer.parseInt(params[0]));
        ResultSet compat_set = _compatability_check_statement.executeQuery();
		    while (compat_set.next()) {
          if (compat_set.getString(1).equals("1")) System.out.println("PC compatable");
          else System.out.println("PC incompatable");
          //System.out.println(compat_set.getString(1)); //note: this might output 1 or 0, not sure
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
          System.out.println("Favorite Part list price: " + list_set.getString(1));
        } 
        break;
      case 4:
        ResultSet old_set = _oldest_oldest_statement.executeQuery();
        while (old_set.next()) {
          System.out.println("User ID: " + old_set.getString(1) + "\tPart ID: " + old_set.getString(2) + "\tReview_Time: " +
            old_set.getString(3) + "\tRating: " + old_set.getString(4) + "\tComment: " + old_set.getString(5));
        }
        break;
      case 5:
        ResultSet build_set = _gpu_most_builds_statement.executeQuery();
        while (build_set.next()) {
          System.out.println("GPU ID: " + build_set.getString(1));
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
        _parts_price_range_statement.setFloat(2, Float.parseFloat(params[1]));
        _parts_price_range_statement.setFloat(3, Float.parseFloat(params[2]));
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
        _parts_man_rate_price_statement.setFloat(2, Float.parseFloat(params[1]));
        _parts_man_rate_price_statement.setFloat(3, Float.parseFloat(params[2]));
        ResultSet rate_set = _parts_man_rate_price_statement.executeQuery();
        while (rate_set.next()) {
         System.out.println("Part ID: " + rate_set.getString(1) + "\tPart name: " + rate_set.getString(2) + 
          "\tPrice: " + rate_set.getString(3) + "\tAverage Rating: " + rate_set.getString(4));
       }
        break;
      case 2:
        _one_star_on_build_statement.clearParameters();
        _one_star_on_build_statement.setInt(1, Integer.parseInt(params[0]));
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
        _man_pop_by_user_statement.clearParameters();
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
           "\tName: " + part_set.getString(3) + "\tAverage Rating: " + part_set.getString(4) + "\tReview count: " + part_set.getString(5));
        }
        break;
      default:
        System.out.println("Error: I have no idea how you got here, but you tried to select a query that doesn't exist");
        break;
      }
  }

  public Map<String, Object> get_typed_inputs(Map<String, Class<?>> schema) {
    Map<String, Object> responses = new LinkedHashMap<>();

    for (Map.Entry<String, Class<?>> entry : schema.entrySet()) {
      String fieldName = entry.getKey();
      Class<?> expectedType = entry.getValue();
      boolean isValid = false;

      while (!isValid) {
        System.out.print("Enter " + fieldName + ": ");
        String input = sc.nextLine().trim();

        if (expectedType == Integer.class) {
          // Check if it's only digits
          if (input.matches("\\d+")) {
            responses.put(fieldName, Integer.parseInt(input));
            isValid = true;
          } else {
            System.out.println("Invalid input. " + fieldName + " must be a whole number.");
          }
        } else if (expectedType == String.class) {
          if (!input.isEmpty()) {
            responses.put(fieldName, input);
            isValid = true;
          } else {
            System.out.println(fieldName + " cannot be empty.");
          }
        }
        else if (expectedType == Float.class) {
          if (input.matches("^[0-9]*\\.?[0-9]+$")) { // Regex for decimals
            responses.put(fieldName, Float.parseFloat(input));
            isValid = true;
          } else {
            System.out.println("Invalid input. " + fieldName + " must be a number (e.g. 19.99).");
          }
        }

      }
    }
    return responses;
  }
  
  public void transaction_insert_part(Integer n) throws Exception {
    Map<String, Class<?>> schema = new LinkedHashMap<>();
    Map<String, Object> results;

    // Start every schema with the common PC_Part fields
    schema.put("Manufacturer", String.class);
    schema.put("Name", String.class);
    schema.put("Price", Float.class);
    schema.put("Description", String.class);

    switch(n) {
      case 1: // CPU
      schema.put("Socket", String.class);
      schema.put("TDP", Integer.class);
      schema.put("Core Count", Integer.class);
      schema.put("Base Clock", Integer.class);
      schema.put("Thread Count", Integer.class);
      schema.put("Boost Clock", Integer.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_cpu(results);
      break;

      case 2: // GPU
      schema.put("VRAM", Integer.class);
      schema.put("Chipset", String.class);
      schema.put("Length (mm)", Integer.class);
      schema.put("Power Connectors", String.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_gpu(results);
      break;

      case 3: // RAM
      schema.put("RAM Type", String.class);
      schema.put("Number of Sticks", Integer.class);
      schema.put("Capacity", Integer.class);
      schema.put("Speed", Integer.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_ram(results);
      break;

      case 4: // PSU
      schema.put("Modular", String.class);
      schema.put("Wattage", Integer.class);
      schema.put("Efficiency", String.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_psu(results);
      break;

      case 5: // Case
      schema.put("Max GPU Size", Integer.class);
      schema.put("Form Factor", String.class);
      schema.put("Color", String.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_pc_case(results);
      break;

      case 6: // CPU Cooler
      schema.put("Cooler Type", String.class);
      schema.put("Socket Type", String.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_cooler(results);
      break;

      case 7: // Motherboard
      schema.put("Socket", String.class);
      schema.put("Chipset", String.class);
      schema.put("RAM Type", String.class);
      schema.put("Form Factor", String.class);
      schema.put("Max RAM", Integer.class);
      results = get_typed_inputs(schema);
      _dui.transaction_insert_mobo(results);
      break;

      default:
      System.out.println("Error: number not a valid part. Booting back to main loop.");
      break;
    }
  }
  
  public void transaction_update_part(Integer n) throws Exception {
    // 1. Get the ID of the part we want to update
    Map<String, Class<?>> idSchema = new LinkedHashMap<>();
    idSchema.put("Part ID", Integer.class);
    Map<String, Object> idResult = get_typed_inputs(idSchema);

    int part_id = (Integer) idResult.get("Part ID");
    
    // 2. Prepare schema for generic PC_Part info
    Map<String, Class<?>> genericSchema = new LinkedHashMap<>();
    genericSchema.put("Manufacturer", String.class);
    genericSchema.put("Name", String.class);
    genericSchema.put("Price", Float.class);
    genericSchema.put("Description", String.class);
    
    System.out.println("--- Updating Generic Part Information ---");
    Map<String, Object> genericResults = get_typed_inputs(genericSchema);

    // Execute the generic update first
    _dui.transaction_update_pc_part(part_id, genericResults);

    // 3. Prepare schema for specific hardware specs
    Map<String, Class<?>> specSchema = new LinkedHashMap<>();

    System.out.println("--- Updating Specific Hardware Specs ---");

    switch(n) {
      case 1: // CPU
        specSchema.put("Socket", String.class);
        specSchema.put("TDP", Integer.class);
        specSchema.put("Core Count", Integer.class);
        specSchema.put("Base Clock", Integer.class);
        specSchema.put("Thread Count", Integer.class);
        specSchema.put("Boost Clock", Integer.class);
        _dui.transaction_update_cpu(part_id, get_typed_inputs(specSchema));
        break;

      case 2: // GPU
        specSchema.put("VRAM", Integer.class);
        specSchema.put("Chipset", String.class);
        specSchema.put("Length (mm)", Integer.class);
        specSchema.put("Power Connectors", String.class);
        _dui.transaction_update_gpu(part_id, get_typed_inputs(specSchema));
        break;

      case 3: // RAM
        specSchema.put("RAM Type", String.class);
        specSchema.put("Number of Sticks", Integer.class);
        specSchema.put("Capacity", Integer.class);
        specSchema.put("Speed", Integer.class);
        _dui.transaction_update_ram(part_id, get_typed_inputs(specSchema));
        break;

      case 4: // PSU
        specSchema.put("Modular", String.class);
        specSchema.put("Wattage", Integer.class);
        specSchema.put("Efficiency", String.class);
        _dui.transaction_update_psu(part_id, get_typed_inputs(specSchema));
        break;

      case 5: // Case
        specSchema.put("Max GPU Size", Integer.class);
        specSchema.put("Form Factor", String.class);
        specSchema.put("Color", String.class);
        _dui.transaction_update_pc_case(part_id, get_typed_inputs(specSchema));
        break;

      case 6: // Cooler
        specSchema.put("Cooler Type", String.class);
        specSchema.put("Socket Type", String.class);
        _dui.transaction_update_cooler(part_id, get_typed_inputs(specSchema));
        break;

      case 7: // Motherboard
        specSchema.put("Socket", String.class);
        specSchema.put("Chipset", String.class);
        specSchema.put("RAM Type", String.class);
        specSchema.put("Form Factor", String.class);
        specSchema.put("Max RAM", Integer.class);
        _dui.transaction_update_mobo(part_id, get_typed_inputs(specSchema));
        break;

      default:
        System.out.println("Invalid part type selection.");
        break;
    }
  }
  
  public void transaction_delete(String statement) {
  
  }
    
    


}
