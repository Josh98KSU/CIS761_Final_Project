import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.StringTokenizer;

public class SQLassign {

	public static void usage() {
		/* prints the choices for commands and parameters */
		System.out.println("\n *** Please enter one of the following commands *** ");
		/*System.out.println("> search <movie title>");
		System.out.println("> plan [<plan id>]");
		System.out.println("> rent <movie id>");
		System.out.println("> return <movie id>");
		System.out.println("> fastsearch <movie title>");
		System.out.println("> quit");*/
    System.out.println("> insert entry (i)");
    System.out.println("> update entry (u)");
    System.out.println("> delete entry (d)");
    System.out.println("> view queries and reports (v)");
    System.out.println("> quit (quit)");
	}

	public static void menu(int cid, Query q) {
		/* cid = customer id (obtained from the command line) */

		/* prepare to read the user's command and parameter(s) */
		String response = null;

		while (true) {

			try {

				usage();

				BufferedReader r = new BufferedReader(new InputStreamReader(
						System.in));
				/* before prompting the user, tell her/him how many movies he can still rent */
        
        //NOTE: WILL NEED TO CHANGE THESE
        
        
				//q.transaction_personal_data(cid); 
				//System.out.print("> ");

				response = r.readLine();

				StringTokenizer st = new StringTokenizer(response);
				String t = st.nextToken();

				if (t.equals("i")) {
					/* search for a movie whose title matches a string */
					//if (st.hasMoreTokens()) {
						//String movie_title = st.nextToken("\n").trim(); /* read the rest of the line */
						/*System.out.println("Searching for the movie '"
								+ movie_title + "'");
						q.transaction_search(cid, movie_title);
					} else {
						System.out
								.println("Error: need to type in movie title");
					}*/
          System.out.print("Write your insert statement:");
          response = r.readLine();
          st = new StringTokenizer(response);
          if (st.hasMoreTokens()) {
            String query = st.nextToken("\n");
            System.out.println("Debug: " + query);
            System.out.println("Inserting query...");
            q.transaction_insert(query);
          } else {
						System.out
								.println("Error: need to type in an insert statement");
					}
          
				}

				else if (t.equals("u")) {
					/* choose a new rental plan, or, if none is given, then list all available plans */
					//if (st.hasMoreTokens()) {
						//int plan_id = Integer.parseInt(st.nextToken());
						/* need to check that plan_id is a valid plan id in the database, */
						/* if yes, then set the new plan for the current customer */
						/* if not, then list all available plans */
						/*boolean correct_plan = q.helper_check_plan(plan_id);
						if (correct_plan) {
							System.out.println("Switching to plan " + plan_id);
							q.transaction_choose_plan(cid, plan_id);
						} else {
							System.out.println("Incorrect plan id " + plan_id
									+ "\nAvailable plans are:");
							q.transaction_list_plans();
						}
					} else {
						System.out.println("Available plans:");
						q.transaction_list_plans();
					}*/
          System.out.print("Write your update statement:");
          response = r.readLine();
          st = new StringTokenizer(response);
          if (st.hasMoreTokens()) {
            String query = st.nextToken("\n");
            System.out.println("Updating query...");
            q.transaction_update(query); 
          } else {
						System.out
								.println("Error: need to type in an update statement");
					}
				}

				else if (t.equals("d")) {
					/* rent the movie with the given movie id */
					/*String movie_id = st.nextToken("\n").trim();
					System.out.println("Renting the movie id " + movie_id);
					q.transaction_rent(cid, movie_id);*/
          System.out.println("Write your delete statement:");
          response = r.readLine();
          st = new StringTokenizer(response);
          if (st.hasMoreTokens()) {
            String query = st.nextToken("\n");
            System.out.println("Deleting query...");
            q.transaction_delete(query); 
          } else {
						 System.out
								.println("Error: need to type in a delete statement");
					}
				}

				else if (t.equals("v")) {
          System.out.println("Would you like to see the queries or reports? (q or r)");
          response = r.readLine();
          st = new StringTokenizer(response);
          t = st.nextToken();
          if (t.equals("q")) {
            //list out 10 queries, have a case for each
            System.out.println("(1): Check if a given PC build is fully compatable");
            System.out.println("(2): List users with complete PC builds");
            System.out.println("(3): List the favorite parts of a user");
            System.out.println("(4): Get the oldest review of the oldest user");
            System.out.println("(5): Find the GPU in the most PC builds");
            System.out.println("(6): How many PCs use NVIDIA GPUs?");
            System.out.println("(7): All GPUs that are below the average price of a GPU");
            System.out.println("(8): What is the most expensive completed PC build?");
            System.out.println("(9): List all the users who have not built a PC");
            System.out.println("(10): List all of a certain manufacturer in a specific price range");
            response = r.readLine();
            st = new StringTokenizer(response);
            String num = st.nextToken();
            try {
              int n = Integer.parseInt(num);
              switch(n) {
                case 1:
                  System.out.println("What PC would you like to check? Provide PC ID");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String id = st.nextToken("\n");
                  System.out.println("Debug: " + id);
                  try {
                    int int_id = Integer.parseInt(id);
                    System.out.println("Debug: " + int_id);
                    //q.transaction_query(n, new String[]{id});
                    String[] x = new String[]{id};
                    q.transaction_query(n, x);
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 2:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 3:
                  System.out.println("What User would you like to check? Provide User ID");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String user_id = st.nextToken("\n");
                  try {
                    int int_id = Integer.parseInt(user_id);
                    q.transaction_query(n, new String[]{user_id});
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 4:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 5:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 6:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 7:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 8:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 9:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 10:
                  System.out.println("What manufacturer would you like to check?");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String manufacturer = st.nextToken("\n");
                  System.out.println("What is the lower price range you are looking for?");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String low = st.nextToken("\n");
                  try {
                    float low_f = Float.parseFloat(low);
                    //note: this does not check for specifically 2 decimal places. Not sure if it matters
                    System.out.println("What is the higher price range you are looking for?");
                    response = r.readLine();
                    st = new StringTokenizer(response);
                    String high = st.nextToken("\n");
                    try {
                      float high_f = Float.parseFloat(high);
                      q.transaction_query(n, new String[]{manufacturer, low, high});
                    } catch (Exception e) {
                    System.out.println("Error: " + e);
                    }
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                default:
                  System.out.println("Error: number not a valid query. Booting back to main loop.");
                  break;
              }
            } catch (Exception e) {
              System.out.println("Error: value input not a number. Booting back to main loop.");
            }
          }
          else if (t.equals("r")) {
            //list out 5 reports, have a switch case for each
            System.out.println("(1): Search parts by manufacturer, rating, and price");
            System.out.println("(2): Find 1-star recent reviews on items in a PC build");
            System.out.println("(3): All of the PC parts released since 2024 ranked by rating and popularity");
            System.out.println("(4): Manufacturer popularity by user, i.e. how many users using Intel parts");
            System.out.println("(5): List of all parts by average rating and review count");
            response = r.readLine();
            st = new StringTokenizer(response);
            String num = st.nextToken();
            try {
              int n = Integer.parseInt(num);
              switch(n) {
                case 1:
                  System.out.println("What manufacturer would you like to check?");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String manufacturer = st.nextToken("\n");
                  System.out.println("What is the lower bound on ratings you want?");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String rate = st.nextToken("\n");
                  try {
                      float rate_f = Float.parseFloat(rate);
                      System.out.println("What is the upper bound on price you want?");
                      response = r.readLine();
                      st = new StringTokenizer(response);
                      String price = st.nextToken("\n");
                      try {
                        float price_f = Float.parseFloat(price);
                        q.transaction_query(n, new String[]{manufacturer, rate, price});
                      } catch (Exception e) {
                        System.out.println("Error: " + e);
                      }
                    } catch (Exception e) {
                      System.out.println("Error: " + e);
                    }
                  break;
                case 2:
                  System.out.println("What PC would you like to check? Provide PC ID");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String id = st.nextToken("\n");
                  try {
                    int int_id = Integer.parseInt(id);
                    q.transaction_report(n, new String[]{id});
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 3:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 4:
                  System.out.println("What manufacturer would you like to check?");
                  response = r.readLine();
                  st = new StringTokenizer(response);
                  String manu = st.nextToken("\n");
                  q.transaction_report(n, new String[]{manu});
                  break;
                case 5:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_query(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                default:
                  System.out.println("Error: input invalid.");
                  break;
              }
            } catch (Exception e) {
              System.out.println("Error: value input not a number. Booting back to main loop.");
            }
          }
          else {
            System.out.println("Error: Invalid input, booting back to main loop");
          }
					/* return a movie previously rented */
					//String movie_id = st.nextToken("\n").trim();
					/* return the movie with mid */
					//System.out.println("Returning the movie id " + movie_id);
					//q.transaction_return(cid, movie_id);
				}

				//else if (t.equals("fastsearch")) {
					/* same as search, only faster */
					/*if (st.hasMoreTokens()) {
						String movie_title = st.nextToken("\n").trim();
						System.out.println("Fast Searching for the movie '"
								+ movie_title + "'");
						q.transaction_fast_search(cid, movie_title);
					} else {
						System.out
								.println("Error: need to type in movie title");
					}
				}*/

				else if (t.equals("quit")) {
					System.exit(0);
				}

				else {
					System.out.println("Error: unrecognized command '" + t
							+ "'");
				}

			} catch (Exception e) {
				System.out.println("Error: " + e.getMessage());
			}
		}
	}

	public static void main(String[] args) {

		/*if (args.length < 2)
		{
			System.out.println("Usage: java SQLassign CUSTOMER_ID CUSTOMER_PASSWORD");
			System.exit(1);
		}*/
		
		try {

			/* prepare the database connection stuff */
			Query q = new Query();
			q.openConnections();
			q.prepareStatements();
      menu(1, q);
      q.closeConnections();
			/* authenticate the user */
			//int cid = q.transaction_login(args[0], args[1]);			
			//if (cid >= 0)
			//	menu(cid, q); /* menu(...) does the real work */
			//else
			//	System.out.println("Sorry..."); /* innocent mistake, or malicious attack ? */
			//q.closeConnections();

		} catch (Exception e) {
			System.out.println("Error: " + e.getMessage());
		}

	}

}

