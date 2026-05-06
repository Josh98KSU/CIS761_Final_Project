import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Map;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.Scanner;

// Potentially simplify further, abstract functions to more helper functions.

public class DeleteUpdateInsertStatements{

    private Connection _postgresConnection;

    // Helper Functions
    private boolean userExists(Integer user_id) throws Exception {
        String sql = "SELECT 1 FROM Users WHERE user_id = ?";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, user_id);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean partExists(Integer part_id) throws Exception {
        String sql = "SELECT 1 FROM PC_Parts WHERE part_id = ?";

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql)) {
            stmt.setInt(1, part_id);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private int getNextId(String tableName, String idColumn) throws Exception {
        String sql = "SELECT COALESCE(MAX(" + idColumn + "), 0) + 1 AS next_id FROM " + tableName;

        try (PreparedStatement stmt = _postgresConnection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {

            rs.next();
            return rs.getInt("next_id");
        }
    }

    private String getPartType(Integer part_id) throws Exception {
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
            String insertSql = "INSERT INTO Users (user_id, email, username, created_on) VALUES (?, ?, ?, CURRENT_DATE)";
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
            insertStmt.setInt(4, rating);
            insertStmt.setString(5, comment);

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

        int newPartId = getNextId("PC_Parts", "part_id");

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

    public void transaction_insert_pc(String name, Integer[] parts) throws Exception {

        try {
            if (parts == null || parts.length == 0) {
                throw new IllegalArgumentException("Parts list cannot be empty.");
            }

            if (parts.length > 7) {
                throw new InvalidPartCountException(
                    "Transaction failed: Parts list exceeds 7 items."
                );
            }

            int user_id = get_user_id();

            _postgresConnection.setAutoCommit(false);

            // 1. Get next pc_id
            String idSql = "Select coalesce(max(pc_id), 0) + 1 as next_id from PCs";

            int newPcId;

            try (PreparedStatement idStmt = _postgresConnection.prepareStatement(idSql);
                ResultSet idRs = idStmt.executeQuery()) {

                idRs.next();
                newPcId = idRs.getInt("next_id");
            }

            // 2. Classify parts using Part_Type_Map
            Map<String, Integer> selectedParts = new HashMap<>();
            Set<Integer> seen = new HashSet<>();

            String typeSql = "Select part_type from Part_Type_Map where part_id = ?";

            try (PreparedStatement typeStmt = _postgresConnection.prepareStatement(typeSql)) {

                for (Integer partId : parts) {

                    if (partId == null) {
                        throw new IllegalArgumentException("Null part_id found in input.");
                    }

                    if (!seen.add(partId)) {
                        throw new IllegalArgumentException(
                            "Duplicate part_id in input: " + partId
                        );
                    }

                    typeStmt.setInt(1, partId);

                    String type;
                    try (ResultSet rs = typeStmt.executeQuery()) {
                        if (!rs.next()) {
                            throw new IllegalArgumentException(
                                "Unknown part_id: " + partId
                            );
                        }
                        type = rs.getString("part_type");
                    }

                    if (selectedParts.containsKey(type)) {
                        throw new IllegalArgumentException(
                            "Multiple parts of type " + type + " are not allowed."
                        );
                    }

                    selectedParts.put(type, partId);
                }
            }

            // 3. Extract typed parts
            Integer cpu = selectedParts.get("CPU");
            Integer psu = selectedParts.get("PSU");
            Integer ram_kit = selectedParts.get("RAM");
            Integer gpu = selectedParts.get("GPU");
            Integer motherboard = selectedParts.get("MOTHERBOARD");
            Integer pc_case = selectedParts.get("PC_CASE");
            Integer cooler = selectedParts.get("COOLER");

            // 4. Insert PC
            String insertSql =
                "INSERT INTO PCs " +
                "(pc_id, name, user_id, cpu, psu, ram_kit, gpu, motherboard, pc_case, cooler, created_on) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

            try (PreparedStatement insertStmt =
                    _postgresConnection.prepareStatement(insertSql)) {

                insertStmt.setInt(1, newPcId);
                insertStmt.setString(2, name);
                insertStmt.setInt(3, user_id); // must exist in your class context
                insertStmt.setObject(4, cpu);
                insertStmt.setObject(5, psu);
                insertStmt.setObject(6, ram_kit);
                insertStmt.setObject(7, gpu);
                insertStmt.setObject(8, motherboard);
                insertStmt.setObject(9, pc_case);
                insertStmt.setObject(10, cooler);

                insertStmt.executeUpdate();
            }

            // 5. Commit
            _postgresConnection.commit();

            System.out.println(
                "INSERT SUCCESSFUL. New PC: " +
                name + " (" + parts.length + "/7 parts added)"
            );

        } catch (Exception e) {

            _postgresConnection.rollback();

            System.out.println("INSERT ERROR: " + e.getMessage());

        } finally {

            _postgresConnection.setAutoCommit(true);
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

    public void transaction_update_pc(Integer pc_id,
                                 String name,
                                 Integer cpu,
                                 Integer psu,
                                 Integer ram_kit,
                                 Integer gpu,
                                 Integer motherboard,
                                 Integer pc_case,
                                 Integer cooler) throws Exception {

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

            String updateSql =
                "UPDATE PCs SET name = ?, cpu = ?, psu = ?, ram_kit = ?, gpu = ?, " +
                "motherboard = ?, pc_case = ?, cooler = ? WHERE pc_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(updateSql)) {
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

            System.out.println("UPDATE SUCCESSFUL. PC updated: " + pc_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("UPDATE ERROR: " + e.getMessage());
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

    public void transaction_update_motherboard(Integer part_id,
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

    public void transaction_delete_reviews_for_part(Integer part_id) throws Exception {

        try {
            _postgresConnection.setAutoCommit(false);

            String deleteSql = "DELETE FROM Part_Review WHERE part_id = ?";

            try (PreparedStatement stmt = _postgresConnection.prepareStatement(deleteSql)) {
                stmt.setInt(1, part_id);
                stmt.executeUpdate();
            }

            _postgresConnection.commit();

            System.out.println("DELETE SUCCESSFUL. Removed reviews for part_id = " + part_id);

        } catch (Exception e) {
            _postgresConnection.rollback();
            System.out.println("DELETE ERROR: " + e.getMessage());
        } finally {
            _postgresConnection.setAutoCommit(true);
        }
    }

    public void transaction_delete_review(Integer user_id, Integer part_id, java.sql.Timestamp review_time) throws Exception {

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