import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.Scanner;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.LinkedHashMap;

public class DeleteUpdateInsertStatements {

    private Connection _postgresConnection;

    public DeleteUpdateInsertStatements(Connection conn) {
        this._postgresConnection = conn;
    }

    // Helper Functions
    private boolean user_exists(Integer user_id) throws Exception {
        String sql = "SELECT 1 FROM Users WHERE user_id = ?";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, user_id);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int get_user_id() {
        Scanner sc = new Scanner(System.in);
        int userId = -1;

        System.out.print("Please enter a User ID: ");
        if (sc.hasNextInt()) {
            userId = sc.nextInt();
            
            // SQL query to check if the ID exists
            String query = "SELECT 1 FROM Users WHERE user_id = ?";
            
            try (PreparedStatement pstmt = this._postgresConnection.prepareStatement(query)) {
                pstmt.setInt(1, userId);
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("User ID " + userId + " exists.");
                    } else {
                        System.out.println("User ID " + userId + " does not exist.");
                        userId = -1; // Reset if not found
                    }
                }
            } catch (SQLException e) {
                System.out.println("Database error: " + e.getMessage());
                userId = -1;
            }
        } else {
            System.out.println("Invalid input. Please enter a numeric ID.");
        }
        
        return userId;
    }

    private boolean part_exists(Integer part_id) throws Exception {
        String sql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, part_id);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private int get_next_id(String tableName, String idColumn) throws Exception {
        String sql = "SELECT COALESCE(MAX(" + idColumn + "), 0) + 1 AS next_id FROM " + tableName;

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            rs.next();
            return rs.getInt("next_id");
        }
    }

    private String get_part_type(Integer part_id) throws Exception {
        String sql = "SELECT part_type FROM Part_Type_Map WHERE part_id = ?";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, part_id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return rs.getString("part_type");
            }
        }
    }

    public Timestamp get_review_timestamp(int user_id, int part_id) throws Exception {
        String sql = "SELECT created_on, review_text, rating FROM Reviews " +
                    "WHERE user_id = ? AND part_id = ? ORDER BY created_on DESC";
        
        List<Timestamp> timestamps = new ArrayList<>();
        
        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, user_id);
            stmt.setInt(2, part_id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                System.out.println("\n--- Your Reviews for Part #" + part_id + " ---");
                int count = 1;
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("created_on");
                    timestamps.add(ts);
                    
                    System.out.printf("[%d] Date: %s | Rating: %d/5\n", count, ts.toString(), rs.getInt("rating"));
                    System.out.println("    Text: " + rs.getString("review_text"));
                    count++;
                }
            }
        }

        if (timestamps.isEmpty()) {
            System.out.println("No reviews found for this user/part combination.");
            return null;
        }

        // Let the user pick by number
        Scanner sc = new Scanner(System.in);
        while (true) {
            System.out.print("\nSelect the review number to update/delete (or 0 to cancel): ");
            if (sc.hasNextInt()) {
                int choice = sc.nextInt();
                if (choice == 0) return null;
                if (choice > 0 && choice <= timestamps.size()) {
                    return timestamps.get(choice - 1);
                }
            } else {
                sc.next(); // clear invalid input
            }
            System.out.println("Invalid selection. Please try again.");
        }
    }

    // Insert Transaction Bridge Functions
    // Overload for CPU
    public void transaction_insert_cpu(Map<String, Object> data) throws Exception {
        transaction_insert_cpu(
            (String)  data.get("Socket"),
            (Integer) data.get("TDP"),
            (Integer) data.get("Core Count"),
            (Integer) data.get("Base Clock"),
            (Integer) data.get("Thread Count"),
            (Integer) data.get("Boost Clock"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for PSU
    public void transaction_insert_psu(Map<String, Object> data) throws Exception {
        transaction_insert_psu(
            (String)  data.get("Modular"),
            (Integer) data.get("Wattage"),
            (String)  data.get("Efficiency"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for RAM
    public void transaction_insert_ram(Map<String, Object> data) throws Exception {
        transaction_insert_ram(
            (String)  data.get("RAM Type"),
            (Integer) data.get("Number of Sticks"),
            (Integer) data.get("Capacity"),
            (Integer) data.get("Speed"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for GPU
    public void transaction_insert_gpu(Map<String, Object> data) throws Exception {
        transaction_insert_gpu(
            (Integer) data.get("VRAM"),
            (String)  data.get("Chipset"),
            (Integer) data.get("Length (mm)"),
            (String)  data.get("Power Connectors"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for Motherboard
    public void transaction_insert_mobo(Map<String, Object> data) throws Exception {
        transaction_insert_mobo(
            (String)  data.get("Socket"),
            (String)  data.get("Chipset"),
            (String)  data.get("RAM Type"),
            (String)  data.get("Form Factor"),
            (Integer) data.get("Max RAM"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for PC Case
    public void transaction_insert_pc_case(Map<String, Object> data) throws Exception {
        transaction_insert_pc_case(
            (Integer) data.get("Max GPU Size"),
            (String)  data.get("Form Factor"),
            (String)  data.get("Color"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Overload for CPU Cooler
    public void transaction_insert_cooler(Map<String, Object> data) throws Exception {
        transaction_insert_cooler(
            (String)  data.get("Cooler Type"),
            (String)  data.get("Socket Type"),
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }

    // Update Transaction Bridge Functions
    // PC_Part Update Overload
    public void transaction_update_pc_part(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_pc_part(
            part_id,
            (String)  data.get("Manufacturer"),
            (String)  data.get("Name"),
            (Float)   data.get("Price"),
            (String)  data.get("Description")
        );
    }
    // CPU Update Overload
    public void transaction_update_cpu(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_cpu(
            part_id,
            (String)  data.get("Socket"),
            (Integer) data.get("TDP"),
            (Integer) data.get("Core Count"),
            (Integer) data.get("Base Clock"),
            (Integer) data.get("Thread Count"),
            (Integer) data.get("Boost Clock")
        );
    }

    // PSU Update Overload
    public void transaction_update_psu(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_psu(
            part_id,
            (String)  data.get("Modular"),
            (Integer) data.get("Wattage"),
            (String)  data.get("Efficiency")
        );
    }

    // RAM Update Overload
    public void transaction_update_ram(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_ram(
            part_id,
            (String)  data.get("RAM Type"),
            (Integer) data.get("Number of Sticks"),
            (Integer) data.get("Capacity"),
            (Integer) data.get("Speed")
        );
    }

    // GPU Update Overload
    public void transaction_update_gpu(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_gpu(
            part_id,
            (Integer) data.get("VRAM"),
            (String)  data.get("Chipset"),
            (Integer) data.get("Length (mm)"),
            (String)  data.get("Power Connectors")
        );
    }

    // Motherboard Update Overload
    public void transaction_update_mobo(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_mobo(
            part_id,
            (String)  data.get("Socket"),
            (String)  data.get("Chipset"),
            (String)  data.get("RAM Type"),
            (String)  data.get("Form Factor"),
            (Integer) data.get("Max RAM")
        );
    }

    // PC Case Update Overload
    public void transaction_update_pc_case(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_pc_case(
            part_id,
            (Integer) data.get("Max GPU Size"),
            (String)  data.get("Form Factor"),
            (String)  data.get("Color")
        );
    }

    // Cooler Update Overload
    public void transaction_update_cooler(Integer part_id, Map<String, Object> data) throws Exception {
        transaction_update_cooler(
            part_id,
            (String)  data.get("Cooler Type"),
            (String)  data.get("Socket Type")
        );
    }

    // Inserts
    public void transaction_insert_user(String email, String username) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // 1. check email exists
            String checkEmailSql = "SELECT 1 FROM Users WHERE email = ?";
            PreparedStatement checkEmailStmt = _postgresConnection.prepareStatement(checkEmailSql);
            checkEmailStmt.setString(1, email);

            ResultSet rse = checkEmailStmt.executeQuery();

            if (rse.next()) {
                System.out.println("Email already in use.");
                rse.close();
                checkEmailStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rse.close();
            checkEmailStmt.close();

            // 2. check username exists
            String checkUsernameSql = "SELECT 1 FROM Users WHERE username = ?";
            PreparedStatement checkUsernameStmt = _postgresConnection.prepareStatement(checkUsernameSql);
            checkUsernameStmt.setString(1, username);

            ResultSet rsu = checkUsernameStmt.executeQuery();

            if (rsu.next()) {
                System.out.println("Username already in use.");
                rsu.close();
                checkUsernameStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rsu.close();
            checkUsernameStmt.close();

            // 3. get next user_id
            String idSql = "SELECT COALESCE(MAX(user_id), 0) + 1 AS next_id FROM Users";
            PreparedStatement idStmt = _postgresConnection.prepareStatement(idSql);

            ResultSet idRs = idStmt.executeQuery();

            int newUserId = 1;
            if (idRs.next()) {
                newUserId = idRs.getInt("next_id");
            }

            idRs.close();
            idStmt.close();

            // 4. insert user
            String insertSql = "INSERT INTO Users (user_id, email, username) VALUES (?, ?, ?)";
            PreparedStatement insertStmt = _postgresConnection.prepareStatement(insertSql);

            insertStmt.setInt(1, newUserId);
            insertStmt.setString(2, email);
            insertStmt.setString(3, username);

            insertStmt.executeUpdate();
            insertStmt.close();

            _postgresConnection.commit();

            System.out.println("INSERT SUCCESSFUL. New user_id = " + newUserId);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_favorite(Integer user_id, Integer part_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // 1. check user exists
            String checkUserSql = "SELECT 1 FROM Users WHERE user_id = ?";
            PreparedStatement checkUserStmt = _postgresConnection.prepareStatement(checkUserSql);
            checkUserStmt.setInt(1, user_id);

            ResultSet rsu = checkUserStmt.executeQuery();

            if (!rsu.next()) {
                System.out.println("User doesn't exist.");
                rsu.close();
                checkUserStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rsu.close();
            checkUserStmt.close();

            // 2. check part exists
            String checkPartSql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";
            PreparedStatement checkPartStmt = _postgresConnection.prepareStatement(checkPartSql);
            checkPartStmt.setInt(1, part_id);

            ResultSet rsp = checkPartStmt.executeQuery();

            if (!rsp.next()) {
                System.out.println("Part doesn't exist.");
                rsp.close();
                checkPartStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rsp.close();
            checkPartStmt.close();

            // 3. insert favorite
            String insertSql = "INSERT INTO Favorite_Parts (user_id, part_id) VALUES (?, ?)";
            PreparedStatement insertStmt = _postgresConnection.prepareStatement(insertSql);

            insertStmt.setInt(1, user_id);
            insertStmt.setInt(2, part_id);

            insertStmt.executeUpdate();
            insertStmt.close();

            _postgresConnection.commit();

            System.out.println("INSERT SUCCESSFUL. New user_id/part_id pair: " + user_id + "/" + part_id);
            
        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_review(Integer user_id, Integer part_id, Integer rating, String comment) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // 1. check user exists
            String checkUserSql = "SELECT 1 FROM Users WHERE user_id = ?";
            PreparedStatement checkUserStmt = _postgresConnection.prepareStatement(checkUserSql);
            checkUserStmt.setInt(1, user_id);

            ResultSet rsu = checkUserStmt.executeQuery();

            if (!rsu.next()) {
                System.out.println("User doesn't exist.");
                rsu.close();
                checkUserStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rsu.close();
            checkUserStmt.close();

            // 2. check part exists
            String checkPartSql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";
            PreparedStatement checkPartStmt = _postgresConnection.prepareStatement(checkPartSql);
            checkPartStmt.setInt(1, part_id);

            ResultSet rsp = checkPartStmt.executeQuery();

            if (!rsp.next()) {
                System.out.println("Part doesn't exist.");
                rsp.close();
                checkPartStmt.close();
                _postgresConnection.rollback();
                return;
            }

            rsp.close();
            checkPartStmt.close();

            // 3. insert review
            String insertSql = "INSERT INTO Part_review (user_id, part_id, review_time, rating, comment) VALUES (?, ?, CURRENT_DATE, ?, ?)";
            PreparedStatement insertStmt = _postgresConnection.prepareStatement(insertSql);

            insertStmt.setInt(1, user_id);
            insertStmt.setInt(2, part_id);
            insertStmt.setInt(3, rating);
            insertStmt.setString(4, comment);

            insertStmt.executeUpdate();
            insertStmt.close();

            _postgresConnection.commit();

            System.out.println("INSERT SUCCESSFUL. Review Details: " + user_id + " " + part_id + " " + rating + " " + comment);
            
        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    private int insert_pc_part(String manufacturer, String name, Float price, String description) throws Exception {

        int newPartId = get_next_id("PC_Parts", "part_id");

        String insertSql =
            "INSERT INTO PC_Parts (part_id, manufacturer, name, release_date, price, description) " +
            "VALUES (?, ?, ?, CURRENT_DATE, ?, ?)";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertSql)) {
            stmt.setInt(1, newPartId);
            stmt.setString(2, manufacturer);
            stmt.setString(3, name);
            stmt.setFloat(4, price);
            stmt.setString(5, description);

            stmt.executeUpdate();
        }

        return newPartId;
    }

    public void transaction_insert_cpu(String socket, Integer tdp, Integer core_count,
                               Integer base_clock, Integer thread_count, Integer boost_clock,
                               String manufacturer, String name, Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertCpuSql =
                "INSERT INTO CPU (part_id, socket, thermal_design_power, core_count, base_clock, thread_count, boost_clock) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertCpuSql)) {

                stmt.setInt(1, newPartId);
                stmt.setString(2, socket);
                stmt.setInt(3, tdp);
                stmt.setInt(4, core_count);
                stmt.setInt(5, base_clock);
                stmt.setInt(6, thread_count);
                stmt.setInt(7, boost_clock);

                stmt.executeUpdate();
            }

            // IMPORTANT: register type
            try (PreparedStatement typeStmt =
                    _postgresConnection.prepareStatement(
                        "INSERT INTO Part_Type_Map (part_id, part_type) VALUES (?, ?)")) {

                typeStmt.setInt(1, newPartId);
                typeStmt.setString(2, "CPU");
                typeStmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("CPU INSERT SUCCESSFUL. New CPU: " + manufacturer + " " + name);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_psu(String modular, Integer wattage, String efficiency,
                                String manufacturer, String name, Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertPsuSql =
                "INSERT INTO PSU (part_id, modular, wattage, efficiency) " +
                "VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertPsuSql)) {
                stmt.setInt(1, newPartId);
                stmt.setString(2, modular);
                stmt.setInt(3, wattage);
                stmt.setString(4, efficiency);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("PSU INSERT SUCCESSFUL. New PSU: \n" + manufacturer + " " + name + " " + wattage);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_ram(String ram_type, Integer num_of_sticks, Integer capacity,
                               Integer speed, String manufacturer, String name,
                               Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertRamSql =
                "INSERT INTO RAM (part_id, ram_type, num_of_sticks, capacity, speed) " +
                "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertRamSql)) {
                stmt.setInt(1, newPartId);
                stmt.setString(2, ram_type);
                stmt.setInt(3, num_of_sticks);
                stmt.setInt(4, capacity);
                stmt.setInt(5, speed);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("RAM INSERT SUCCESSFUL. New RAM: \n" + manufacturer + " " + name + " " + capacity);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_gpu(Integer vram, String chipset, Integer length_mm,
                               String power_connectors, String manufacturer,
                               String name, Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertGpuSql =
                "INSERT INTO GPU (part_id, vram, chipset, length_mm, power_connectors) " +
                "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertGpuSql)) {
                stmt.setInt(1, newPartId);
                stmt.setInt(2, vram);
                stmt.setString(3, chipset);
                stmt.setInt(4, length_mm);
                stmt.setString(5, power_connectors);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("GPU INSERT SUCCESSFUL. New GPU: \n" + manufacturer + " " + name + " " + vram);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_mobo(String socket, String chipset, String ram_type,
                                String form_factor, Integer max_ram,
                                String manufacturer, String name,
                                Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertMoboSql =
                "INSERT INTO Motherboard (part_id, socket, chipset, ram_type, form_factor, max_ram) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertMoboSql)) {
                stmt.setInt(1, newPartId);
                stmt.setString(2, socket);
                stmt.setString(3, chipset);
                stmt.setString(4, ram_type);
                stmt.setString(5, form_factor);
                stmt.setInt(6, max_ram);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("MOTHERBOARD INSERT SUCCESSFUL. New Motherboard: \n" +
                            manufacturer + " " + name + " " + socket + " " + chipset);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_pc_case(Integer max_gpu_size, String form_factor, String color,
                                   String manufacturer, String name,
                                   Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertCaseSql =
                "INSERT INTO PC_Case (part_id, max_gpu_size, form_factor, color) " +
                "VALUES (?, ?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertCaseSql)) {
                stmt.setInt(1, newPartId);
                stmt.setInt(2, max_gpu_size);
                stmt.setString(3, form_factor);
                stmt.setString(4, color);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("PC CASE INSERT SUCCESSFUL. New PC Case: \n" +
                            manufacturer + " " + name + " " + form_factor);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_cooler(String cooler_type, String socket_type,
                                  String manufacturer, String name,
                                  Float price, String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            int newPartId = insert_pc_part(manufacturer, name, price, description);

            String insertCoolerSql =
                "INSERT INTO Cooler (part_id, cooler_type, socket_type) " +
                "VALUES (?, ?, ?)";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(insertCoolerSql)) {
                stmt.setInt(1, newPartId);
                stmt.setString(2, cooler_type);
                stmt.setString(3, socket_type);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("COOLER INSERT SUCCESSFUL. New Cooler: \n" +
                            manufacturer + " " + name + " " + cooler_type);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("INSERT ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_insert_pc(String name, List<Integer> parts) throws Exception {

        try {
            // 1. Validation checks using List methods
            if (parts == null || parts.isEmpty()) {
                throw new IllegalArgumentException("Parts list cannot be empty.");
            }

            if (parts.size() > 7) {
                throw new InvalidPartCountException("Parts list exceeds 7 items.");
            }

            // 2. Get the User ID (calling your existing helper)
            int user_id = get_user_id();
            if (user_id == -1) {
                System.out.println("Transaction cancelled: Invalid User ID.");
                return;
            }

            _postgresConnection.setAutoCommit(false);

            // 3. Get next pc_id
            String idSql = "SELECT COALESCE(MAX(pc_id), 0) + 1 AS next_id FROM PCs";
            int newPcId;
            try (PreparedStatement idStmt = _postgresConnection.prepareStatement(idSql);
                ResultSet idRs = idStmt.executeQuery()) {
                idRs.next();
                newPcId = idRs.getInt("next_id");
            }

            // 4. Classify parts using Part_Type_Map
            Map<String, Integer> selectedParts = new HashMap<>();
            Set<Integer> seen = new HashSet<>();
            String typeSql = "SELECT part_type FROM Part_Type_Map WHERE part_id = ?";

            try (PreparedStatement typeStmt = _postgresConnection.prepareStatement(typeSql)) {
                for (Integer partId : parts) {
                    if (partId == null) {
                        throw new IllegalArgumentException("Null part_id found in input.");
                    }

                    // Check for duplicates in the list
                    if (!seen.add(partId)) {
                        throw new IllegalArgumentException("Duplicate part_id in input: " + partId);
                    }

                    typeStmt.setInt(1, partId);
                    String type;
                    try (ResultSet rs = typeStmt.executeQuery()) {
                        if (!rs.next()) {
                            throw new IllegalArgumentException("Unknown part_id: " + partId);
                        }
                        type = rs.getString("part_type");
                    }

                    // Prevent multiple parts of the same category (e.g., two CPUs)
                    if (selectedParts.containsKey(type)) {
                        throw new IllegalArgumentException("Multiple parts of type " + type + " are not allowed.");
                    }
                    selectedParts.put(type, partId);
                }
            }

            // 5. Insert the new PC record
            String insertSql = "INSERT INTO PCs " +
                "(pc_id, name, user_id, cpu, psu, ram_kit, gpu, motherboard, pc_case, cooler, created_on) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

            try (PreparedStatement insertStmt = _postgresConnection.prepareStatement(insertSql)) {
                insertStmt.setInt(1, newPcId);
                insertStmt.setString(2, name);
                insertStmt.setInt(3, user_id);
                // using setObject handles potential nulls if the user submitted < 7 parts
                insertStmt.setObject(4, selectedParts.get("CPU"));
                insertStmt.setObject(5, selectedParts.get("PSU"));
                insertStmt.setObject(6, selectedParts.get("RAM"));
                insertStmt.setObject(7, selectedParts.get("GPU"));
                insertStmt.setObject(8, selectedParts.get("MOTHERBOARD"));
                insertStmt.setObject(9, selectedParts.get("PC_CASE"));
                insertStmt.setObject(10, selectedParts.get("COOLER"));

                insertStmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("INSERT SUCCESSFUL. New PC: " + name + " (" + parts.size() + "/7 parts added)");

        } catch (Exception e) {
            if (_postgresConnection != null) {
                _postgresConnection.rollback();
            }
            System.out.println("INSERT ERROR: " + e.getMessage());
            throw e; // Re-throw to handle it in your main menu if needed
        } finally {
            if (_postgresConnection != null) {
                _postgresConnection.setAutoCommit(true);
            }
        }
    }

    // Updates

    public void transaction_update_user(Integer user_id, String email, String username) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // validate user exists
            String checkSql = "SELECT 1 FROM Users WHERE user_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, user_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("User does not exist: " + user_id);
                    }
                }
            }

            String updateSql =
                "UPDATE Users SET email = ?, username = ? WHERE user_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, email);
                stmt.setString(2, username);
                stmt.setInt(3, user_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("UPDATE SUCCESSFUL. User updated: " + user_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_favorite(Integer user_id, Integer old_part_id, Integer new_part_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String updateSql =
                "UPDATE Favorite_Parts SET part_id = ? WHERE user_id = ? AND part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setInt(1, new_part_id);
                stmt.setInt(2, user_id);
                stmt.setInt(3, old_part_id);

                int rows = stmt.executeUpdate();

                if (rows == 0) {
                    throw new IllegalArgumentException("Favorite entry not found.");
                }
            }

            _postgresConnection.commit();

            System.out.println("UPDATE SUCCESSFUL. Favorite updated.");

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_review(Integer user_id, Integer part_id, Integer rating, String comment) throws Exception {
        // 1. Let the user pick which review to update using the helper
        Timestamp review_time = get_review_timestamp(user_id, part_id);
        if (review_time == null) return;

        try {
            _postgresConnection.setAutoCommit(false);

            String updateSql = "UPDATE Part_Review SET rating = ?, review_text = ? " +
                            "WHERE user_id = ? AND part_id = ? AND review_time = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setInt(1, rating);
                stmt.setString(2, comment);
                stmt.setInt(3, user_id);
                stmt.setInt(4, part_id);
                stmt.setTimestamp(5, review_time);

                int rows = stmt.executeUpdate();
                if (rows == 0) {
                    throw new SQLException("Update failed: Review no longer exists.");
                }
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. Review has been modified.");

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_pc(Integer pc_id,
                                  String name,
                                  List<Integer> part_ids) throws Exception {

        if (part_ids == null || part_ids.isEmpty()) {
            throw new IllegalArgumentException(
                "At least one part_id is required."
            );
        }

        if (part_ids.size() > 7) {
            throw new IllegalArgumentException(
                "Maximum of 7 part_ids allowed."
            );
        }

        // Component slots
        Integer cpu = null;
        Integer psu = null;
        Integer ram_kit = null;
        Integer gpu = null;
        Integer motherboard = null;
        Integer pc_case = null;
        Integer cooler = null;

        try {
            _postgresConnection.setAutoCommit(false);

            // Verify PC exists
            String checkPcSql =
                "SELECT 1 FROM PCs WHERE pc_id = ?";

            try (PreparedStatement checkStmt =
                    _postgresConnection.prepareStatement(checkPcSql)) {

                checkStmt.setInt(1, pc_id);

                try (ResultSet rs = checkStmt.executeQuery()) {

                    if (!rs.next()) {
                        throw new IllegalArgumentException(
                            "PC does not exist: " + pc_id
                        );
                    }
                }
            }

            // Process each part_id
            for (Integer part_id : part_ids) {

                // Verify part exists
                if (!part_exists(part_id)) {
                    throw new IllegalArgumentException(
                        "Part does not exist: " + part_id
                    );
                }

                // Determine part type
                String partType = get_part_type(part_id);

                if (partType == null) {
                    throw new IllegalArgumentException(
                        "No part type found for part_id: " + part_id
                    );
                }

                switch (partType.toLowerCase()) {

                    case "cpu":
                        cpu = part_id;
                        break;

                    case "psu":
                        psu = part_id;
                        break;

                    case "ram":
                        ram_kit = part_id;
                        break;

                    case "gpu":
                        gpu = part_id;
                        break;

                    case "motherboard":
                        motherboard = part_id;
                        break;

                    case "pc_case":
                        pc_case = part_id;
                        break;

                    case "cooler":
                        cooler = part_id;
                        break;

                    default:
                        throw new IllegalArgumentException(
                            "Unknown part type: " + partType
                        );
                }
            }

            // Update the PC
            String updateSql =
                "UPDATE PCs SET " +
                "name = ?, " +
                "cpu = ?, " +
                "psu = ?, " +
                "ram_kit = ?, " +
                "gpu = ?, " +
                "motherboard = ?, " +
                "pc_case = ?, " +
                "cooler = ? " +
                "WHERE pc_id = ?";

            try (PreparedStatement stmt =
                    _postgresConnection.prepareStatement(updateSql)) {

                stmt.setString(1, name);

                stmt.setObject(2, cpu);
                stmt.setObject(3, psu);
                stmt.setObject(4, ram_kit);
                stmt.setObject(5, gpu);
                stmt.setObject(6, motherboard);
                stmt.setObject(7, pc_case);
                stmt.setObject(8, cooler);

                stmt.setInt(9, pc_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println(
                "UPDATE SUCCESSFUL. PC updated: " + pc_id
            );

        } catch (Exception e) {

            _postgresConnection.rollback();

            System.out.println(
                "UPDATE ERROR: " + e.getMessage()
            );

            throw e;

        } finally {

            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_pc_part(Integer part_id,
                                      String manufacturer,
                                      String name,
                                      Float price,
                                      String description) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // validate part exists
            String checkSql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Part does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE PC_Parts SET manufacturer = ?, name = ?, price = ?, description = ? " +
                "WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, manufacturer);
                stmt.setString(2, name);
                stmt.setFloat(3, price);
                stmt.setString(4, description);
                stmt.setInt(5, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("UPDATE SUCCESSFUL. PC_Part updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_cpu(Integer part_id,
                                  String socket,
                                  Integer tdp,
                                  Integer core_count,
                                  Integer base_clock,
                                  Integer thread_count,
                                  Integer boost_clock) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM CPU WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("CPU does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE CPU SET socket = ?, thermal_design_power = ?, core_count = ?, " +
                "base_clock = ?, thread_count = ?, boost_clock = ? WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, socket);
                stmt.setInt(2, tdp);
                stmt.setInt(3, core_count);
                stmt.setInt(4, base_clock);
                stmt.setInt(5, thread_count);
                stmt.setInt(6, boost_clock);
                stmt.setInt(7, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. CPU updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_gpu(Integer part_id,
                                  Integer vram,
                                  String chipset,
                                  Integer length_mm,
                                  String power_connectors) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM GPU WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("GPU does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE GPU SET vram = ?, chipset = ?, length_mm = ?, power_connectors = ? " +
                "WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setInt(1, vram);
                stmt.setString(2, chipset);
                stmt.setInt(3, length_mm);
                stmt.setString(4, power_connectors);
                stmt.setInt(5, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. GPU updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_ram(Integer part_id,
                                  String ram_type,
                                  Integer num_of_sticks,
                                  Integer capacity,
                                  Integer speed) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM RAM WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("RAM does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE RAM SET ram_type = ?, num_of_sticks = ?, capacity = ?, speed = ? " +
                "WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, ram_type);
                stmt.setInt(2, num_of_sticks);
                stmt.setInt(3, capacity);
                stmt.setInt(4, speed);
                stmt.setInt(5, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. RAM updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_psu(Integer part_id,
                                  String modular,
                                  Integer wattage,
                                  String efficiency) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM PSU WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("PSU does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE PSU SET modular = ?, wattage = ?, efficiency = ? WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, modular);
                stmt.setInt(2, wattage);
                stmt.setString(3, efficiency);
                stmt.setInt(4, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. PSU updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_mobo(Integer part_id,
                                          String socket,
                                          String chipset,
                                          String ram_type,
                                          String form_factor,
                                          Integer max_ram) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM Motherboard WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Motherboard does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE Motherboard SET socket = ?, chipset = ?, ram_type = ?, form_factor = ?, max_ram = ? " +
                "WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, socket);
                stmt.setString(2, chipset);
                stmt.setString(3, ram_type);
                stmt.setString(4, form_factor);
                stmt.setInt(5, max_ram);
                stmt.setInt(6, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. Motherboard updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_pc_case(Integer part_id,
                                      Integer max_gpu_size,
                                      String form_factor,
                                      String color) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM PC_Case WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("PC Case does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE PC_Case SET max_gpu_size = ?, form_factor = ?, color = ? WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setInt(1, max_gpu_size);
                stmt.setString(2, form_factor);
                stmt.setString(3, color);
                stmt.setInt(4, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. PC Case updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_update_cooler(Integer part_id,
                                      String cooler_type,
                                      String socket_type) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM Cooler WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Cooler does not exist: " + part_id);
                    }
                }
            }

            String updateSql =
                "UPDATE Cooler SET cooler_type = ?, socket_type = ? WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
                stmt.setString(1, cooler_type);
                stmt.setString(2, socket_type);
                stmt.setInt(3, part_id);

                stmt.executeUpdate();
            }

            _postgresConnection.commit();
            System.out.println("UPDATE SUCCESSFUL. Cooler updated: " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    // Deletes
    public void transaction_delete_pc_part(Integer part_id) throws Exception {
        try {
            _postgresConnection.setAutoCommit(false);

            // 1. Validate existence
            String checkSql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, part_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Part does not exist: " + part_id);
                    }
                }
            }

            // 2. Delete from PC_Parts (CASCADE handles everything else)
            String deleteSql = "DELETE FROM PC_Parts WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, part_id);
                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Removed part_id = " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_delete_user(Integer user_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            // 1. validate user exists
            String checkSql = "SELECT 1 FROM Users WHERE user_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, user_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("User does not exist: " + user_id);
                    }
                }
            }

            // 2. delete user (CASCADE handles PCs, favorites, reviews)
            String deleteSql = "DELETE FROM Users WHERE user_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, user_id);
                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Removed user_id = " + user_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_delete_pc(Integer pc_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String checkSql = "SELECT 1 FROM PCs WHERE pc_id = ?";

            try (PreparedStatement checkStmt = _postgresConnection.prepareStatement(checkSql)) {
                checkStmt.setInt(1, pc_id);

                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("PC does not exist: " + pc_id);
                    }
                }
            }

            String deleteSql = "DELETE FROM PCs WHERE pc_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, pc_id);
                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Removed pc_id = " + pc_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_delete_review(Integer user_id, Integer part_id) throws Exception {
        Timestamp review_time = get_review_timestamp(user_id, part_id);
        if (review_time == null) return; // User cancelled or no reviews

        try {
            _postgresConnection.setAutoCommit(false);

            String deleteSql =
                "DELETE FROM Part_Review WHERE user_id = ? AND part_id = ? AND review_time = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, user_id);
                stmt.setInt(2, part_id);
                stmt.setTimestamp(3, review_time);

                int rows = stmt.executeUpdate();

                if (rows == 0) {
                    throw new IllegalArgumentException("No matching review found.");
                }
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Review removed.");

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_delete_favorite(Integer user_id, Integer part_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String deleteSql =
                "DELETE FROM Favorite_Parts WHERE user_id = ? AND part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, user_id);
                stmt.setInt(2, part_id);

                int rows = stmt.executeUpdate();

                if (rows == 0) {
                    throw new IllegalArgumentException("Favorite does not exist.");
                }
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Favorite removed.");

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }
}