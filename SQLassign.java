import java.util.StringTokenizer;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;

public class SQLassign {

  static Scanner scanner = new Scanner(System.in);

	public static void usage() {
		/* prints the choices for commands and parameters */
		System.out.println("\n *** Please enter one of the following commands *** ");
    System.out.println("> insert entry (i)");
    System.out.println("> update entry (u)");
    System.out.println("> delete entry (d)");
    System.out.println("> view queries and reports (v)");
    System.out.println("> quit (quit)");
	}

  public static void operation_choices() {
    System.out.println("(1): User");
    System.out.println("(2): Part");
    System.out.println("(3): PC");
    System.out.println("(4): Favorite Part");
    System.out.println("(5): Review");
  }

  public static void part_choices() {
    System.out.println("(1): CPU");
    System.out.println("(2): GPU");
    System.out.println("(3): RAM");
    System.out.println("(4): PSU");
    System.out.println("(5): Case");
    System.out.println("(6): CPU Cooler");
    System.out.println("(7): Motherboard");
  }

  public static List<Integer> get_part_ids() {
    List<Integer> numbers = new ArrayList<>();

    System.out.println("Enter up to 7 unique integers.");
    System.out.println("Type 'done' to finish early.");

    while (numbers.size() < 7) {
      System.out.print("Enter integer #" + (numbers.size() + 1) + ": ");
      String input = scanner.nextLine();

      // Allow early submission
      if (input.equalsIgnoreCase("done")) {
        if (numbers.isEmpty()) {
          System.out.println("You must enter at least one number.");
          continue;
        }
        break;
      }

      try {
        int number = Integer.parseInt(input);

        // Prevent duplicates
        if (numbers.contains(number)) {
          System.out.println("Duplicate numbers are not allowed.");
        } else {
          numbers.add(number);
        }

      } catch (NumberFormatException e) {
        System.out.println("Invalid input. Please enter an integer or 'done'.");
      }
    }

    return numbers;
  }

	public static void menu(int cid, Query q) {
		/* cid = customer id (obtained from the command line) */

		/* prepare to read the user's command and parameter(s) */
		String response = null;
    Map<String, Class<?>> schema;
    Map<String, Object> results;

		while (true) {

			try {

				usage();

				response = scanner.nextLine();

				StringTokenizer st = new StringTokenizer(response);
				String t = st.nextToken();

				if (t.equals("i")) {
          System.out.println("What information would you like to insert?");
          operation_choices();
          response = scanner.nextLine();
          st = new StringTokenizer(response);
          String num = st.nextToken();
          try {
            int n = Integer.parseInt(num);
            switch(n) {
              case 1: // New User
                System.out.println("Please provide a username and email.");
                schema = new LinkedHashMap<>();
                schema.put("username", String.class);
                schema.put("email", String.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_insert_user((String) results.get("email"), (String) results.get("username"));
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 2: // New Part
                System.out.println("What kind of part would you like to insert?");
                part_choices();
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                num = st.nextToken();
                try {
                  n = Integer.parseInt(num);
                  q.transaction_insert_part(n);
                }
                catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 3: // New PC
                System.out.println("What is the name of your new PC build?");
                t = scanner.nextLine();
                System.out.println("Please provide all Part IDs for your new PC.");
                try {
                  q.transaction_insert_pc(t, get_part_ids());
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 4: // New Favorite Part
                System.out.println("Please provide your User ID and the Part ID of your new Favorite.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("part ID", Integer.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_insert_favorite((Integer) results.get("user ID"), (Integer) results.get("part ID"));
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 5: // New Review
                System.out.println("Please provide your User ID, the Part ID that you are reviewing, a rating, and a comment about your experience with that part.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("part ID", Integer.class);
                schema.put("rating", Integer.class);
                schema.put("comment", String.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_insert_review((Integer) results.get("user ID"), (Integer) results.get("part ID"), (Integer) results.get("rating"), (String) results.get("comment"));
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

				else if (t.equals("u")) {
          System.out.println("What information would you like to update?");
          operation_choices();
          response = scanner.nextLine();
          st = new StringTokenizer(response);
          String num = st.nextToken();
          try {
            int n = Integer.parseInt(num);
            switch(n) {
              case 1: // Update User
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("username", String.class);
                schema.put("email", String.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_update_user((Integer) results.get("user ID"), (String) results.get("email"), (String) results.get("username"));
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 2: // Update Part
                System.out.println("What kind of part would you like to update?");
                part_choices();
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                num = st.nextToken();
                try {
                  n = Integer.parseInt(num);
                  q.transaction_update_part(n);
                }
                catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 3: // Update PC
                System.out.println("What is the ID of the PC you'd like to update?");
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                int pc_id = Integer.parseInt(st.nextToken());
                System.out.println("What is the new name of your new PC build?");
                t = scanner.nextLine();
                System.out.println("Please provide all Part IDs for your new PC.");
                try {
                  q.transaction_update_pc(pc_id, t, get_part_ids());
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 4: // Update Favorite Part
                System.out.println("Please provide your User ID, the current favorite you'd like to replace, and the new favorite you'd like to replace it with.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("old part ID", Integer.class);
                schema.put("new part ID", Integer.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_update_favorite((Integer) results.get("user ID"), (Integer) results.get("old part ID"), (Integer) results.get("new part ID"));
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 5: // Update Review
                System.out.println("Please provide your User ID, the Part ID that you are reviewing, a rating, and a comment about your experience with that part.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("part ID", Integer.class);

                // 2. Gather the new content for the review
                schema.put("new rating (1-5)", Integer.class);
                schema.put("new comments", String.class);
                
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_update_review((Integer) results.get("user ID"), (Integer) results.get("part ID"), (Integer) results.get("new rating (1-5)"), (String) results.get("new comments"));
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

				else if (t.equals("d")) {
          System.out.println("What information would you like to delete?");
          operation_choices();
          response = scanner.nextLine();
          st = new StringTokenizer(response);
          String num = st.nextToken();
          String user_id;
          try {
            int n = Integer.parseInt(num);
            switch(n) {
              case 1: // Delete User
                System.out.println("Please provide the User ID you would like to delete.");
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                user_id = st.nextToken("\n");
                  try {
                    int int_id = Integer.parseInt(user_id);
                    q.transaction_delete_user(int_id);
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
              case 2: // Delete Part
                System.out.println("Please provide the Part ID you would like to delete.");
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                user_id = st.nextToken("\n");
                  try {
                    int int_id = Integer.parseInt(user_id);
                    q.transaction_delete_pc_part(int_id);
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                break;
              case 3: // Delete PC
                System.out.println("Please provide the PC ID you would like to delete.");
                response = scanner.nextLine();
                st = new StringTokenizer(response);
                user_id = st.nextToken("\n");
                  try {
                    int int_id = Integer.parseInt(user_id);
                    q.transaction_delete_pc(int_id);
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                break;
              case 4: // Delete Favorite Part
                System.out.println("Please provide your User ID and the current favorite you'd like to delete.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("part ID", Integer.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_delete_favorite((Integer) results.get("user ID"), (Integer) results.get("part ID"));
                } catch (Exception e) {
                  System.out.println("Error: " + e);
                }
                break;
              case 5: // Delete Review
                System.out.println("Please provide your User ID, the Part ID for the review you'd like to delete.");
                schema = new LinkedHashMap<>();
                schema.put("user ID", Integer.class);
                schema.put("part ID", Integer.class);
                results = q.get_typed_inputs(schema);
                try {
                  q.transaction_delete_review((Integer) results.get("user ID"), (Integer) results.get("part ID"));
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

				else if (t.equals("v")) {
          System.out.println("Would you like to see the queries or reports? (q or r)");
          response = scanner.nextLine();
          st = new StringTokenizer(response);
          t = st.nextToken();
          if (t.equals("q")) {
            //list out 10 queries, have a case for each
            System.out.println("(1): Check if a given PC build is fully compatable");
            System.out.println("(2): List users with complete PC builds");
            System.out.println("(3): List the total value of all favorite parts of a user");
            System.out.println("(4): Get the oldest review of the oldest user");
            System.out.println("(5): Find the GPU in the most PC builds");
            System.out.println("(6): How many PCs use NVIDIA GPUs?");
            System.out.println("(7): All GPUs that are below the average price of a GPU");
            System.out.println("(8): What is the most expensive completed PC build?");
            System.out.println("(9): List all the users who have not built a PC");
            System.out.println("(10): List all of a certain manufacturer in a specific price range");
            response = scanner.nextLine();
            st = new StringTokenizer(response);
            String num = st.nextToken();
            try {
              int n = Integer.parseInt(num);
              switch(n) {
                case 1:
                  System.out.println("What PC would you like to check? Provide PC ID");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String id = st.nextToken("\n");
                  try {
                    q.transaction_query(n, new String[]{id});
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
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String user_id = st.nextToken("\n");
                  try {
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
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String manufacturer = st.nextToken("\n");
                  System.out.println("What is the lower price range you are looking for?");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String low = st.nextToken("\n");
                  try {
                    //note: this does not check for specifically 2 decimal places. Not sure if it matters
                    System.out.println("What is the higher price range you are looking for?");
                    response = scanner.nextLine();
                    st = new StringTokenizer(response);
                    String high = st.nextToken("\n");
                    try {
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
            response = scanner.nextLine();
            st = new StringTokenizer(response);
            String num = st.nextToken();
            try {
              int n = Integer.parseInt(num);
              switch(n) {
                case 1:
                  System.out.println("What manufacturer would you like to check?");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String manufacturer = st.nextToken("\n");
                  System.out.println("What is the lower bound on ratings you want?");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String rate = st.nextToken("\n");
                  try {
                      System.out.println("What is the upper bound on price you want?");
                      response = scanner.nextLine();
                      st = new StringTokenizer(response);
                      String price = st.nextToken("\n");
                      try {
                        q.transaction_report(n, new String[]{manufacturer, price, rate});
                      } catch (Exception e) {
                        System.out.println("Error: " + e);
                      }
                    } catch (Exception e) {
                      System.out.println("Error: " + e);
                    }
                  break;
                case 2:
                  System.out.println("What PC would you like to check? Provide PC ID");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String id = st.nextToken("\n");
                  try {
                    q.transaction_report(n, new String[]{id});
                  } catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 3:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_report(n, null);
                  }
                  catch (Exception e) {
                    System.out.println("Error: " + e);
                  }
                  break;
                case 4:
                  System.out.println("What manufacturer would you like to check?");
                  response = scanner.nextLine();
                  st = new StringTokenizer(response);
                  String manu = st.nextToken("\n");
                  q.transaction_report(n, new String[]{manu});
                  break;
                case 5:
                  System.out.println("Query processing...");
                  try {
                    q.transaction_report(n, null);
                  }
                  catch (Exception e) {
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
          else {
            System.out.println("Error: Invalid input, booting back to main loop");
          }
				}

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
		
		try {

			/* prepare the database connection stuff */
			Query q = new Query();
      q.setScanner(scanner);
			q.openConnections();
			q.prepareStatements();
      menu(1, q);
      q.closeConnections();
      scanner.close();

		} catch (Exception e) {
			System.out.println("Error: " + e.getMessage());
		}

	}

}

